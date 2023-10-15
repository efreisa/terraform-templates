# VM module

This module manage creation for one or more VMs on Azure.
That VMs are isolated in a vnet and can't be accessed from internet.

# Parameters

Following parameters are required or not.

| Parameter | Required | Description |
|-----------|----------|-------------|
| set_name  | yes      | Name of the VMs' set created |
| vm_list   | yes      | List of the VMs to create |
| vm_size   | yes      | sku used to create VMs |
| shutdown_time | no   | Time at which the VMs will be shutdowned everydays (defautl 18:00) |
| prefix    | no       | A string added to the beginning of VMs name |
| resource_group_name | yes | Name of the resource group where to create VMs |
| location  | yes      | Location used for all resources |
| tags      | no       | Tags to be applied to resources |
| local_admin_username | yes | Username that'll be used to create VMs local admin account |
| local_admin_password | yes | Password to be used for local admin user |
| hub_name  | yes      | Vnet used as network hub to connect the VMs created vnet |
| hub_rg_name | yes    | Name of the network hub resource group |
| address_space | yes  | Vnet address space. Format like ["192.168.157.0/26"] |
| address_prefixes | yes | Snet address space. Format like ["192.168.157.0/27"] |