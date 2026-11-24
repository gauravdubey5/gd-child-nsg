variable "network_security_group" {
  description = "A mapping of Network Security Group names to their properties."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}
