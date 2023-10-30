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


variable "region" {
  type        = string
  description = "Enter the region you're deploying to: "

  validation {
    condition     = length(var.region) > 0
    error_message = "Valid values are not blank."
  }
}

variable "bucket_name" {}