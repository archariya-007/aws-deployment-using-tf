################################################################################
# Cluster
################################################################################
resource "aws_ecs_cluster" "health-communication-cluster" {
  name = "health-communication-cluster-tf"
}

data "aws_iam_policy_document" "ecstaskexecution-assume-role-policy-document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
################################################################################
# Roles
################################################################################

resource "aws_iam_role" "health-communication-task-execution-role" {
  name               = "health-communication-task-execution-role-tf"
  assume_role_policy = data.aws_iam_policy_document.ecstaskexecution-assume-role-policy-document.json
}

resource "aws_iam_role_policy_attachment" "health-communication_task-role-policy" {
  role       = aws_iam_role.health-communication-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

################################################################################
# data
################################################################################
data "aws_vpc" "vpc-data" {
  filter {
    name   = "tag:namealias"
    values = ["${var.vpc}"]
  }
}

data "aws_subnets" "private-subnets" {
  filter {
    name   = "tag:private"
    values = ["yes"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc-data.id]
  }
}

data "aws_subnet" "private-selected-subnets" {
  for_each = toset(data.aws_subnets.private-subnets.ids)
  id       = each.value
}

output "container_subnets_ids" {
  value = [for subnet in data.aws_subnet.private-selected-subnets : subnet.id]
}

resource "aws_security_group" "health-communication-sg" {
  name        = "health-communication-sg-tf"
  description = "Allow all outbound traffic to communicate with DB server"
  vpc_id      = data.aws_vpc.vpc-data.id
  egress = [
    {
      description      = "Allow all outbound traffic to communicate with DB server, SMTP Server"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]
  # ingress = [
  #   {
  #     description      = "Allow all inbound traffic for Crowdstrike"
  #     from_port        = 0
  #     to_port          = 0
  #     protocol         = "-1"
  #     cidr_blocks      = ["0.0.0.0/0"]
  #     ipv6_cidr_blocks = ["::/0"]
  #     prefix_list_ids  = null
  #     security_groups  = null
  #     self             = null
  #   }
  # ]
  tags = {
    Name = "health-communication-sg"
  }
}

################################################################################
# Service
################################################################################
resource "aws_ecs_service" "health-communication-service" {
  name            = "health-communication-service-tf"                             
  cluster         = "${aws_ecs_cluster.health-communication-cluster.id}"
  task_definition = "${aws_ecs_task_definition.health-communication-task.arn}"
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [for s in data.aws_subnet.private-selected-subnets : s.id]    
    security_groups = ["${aws_security_group.health-communication-sg.id}"]
  }
}