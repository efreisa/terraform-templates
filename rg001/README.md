# Resource Group module

Create and manage a Resource Group.
Will set a budget défined in *amount* and warn *contact_emails* at 90% of consumption or if forecasted amount is over 100%.

# Paramaters

Following parameters are required or not.

| Parameter         | Required  | Description                                           |
|-------------------|-----------|-------------------------------------------------------|
| name              | yes       | Name of the resource group                            |
| prefix            | no        | Prefix before the name if required                    |
| location          | yes       | Location of the resource group                        |
| amount            | no        | Budget amount for that resource group (default is 10) |
| contact_emails    | yes       | List of email contacts to warn                        |
| tags              | no        | Tags to be applied to the resource group              |
