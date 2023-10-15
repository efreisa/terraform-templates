variable "name" {
  type = string
}

variable "prefix" {
  type = string
  default = ""
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {
  }
}

variable "amount" {
  type = number
  default = 10
}

variable "contact_emails" {
  type = list(string)
}

variable "responsible" {
  type = string
}