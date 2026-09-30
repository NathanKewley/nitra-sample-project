// Reusable module: a private endpoint that registers itself in a private DNS zone.
// The zone can be in another subscription, e.g. the hub. Used by workload/app.bicep.

param name string
param location string
param subnetId string
@description('Resource id of the service to connect to, e.g. a storage account')
param privateLinkServiceId string
@description('Sub-resource of the service, e.g. blob')
param groupId string
param privateDnsZoneId string
param tags object = {}

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: name
        properties: {
          privateLinkServiceId: privateLinkServiceId
          groupIds: [
            groupId
          ]
        }
      }
    ]
  }
}

resource privateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  parent: privateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: groupId
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}

output id string = privateEndpoint.id
