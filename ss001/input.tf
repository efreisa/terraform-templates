variable "amount" {
  type = number
}

variable "contact_emails" {
  type = list(string)
}

variable "prefix" {
    type = string
    default = ""
}