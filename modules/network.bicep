param name string
param location string
param virtualNetworkCidr string
param apimSubnetCidr string

resource apimVirtualNetwork 'Microsoft.Network/virtualNetworks@2020-05-01' = {
  name: '${name}-network'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        virtualNetworkCidr
      ]
    }
    subnets: [
      {
        name: '${name}-apim-subnet'
        properties: {
          addressPrefix: apimSubnetCidr
        }
      }
    ]
  }
  resource apimSubnet 'subnets' existing = {
    name: '${name}-apim-subnet'
  }

}

output apimSubnetId string = apimVirtualNetwork::apimSubnet.id
