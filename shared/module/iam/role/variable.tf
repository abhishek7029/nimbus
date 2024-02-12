variable "role_name" {}
variable "role_description" {}
variable "common_tags" {
  type = map(string)
}

variable "max_session_duration" {
  type    = number
  default = 3600
}
variable "assume_role" {}