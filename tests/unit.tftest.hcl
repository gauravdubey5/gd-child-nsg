# Unit test for gd-child-nsg

mock_provider "azurerm" {}

run "verify_nsg_plan" {
  command = plan

  variables {
    name                = "nsg-test-unit-001"
    resource_group_name = "rg-test-nsg"
    location            = "eastus2"
    security_rules = [
      {
        name                       = "Allow-HTTPS"
        priority                   = 200
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
        description                = "Allow HTTPS"
      }
    ]
    tags = {
      Environment = "test"
    }
  }

  assert {
    condition     = azurerm_network_security_group.nsg.name == "nsg-test-unit-001"
    error_message = "NSG name did not match expected value"
  }

  assert {
    condition     = length(azurerm_network_security_group.nsg.security_rule) == 1
    error_message = "NSG should contain exactly 1 security rule"
  }
}
