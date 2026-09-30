// Hub virtual network in the shared services subscription. Spokes peer to it, and the Azure Firewall
// lives here when deployFirewall is true

param name string
param location string
param addressPrefixes array
param firewallSubnetAddressPrefix string
param sharedSubnetName string
param sharedSubnetAddressPrefix string
param deployFirewall bool = false
param tags object = {}

module sharedSubnetNsg '../modules/networkSecurityGroup.bicep' = {
  name: 'nsg-${sharedSubnetName}'
  params: {
    name: 'nsg-${sharedSubnetName}'
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
        // Azure requires this exact name for the firewall subnet
        name: 'AzureFirewallSubnet'
        properties: {
          addressPrefix: firewallSubnetAddressPrefix
        }
      }
      {
        name: sharedSubnetName
        properties: {
          addressPrefix: sharedSubnetAddressPrefix
          networkSecurityGroup: {
            id: sharedSubnetNsg.outputs.id
          }
        }
      }
    ]
  }
}

module firewall '../modules/firewall.bicep' = if (deployFirewall) {
  name: 'firewall'
  params: {
    firewallName: 'hubFirewall'
    location: location
    firewallIPSKU: 'Standard'
    firewallSKUName: 'AZFW_VNet'
    firewallSKUTier: 'Standard'
    virtualNetwork: virtualNetwork.id
    firewallSubnetName: 'AzureFirewallSubnet'
  }
}

output virtualNetworkId string = virtualNetwork.id
output networkName string = virtualNetwork.name
