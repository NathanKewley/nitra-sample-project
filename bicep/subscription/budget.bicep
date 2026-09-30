targetScope = 'subscription'

// Monthly cost budget for the subscription, alerting an action group that can be in another subscription

param name string
@description('Monthly amount in the billing currency')
param amount int
param thresholdPercent int = 80
param actionGroupId string
param contactEmails array = []
@description('First day of the month the budget starts from, defaults to the current month')
param startDate string = utcNow('yyyy-MM-01')

resource budget 'Microsoft.Consumption/budgets@2023-11-01' = {
  name: name
  properties: {
    category: 'Cost'
    amount: amount
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: startDate
    }
    notifications: {
      actualOverThreshold: {
        enabled: true
        operator: 'GreaterThan'
        threshold: thresholdPercent
        thresholdType: 'Actual'
        contactEmails: contactEmails
        contactGroups: [
          actionGroupId
        ]
      }
    }
  }
}
