param location string
param key_vault_name string
param objid string

resource key_vault 'Microsoft.KeyVault/vaults@2024-12-01-preview' = {
  name: key_vault_name
  location: location
  tags: {
    CostCenter: ''
  }
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenant().tenantId
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    accessPolicies: [
      {
        objectId: objid
        permissions: {
          secrets: [
            'set'
            'get'
            'list'
            'delete'
          ]
          keys:[
            'create'
            'get'
            'decrypt'
            'encrypt'
            'sign'
            'unwrapKey'
            'verify'
            'wrapKey'
          ]
        
        }
        tenantId: tenant().tenantId
      }
    ]
  }
}


resource sqlpw 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  name: 'adminPassword'
  parent: key_vault
  properties: {
    value: 'F"%t-${uniqueString(resourceGroup().id, key_vault.name)}'
  }
}

output keyvault_name string = key_vault.name
