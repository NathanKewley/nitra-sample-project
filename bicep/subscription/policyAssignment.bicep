targetScope = 'subscription'

param policyDisplayName string
param policyAssignmentName string
param policyDefinitionID string
param enforcementMode string

resource assignment 'Microsoft.Authorization/policyAssignments@2019-09-01' = {
    name: policyAssignmentName
    scope: subscription()
    properties: {
        displayName: policyDisplayName
        policyDefinitionId: policyDefinitionID
        enforcementMode: enforcementMode
    }
}

output assignmentId string = assignment.id
