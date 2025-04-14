[CmdletBinding()]
param (

    [Parameter(Mandatory = $true)]
    [string]$TenantId,

    [Parameter(Mandatory = $true)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $false)]
    [string]$DeploymentRegion = "westeurope",

    [Parameter(Mandatory = $false)]
    [string]$ParameterFileName = "main.parameters.json"

)

# Set Az Context
Write-Verbose "Setting Azure Context to subscription: $subscriptionId in tenant: $tenantId"
Set-AzContext -Tenant $TenantId -Subscription $SubscriptionId -ErrorAction "Stop" | Out-Null
$TemplateFileName = "main.bicep"


# Deploying
Write-Verbose "Deploying CKA lab"
$splat = @{
    Name                  = "CKA-lab-$((Get-Date).Ticks)"
    Location              = $DeploymentRegion
    TemplateFile          = "$PSScriptRoot\$TemplateFileName"
    TemplateParameterFile = "$PSScriptRoot\$ParameterFileName"
    ErrorAction           = "stop"
}

New-AzDeployment @splat
