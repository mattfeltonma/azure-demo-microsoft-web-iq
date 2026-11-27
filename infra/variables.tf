variable "region" {
  description = "The name of the Azure region to provision the resources to"
  type        = string
}

variable "tags" {
  description = "The tags to apply to the resources"
  type        = map(string)
}