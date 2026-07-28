targetScope = 'resourceGroup'

param location string
param env string
param tags object
param firewallNextHopIp string = '10.100.1.68'

// --- ROUTE TABLES ---

resource rtData 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-data-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: { addressPrefix: '10.144.32.0/28', nextHopType: 'VirtualAppliance', nextHopIpAddress: firewallNextHopIp }
      }
    ]
  }
}

resource rtApim 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-apim-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: { addressPrefix: '10.144.32.32/27', nextHopType: 'VirtualAppliance', nextHopIpAddress: firewallNextHopIp }
      }
    ]
  }
}

resource rtSb 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-sb-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: { addressPrefix: '10.144.32.64/27', nextHopType: 'VirtualAppliance', nextHopIpAddress: firewallNextHopIp }
      }
    ]
  }
}

resource rtApi 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-api-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: { addressPrefix: '10.144.32.96/27', nextHopType: 'VirtualAppliance', nextHopIpAddress: firewallNextHopIp }
      }
    ]
  }
}

resource rtPe 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-pe-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: { addressPrefix: '10.144.32.128/27', nextHopType: 'VirtualAppliance', nextHopIpAddress: firewallNextHopIp }
      }
    ]
  }
}

resource rtMgmt 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-mgmt-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    routes: [
      {
        name: 'Outbound_to_AZFirewall'
        properties: { addressPrefix: '10.144.32.192/28', nextHopType: 'VirtualAppliance', nextHopIpAddress: firewallNextHopIp }
      }
    ]
  }
}

// --- NETWORK SECURITY GROUPS ---

resource nsgData 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-data-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    securityRules: [
      { name: 'Inbound_Allow_HTTPS', properties: { priority: 100, direction: 'Inbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: '10.144.16.0/20', sourcePortRange: '*', destinationAddressPrefix: '*', destinationPortRange: '443' } }
    ]
  }
}

resource nsgApim 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-apim-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    securityRules: [
      { name: 'Inbound_Allow_HTTPS', properties: { priority: 100, direction: 'Inbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: '10.144.16.0/20', sourcePortRange: '*', destinationAddressPrefix: '*', destinationPortRange: '443' } }
    ]
  }
}

resource nsgSb 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-sb-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    securityRules: [
      { name: 'Inbound_Allow_HTTPS', properties: { priority: 100, direction: 'Inbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: '10.144.16.0/20', sourcePortRange: '*', destinationAddressPrefix: '*', destinationPortRange: '443' } }
    ]
  }
}

resource nsgApi 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-api-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    securityRules: [
      { name: 'Inbound_Allow_HTTPS', properties: { priority: 100, direction: 'Inbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: '10.144.16.0/20', sourcePortRange: '*', destinationAddressPrefix: '*', destinationPortRange: '443' } }
    ]
  }
}

resource nsgPe 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-pe-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    securityRules: [
      { name: 'Inbound_Allow_HTTPS', properties: { priority: 100, direction: 'Inbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: '10.144.16.0/20', sourcePortRange: '*', destinationAddressPrefix: '*', destinationPortRange: '443' } }
    ]
  }
}

resource nsgMgmt 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-mgmt-${env}-int-ae-001'
  location: location
  tags: tags
  properties: {
    securityRules: [
      { name: 'Inbound_Allow_HTTPS', properties: { priority: 100, direction: 'Inbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: '10.144.16.0/20', sourcePortRange: '*', destinationAddressPrefix: '*', destinationPortRange: '443' } }
      { name: 'Inbound_Allow_GatewayManager', properties: { priority: 101, direction: 'Inbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: 'GatewayManager', sourcePortRange: '*', destinationAddressPrefix: '*', destinationPortRange: '443' } }
      { name: 'Inbound_Allow_LoadBalancer', properties: { priority: 102, direction: 'Inbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: 'AzureLoadBalancer', sourcePortRange: '*', destinationAddressPrefix: '*', destinationPortRange: '443' } }
      { name: 'Inbound_Allow_AzureBastionHost', properties: { priority: 103, direction: 'Inbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: 'VirtualNetwork', sourcePortRange: '*', destinationAddressPrefix: 'VirtualNetwork', destinationPortRanges: [ '8080', '5701' ] } }
      { name: 'Inbound_Allow_AC3_Management', properties: { priority: 250, direction: 'Inbound', access: 'Allow', protocol: '*', sourceAddressPrefixes: [ '202.129.128.0/21', '10.156.0.6/32' ], sourcePortRange: '*', destinationAddressPrefix: '*', destinationPortRange: '*' } }
      { name: 'Inbound_Allow_AC3_BigFix', properties: { priority: 251, direction: 'Inbound', access: 'Allow', protocol: 'Udp', sourceAddressPrefix: '202.129.128.0/21', sourcePortRange: '52311', destinationAddressPrefix: '*', destinationPortRange: '*' } }
      
      // Outbound Rules
      { name: 'Outbound_Allow_SSHRDP', properties: { priority: 100, direction: 'Outbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: '*', sourcePortRange: '*', destinationAddressPrefix: 'VirtualNetwork', destinationPortRanges: [ '22', '3389' ] } }
      { name: 'Outbound_Allow_AzureCloud', properties: { priority: 101, direction: 'Outbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: '*', sourcePortRange: '*', destinationAddressPrefix: 'AzureCloud', destinationPortRange: '443' } }
      { name: 'Outbound_Allow_AzureBastionHost', properties: { priority: 102, direction: 'Outbound', access: 'Allow', protocol: 'Tcp', sourceAddressPrefix: 'VirtualNetwork', sourcePortRange: '*', destinationAddressPrefix: 'VirtualNetwork', destinationPortRanges: [ '8080', '5701' ] } }
      { name: 'Outbound_Allow_Internet', properties: { priority: 106, direction: 'Outbound', access: 'Allow', protocol: '*', sourceAddressPrefix: '*', sourcePortRange: '*', destinationAddressPrefix: 'Internet', destinationPortRanges: [ '443', '53' ] } }
      { name: 'Outbound_Block_Internet', properties: { priority: 4096, direction: 'Outbound', access: 'Deny', protocol: '*', sourceAddressPrefix: '*', sourcePortRange: '*', destinationAddressPrefix: 'Internet', destinationPortRange: '*' } }
    ]
  }
}

output rtDataId string = rtData.id
output rtApimId string = rtApim.id
output rtSbId string = rtSb.id
output rtApiId string = rtApi.id
output rtPeId string = rtPe.id
output rtMgmtId string = rtMgmt.id

output nsgDataId string = nsgData.id
output nsgApimId string = nsgApim.id
output nsgSbId string = nsgSb.id
output nsgApiId string = nsgApi.id
output nsgPeId string = nsgPe.id
output nsgMgmtId string = nsgMgmt.id
