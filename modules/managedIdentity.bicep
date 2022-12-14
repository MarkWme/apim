param name string
param location string

resource apimIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: name
  location: location
}

output apimIdentityId string = apimIdentity.id
