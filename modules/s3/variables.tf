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

variable "bucket_name" {}