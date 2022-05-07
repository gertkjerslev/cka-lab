targetScope = 'subscription'

//Common
param rgName string
param location string

//Keyvault
param key_vault_name string
param objid string

//vNet
param VNetName string
param SubNetName string

//VM
param vmSize string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: {
    Project: 'CKA'
    Environment: 'Exam Prep'
  }
}

module keyvault 'modules/keyvault/keyvault.bicep' = {
  scope: rg
  name: 'keyvaultDeployment'
  params: {
    key_vault_name: key_vault_name
    location: location
    objid: objid
  }
}

module vNetwork 'modules/vNet/vNet.bicep' = {
  scope: rg
  name: 'vNetDeployment'
  params: {
    Location: location
    VNetName: VNetName
    SubNetName: SubNetName
  }
}

resource kv 'Microsoft.KeyVault/vaults@2021-11-01-preview' existing = {
  scope: rg
  name: key_vault_name
}

module server1 'modules/servers/servers.bicep' = {
  scope: rg
  name: 'controlplaneServerDeployment'
  params: {
    adminPassword: kv.getSecret('adminPassword')
    Location: location
    NICName: 'cp-nic'
    OSDiskName: 'cp-osdisk'
    PublicIPAddressName: 'cp-publicip'
    SubNetName: 'cka-Lab-Subnet'
    VMName: 'cp-vm'
    VNetId: vNetwork.outputs.VNetId
    vmSize: vmSize
  }
}

module server2 'modules/servers/servers.bicep' = {
  scope: rg
  name: 'workerNode1Deployment'
  params: {
    adminPassword: kv.getSecret('adminPassword')
    Location: location
    NICName: 'wn1-nic'
    OSDiskName: 'wn1-osdisk'
    PublicIPAddressName: 'wn1-publicip'
    SubNetName: 'cka-Lab-Subnet'
    VMName: 'wn1-vm'
    VNetId: vNetwork.outputs.VNetId
    vmSize: vmSize
  }
}

module server3 'modules/servers/servers.bicep' = {
  scope: rg
  name: 'workerNode2Deployment'
  params: {
    adminPassword: kv.getSecret('adminPassword')
    Location: location
    NICName: 'wn2-nic'
    OSDiskName: 'wn2-osdisk'
    PublicIPAddressName: 'wn2-publicip'
    SubNetName: 'cka-Lab-Subnet'
    VMName: 'wn2-vm'
    VNetId: vNetwork.outputs.VNetId
    vmSize: vmSize
  }
}
