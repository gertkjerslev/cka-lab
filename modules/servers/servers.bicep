param VMName string
param VNetId string
param vmSize string
param Location string
param SubNetName string
param OSDiskName string
param NICName string
param PublicIPAddressName string
@secure()
param adminPassword string

resource VM_PublicIP 'Microsoft.Network/publicIPAddresses@2021-02-01' ={
  name:PublicIPAddressName
  location: Location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource NIC_VM 'Microsoft.Network/networkInterfaces@2020-08-01' = {
  name: NICName
  location: Location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          publicIPAddress: {
            id: VM_PublicIP.id
          }
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: '${VNetId}/subnets/${SubNetName}'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
  }
}

resource VirtualMachine 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: VMName
  location: Location
  properties:{
    hardwareProfile: {
      vmSize: vmSize
      }
      storageProfile: {
        osDisk: {
          name: OSDiskName
          createOption: 'FromImage'
          osType: 'Linux'
          managedDisk: {
            storageAccountType: 'StandardSSD_LRS'
          }
        }
        imageReference: {
          publisher: 'Canonical'
          offer: '0001-com-ubuntu-server-focal'
          sku: '20_04-lts-gen2'
          version: 'latest'
        }
      }
      osProfile: {
        computerName: VMName
        adminUsername: 'azureadmin'
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaces: [
          {
            id: NIC_VM.id
          }
        ]
      }
  }
}
