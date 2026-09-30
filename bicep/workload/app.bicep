// A workload in a spoke subscription that uses shared services from the hub subscription:
// its blob logs go to the central workspace and its private endpoint registers in the hub's private DNS zone

param location string
param appName string
@description('Lowercase letters and numbers, max 11 characters, for the storage account name')
param storageNamePrefix string
@description('Subnet in the spoke virtual network for the private endpoint')
param workloadSubnetId string
@description('privatelink.blob private DNS zone in the hub subscription')
param blobPrivateDnsZoneId string
@description('Central Log Analytics workspace in the hub subscription')
param workspaceId string
param tags object = {}

// A module from the public Bicep registry (Azure Verified Modules), pinned to a version
module identity 'br/public:avm/res/managed-identity/user-assigned-identity:0.6.0' = {
  name: '${appName}-identity'
  params: {
    name: 'id-${appName}'
    location: location
    tags: tags
    enableTelemetry: false
  }
}

// Local modules from bicep/modules
module storage '../modules/storageAccount.bicep' = {
  name: '${appName}-storage'
  params: {
    namePrefix: storageNamePrefix
    location: location
    tags: tags
    workspaceId: workspaceId
    readerPrincipalId: identity.outputs.principalId
  }
}

module blobPrivateEndpoint '../modules/privateEndpoint.bicep' = {
  name: '${appName}-blob-private-endpoint'
  params: {
    name: 'pe-${appName}-blob'
    location: location
    tags: tags
    subnetId: workloadSubnetId
    privateLinkServiceId: storage.outputs.id
    groupId: 'blob'
    privateDnsZoneId: blobPrivateDnsZoneId
  }
}

output identityPrincipalId string = identity.outputs.principalId
output identityResourceId string = identity.outputs.resourceId
output storageAccountName string = storage.outputs.name
