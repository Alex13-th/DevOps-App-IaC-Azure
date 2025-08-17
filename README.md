# DevOps-App IaC (Azure)

This project is Terraform IaC for lifting **infrastructure workloads** to Azure:
- Creates a Resource Group, network (VNet/Subnet/NSG), Public IP, NIC, and VM.
- **Storage** (backend for Terraform and artifacts) is not created — it is connected as `data` from an existing account.

## What's inside
- `modules/network` — network resources
- `modules/compute` — virtual machine + Custom Script Extension
- `modules/storage` — only `data` (SA/container) and script URL formation

> Note: Terraform backend is stored in a separate Storage Account.

## Launch
For launch steps and detailed instructions, see **[INSTRUCTION.md](INSTRUCTION.md)**.