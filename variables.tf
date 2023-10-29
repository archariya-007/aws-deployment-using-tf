variable "region" {
  default = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Enter the environment you're deploying to: "

  validation {
    condition = (
      var.environment == "dv" ||
      var.environment == "qa" ||
      var.environment == "uat" ||
      var.environment == "prod"
    )
    error_message = "Valid values are: dv, qa, uat, prod."
  }
}

variable "tf_state_lockedtbl" {
  default = "hulk-health-communication-tf-state"
}