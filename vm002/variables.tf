variable "resource_group_name" {
  description = "Name of the resource group."
}

variable "location" {
  type = string
  description = "Location to create resources."
}
variable "prefix" {
  type        = string
  default     = "LBR-WIN-"
  description = "Prefix of the resource name"
}