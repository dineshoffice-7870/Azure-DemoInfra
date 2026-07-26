targetScope = 'resourceGroup'

param location string
param env string
param tags object
param firewallNextHopIp string = '10.100.1.68'
param agwSubnetPrefix string
param defaultSubnetPrefix string

// --- Route Tables ---
resource rtAgw 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-agw-${env}-ext-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: {
          addressPrefix: agwSubnetPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallNextHopIp
        }
      }
    ]
  }
}

resource rtDefaultInt 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-data-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: {
          addressPrefix: defaultSubnetPrefix
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallNextHopIp
        }
      }
    ]
  }
}

// --- Network Security Groups ---
resource nsgAgw 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-agw-${env}-ext-ae-001'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Inbound_Allow_HTTPS'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: 'Internet'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
    ]
  }
}

resource nsgApim 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-apim-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Inbound_Allow_HTTPS'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourceAddressPrefix: '10.144.16.0/20'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
    ]
  }
}

output rtAgwId string = rtAgw.id
output rtDefaultIntId string = rtDefaultInt.id
output nsgAgwId string = nsgAgw.id
output nsgApimId string = nsgApim.id
