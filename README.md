# CKA-Lab

This repository contains the code for the CKA-Lab. It's purpose is to help candidates who are stuttering for the Certified Kubernetes Administrator (CKA) exam to get an lab environment up and running quickly.

This deployment sets up a CKA-Lab environment. The lab consists of 3 virtual machines (nodes): 1 control plane and 2 worker nodes. All servers are running Ubuntu 20.04 LTS witch is the version used for the CKA exam as of may 2022.

All servers are connected to the same vNet. The admin password for the VM's are stored in the deployed secrets.

## Using the lab

You will need to change the parameters in the `main.parameters.json` file to match your environment.
### Setup

To set up the lab, you need to run the following commands:

```PowerShell
.\deploy.ps1 -TenantId <YOUR-TANANTID> -subscriptionId <YOUR-SUBSCRIPTIONID>
```

Note: You will need to be logged in to Azure with the appropriate permissions.

### Connect to the servers

To connect to the lab, you can use SSH. The password for the user name 'azureadmin' are stored in the deployed secrets: 'adminPassword'.
