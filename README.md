# gd-child-nsg: Azure Network Security Group Terraform Module

This child module creates and manages an Azure Network Security Group (NSG) with typed and validated security rules adhering to defense-in-depth principles.

Part of the **Azure Parent–Child Infrastructure Architecture** under GitHub account `gauravdubey5`.

## Features

- Parameterized NSG creation with standardized tagging
- Typed security rules supporting single or multiple ports and CIDR blocks
- Strict validation of rule priorities (100–4096), directions (`Inbound`/`Outbound`), and access decisions (`Allow`/`Deny`)
- Compatible with Terraform `>= 1.5.0` and AzureRM provider `>= 3.75.0, < 5.0.0`

## Prerequisites

- Existing Resource Group (provisioned via `gd-child-rg`)
- Azure CLI or Service Principal authentication

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `name` | Name of the Network Security Group (1-80 chars) | `string` | n/a | yes |
| `resource_group_name` | Name of the parent Resource Group | `string` | n/a | yes |
| `location` | Azure Region for deployment | `string` | n/a | yes |
| `security_rules` | List of security rule definitions | `list(object)` | `[]` | no |
| `tags` | Map of tags applied to the NSG | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | The Resource ID of the Network Security Group |
| `name` | The Name of the Network Security Group |
| `resource_group_name` | The Resource Group name |
| `location` | The Region of the NSG |

## Example Usage

```hcl
module "nsg" {
  source = "git::https://github.com/gauravdubey5/gd-child-nsg.git?ref=v1.0.0"

  name                = "nsg-workload-dev-001"
  resource_group_name = module.rg.name
  location            = module.rg.location

  security_rules = [
    {
      name                       = "Allow-HTTPS-Inbound"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
      description                = "Allow HTTPS from within virtual network"
    }
  ]

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}
```

## Security Considerations

- **Zero-Trust Baseline**: Never allow open public access (`0.0.0.0/0` or `*`) on administrative ports (SSH 22, RDP 3389).
- **Subnet Association**: Associate this NSG with subnets using `gd-child-subnet` to enforce boundary packet filtering.

## Cost Considerations

- Network Security Groups and basic security rules incur **$0.00 / month** in Azure.

## Testing & Verification

```bash
terraform fmt -check
terraform init -backend=false
terraform validate
terraform test
```
