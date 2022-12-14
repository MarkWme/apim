@description('The name of the API Management service instance')
param name string = 'apiservice${uniqueString(resourceGroup().id)}'

@description('The email address of the owner of the service')
@minLength(1)
param publisherEmail string

@description('The name of the owner of the service')
@minLength(1)
param publisherName string

@description('The pricing tier of this API Management service')
@allowed([
  'Developer'
  'Standard'
  'Premium'
])
param sku string = 'Developer'

param virtualNetworkCidr string
param apimSubnetCidr string

@description('The instance size of this API Management service.')
@allowed([
  1
  2
])
param skuCount int = 1

@description('Location for all resources.')
param location string = resourceGroup().location

module apimNetwork 'modules/network.bicep' = {
  name: '${deployment().name}--apimNetwork'
  params: {
    name: name
    location: location
    virtualNetworkCidr: virtualNetworkCidr
    apimSubnetCidr: apimSubnetCidr
  }
}

module apimIdentity 'modules/managedIdentity.bicep' = {
  name: '${deployment().name}--apimIdentity'
  params: {
    name: name
    location: location
  }
}

module apim 'modules/apim.bicep' = {
  name: '${deployment().name}--apim'
  params: {
    name: name
    location: location
    sku: sku
    skuCount: skuCount
    apimManagedIdentity: apimIdentity.outputs.apimIdentityId
    publisherEmail: publisherEmail
    publisherName: publisherName
    apimSubnetId: apimNetwork.outputs.apimSubnetId
  }
}
