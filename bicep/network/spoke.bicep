// Spoke virtual network. One template, used by the configuration of each spoke subscription

param name string
param location string
param addressPrefixes array
param workloadSubnetName string
param workloadSubnetAddressPrefix string
param tags object = {}

module workloadSubnetNsg '../modules/networkSecurityGroup.bicep' = {
  name: 'nsg-${workloadSubnetName}'
  params: {
    name: 'nsg-${workloadSubnetName}'
    location: location
    tags: tags
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    subnets: [
      {
        name: workloadSubnetName
        properties: {
          addressPrefix: workloadSubnetAddressPrefix
          networkSecurityGroup: {
            id: workloadSubnetNsg.outputs.id
          }
        }
      }
    ]
  }
}

output virtualNetworkId string = virtualNetwork.id
output networkName string = virtualNetwork.name
output workloadSubnetId string = virtualNetwork.properties.subnets[0].id
