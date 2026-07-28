targetScope = 'resourceGroup'

param location string
param env string
param tags object
param firewallNextHopIp string = '10.100.1.68'

// --- ROUTE TABLES ---

resource rtAgw 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-agw-${env}-ext-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: {
          addressPrefix: '10.144.16.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallNextHopIp
        }
      }
    ]
  }
}

resource rtSb 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-sb-${env}-ext-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: {
          addressPrefix: '10.144.17.0/28'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallNextHopIp
        }
      }
    ]
  }
}

resource rtApi 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-api-${env}-ext-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: {
          addressPrefix: '10.144.17.32/27'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallNextHopIp
        }
      }
    ]
  }
}

// --- NETWORK SECURITY GROUPS ---

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

resource nsgSb 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-sb-${env}-ext-ae-001'
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

resource nsgApi 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-api-${env}-ext-ae-001'
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

// Outputs for VNet binding
output rtAgwId string = rtAgw.id
output rtSbId string = rtSb.id
output rtApiId string = rtApi.id

output nsgAgwId string = nsgAgw.id
output nsgSbId string = nsgSb.id
output nsgApiId string = nsgApi.id
