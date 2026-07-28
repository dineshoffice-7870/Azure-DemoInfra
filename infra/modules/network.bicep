targetScope = 'resourceGroup'

param location string
param vnetName string
param addressPrefix string
param tags object
param subnets array

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
        
        // Map NSG if passed
        networkSecurityGroup: contains(subnet, 'nsgId') && !empty(subnet.nsgId) ? {
          id: subnet.nsgId
        } : null
        
        // Map Route Table if passed
        routeTable: contains(subnet, 'routeTableId') && !empty(subnet.routeTableId) ? {
          id: subnet.routeTableId
        } : null
      }
    }]
  }
}

output vnetId string = vnet.id
