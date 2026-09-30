// Reusable module: a network security group. Used by network/hub.bicep and network/spoke.bicep.
// Modules are building blocks for other templates, no configuration deploys this file directly.

param name string
param location string
@description('Rules on top of the Azure defaults, which already deny inbound traffic from the internet')
param securityRules array = []
param tags object = {}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    securityRules: securityRules
  }
}

output id string = networkSecurityGroup.id
output name string = networkSecurityGroup.name
