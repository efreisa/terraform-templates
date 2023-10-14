variable "set_name" {
    type = string
}
variable "prefix" {
    type = string
    default = ""
}
variable "vm_list" {
    type = list(string)
}
variable "resource_group_name" {
    type = string
}
variable "location" {
    type = string
}
variable "tags" {
    type = map(string)
    default = {
    }
}
variable "vm_size" {
    type = string
}
variable "local_admin_username" {
    type = string
}
variable "local_admin_password" {
    type = string
}
variable "shutdown_time" {
    type = string
    default = "1800"
}
variable "hub_name" {
    type = string
}
variable "hub_rg_name" {
    type = string
}
variable "address_space" {
    type = list(string)
}
variable "address_prefixes" {
    type = list(string)
}