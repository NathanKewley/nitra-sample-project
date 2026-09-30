// Central Log Analytics workspace. Every subscription sends its Activity Log here, and workloads
// send their resource logs here

param name string
param location string
param retentionInDays int = 30
param tags object = {}

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: retentionInDays
    workspaceCapping: {
      // Caps ingestion at 0.1 GB a day to keep the sample cheap. Bicep has no decimal type, hence json()
      dailyQuotaGb: json('0.1')
    }
  }
}

output workspaceId string = workspace.id
output workspaceName string = workspace.name
