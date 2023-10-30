variable "project-tags" {
  description = "Tags to set on all resources."
  type        = map(string)
  default     = {}
}

variable "environment" {
  type        = string
  description = "Enter the environment you're deploying to:  "

  validation {
    condition = (
      var.environment == "dv" ||
      var.environment == "qa" ||
      var.environment == "uat" ||
      var.environment == "prod"
    )
    error_message = "Valid values are: dev, qa, uat, prod"
  }
}

variable "region" {
  type        = string
  description = "Enter the region you're deploying to:  "

  validation {
    condition     = length(var.region) > 0
    error_message = "Valid values are not blank."
  }
}

variable "vpc" {
  description = "VPC name alias value."
  default     = "benefitexpress-wex-lnk"
  type        = string
}

variable "account_id" {
  description = "account id"
  default     = "123456789012"
  type        = string
}