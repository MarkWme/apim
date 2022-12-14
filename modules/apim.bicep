param name string
param location string
param sku string
param skuCount int
param publisherEmail string
param publisherName string
param apimManagedIdentity string
param apimSubnetId string

resource apiManagementService 'Microsoft.ApiManagement/service@2021-08-01' = {
  name: name
  location: location
  tags: {
    deployedBy: 'bicep'
  }

  identity: {
    type: 'SystemAssigned, UserAssigned'
    userAssignedIdentities: {
      '${apimManagedIdentity}' : {}
    }
  
  }
  sku: {
    name: sku
    capacity: skuCount
  }

  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
    virtualNetworkType: 'External'
    virtualNetworkConfiguration: {
      subnetResourceId: apimSubnetId
    }
  }
}
