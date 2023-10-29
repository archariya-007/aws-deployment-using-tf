variable "project-tags" {
  description = "Tags to set on all resources."
  type        = map(string)
  default     = {}
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
    error_message = "Valid values are: dev, qa, uat, prod."
  }
}