targetScope = 'resourceGroup'

param location string
param vnetName string
param addressPrefix string
param subnets array
param tags object

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.prefix
        networkSecurityGroup: contains(subnet, 'nsgId') ? { id: subnet.nsgId } : null
        routeTable: contains(subnet, 'routeTableId') ? { id: subnet.routeTableId } : null
      }
    }]
  }
}

output vnetId string = vnet.id
