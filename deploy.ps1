[CmdletBinding()]
param (

    [Parameter(Mandatory = $true)]
    [string]$TenantId,

    [Parameter(Mandatory = $true)]
    [string]$subscriptionId,

    [Parameter(Mandatory = $false)]
    [string]$DeploymentRegion = "westeurope"
)

# Set Az Context
Write-Verbose "Setting Azure Context to subscription: $subscriptionId in tenant: $tenantId"
Set-AzContext -Tenant $TenantId -Subscription $SubscriptionId -ErrorAction "Stop" | Out-Null
$TemplateFileName = "main.bicep"
$ParameterFileName = "main.parameters.json"

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
