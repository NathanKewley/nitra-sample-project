// One side of a virtual network peering. Each side is its own configuration in its own subscription,
// and the remote network can be in any subscription in the tenant

param peeringName string
@description('Name of the virtual network in this resource group')
param localNetworkName string
@description('Resource id of the virtual network to peer with')
param remoteNetworkId string
param allowVirtualNetworkAccess bool = true
param allowForwardedTraffic bool = false
param allowGatewayTransit bool = false
param useRemoteGateways bool = false

resource localNetwork 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: localNetworkName
}

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-11-01' = {
  parent: localNetwork
  name: peeringName
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteNetworkId
    }
  }
}
