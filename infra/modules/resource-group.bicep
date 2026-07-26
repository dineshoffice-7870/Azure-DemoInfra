targetScope = 'subscription'

param name string
param location string
param tags object

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
  tags: tags
}

output name string = rg.name
output id string = rg.id
