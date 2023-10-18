variable "name" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "location" {
  type = string
}
variable "sku" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "tenant_id" {
  type = string
}
variable "ip_deny" {
  type = list(string)
}
variable "search_index" {
  type = string
}