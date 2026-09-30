targetScope = 'subscription'

// Sends the subscription's Activity Log to a Log Analytics workspace, which can be in another subscription.
// Activity Log data is free to ingest into Log Analytics

param workspaceId string
param name string = 'activity-log-to-central-workspace'

var categories = [
  'Administrative'
  'Security'
  'ServiceHealth'
  'Alert'
  'Policy'
]

resource activityLog 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  properties: {
    workspaceId: workspaceId
    logs: [for category in categories: {
      category: category
      enabled: true
    }]
  }
}
