// Reusable module: Azure Firewall with a default route. Used by network/hub.bicep when deployFirewall is true.
// This costs about $1.25 an hour, so it is off in the sample configuration.

param firewallName string
param location string
param firewallIPSKU string
param firewallSKUName string
param firewallSKUTier string
param virtualNetwork string
param firewallSubnetName string

resource firewallPublicIP 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: '${firewallName}-ip'
  location: location
  sku: {
    name: firewallIPSKU
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource firewall 'Microsoft.Network/azureFirewalls@2020-05-01' = {
  name: firewallName
  location: location
  properties: {
    sku: {
      name: firewallSKUName
      tier: firewallSKUTier
    }
    threatIntelMode: 'Alert'
    ipConfigurations: [
      {
        name: firewallName
        properties: {
          publicIPAddress: {
            id: firewallPublicIP.id
          }
          subnet: {
            id: '${virtualNetwork}/subnets/${firewallSubnetName}'
          }
        }
      }
    ]
  }
}

resource firewallRoutes 'Microsoft.Network/routeTables@2020-05-01' = {
  name: '${firewallName}-routes'
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: '${firewallName}-route-internet'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewall.properties.ipConfigurations[0].properties.privateIPAddress
        }
      }
    ]
  }
}
