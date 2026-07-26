targetScope = 'subscription'

param location string = 'australiaeast'
param env string
param externalRgName string
param internalRgName string

param externalVnetCidr string
param internalVnetCidr string

param agwSubnetCidr string
param msgqExtSubnetCidr string
param apiExtSubnetCidr string

param dataIntSubnetCidr string
param apimIntSubnetCidr string
param sbIntSubnetCidr string
param apiIntSubnetCidr string
param peIntSubnetCidr string
param mgmtIntSubnetCidr string

param mandatoryTagsExt object
param mandatoryTagsInt object

// 1. Resource Group Modules
module rgExternal './modules/resource-group.bicep' = {
  name: 'rg-ext-deployment-${env}'
  params: {
    name: externalRgName
    location: location
    tags: mandatoryTagsExt
  }
}

module rgInternal './modules/resource-group.bicep' = {
  name: 'rg-int-deployment-${env}'
  params: {
    name: internalRgName
    location: location
    tags: mandatoryTagsInt
  }
}

// 2. Route Tables & NSGs Module
module nsgRtExt './modules/nsg-rt.bicep' = {
  name: 'nsg-rt-ext-${env}'
  scope: resourceGroup(externalRgName) // <--- FIX: Use parameter directly
  params: {
    location: location
    env: env
    tags: mandatoryTagsExt
    agwSubnetPrefix: agwSubnetCidr
    defaultSubnetPrefix: dataIntSubnetCidr
  }
  dependsOn: [
    rgExternal // Guarantees Bicep creates the RG first!
  ]
}

module nsgRtInt './modules/nsg-rt.bicep' = {
  name: 'nsg-rt-int-${env}'
  scope: resourceGroup(internalRgName) // <--- FIX: Use parameter directly
  params: {
    location: location
    env: env
    tags: mandatoryTagsInt
    agwSubnetPrefix: agwSubnetCidr
    defaultSubnetPrefix: dataIntSubnetCidr
  }
  dependsOn: [
    rgInternal
  ]
}

// 3. External (DMZ) VNet Module
module vnetExternal './modules/network.bicep' = {
  name: 'vnet-ext-${env}'
  scope: resourceGroup(externalRgName) // <--- FIX: Use parameter directly
  params: {
    location: location
    vnetName: 'vnet-d365-${env}-ext-ae-001'
    addressPrefix: externalVnetCidr
    tags: mandatoryTagsExt
    subnets: [
      {
        name: 'snet-agw-${env}-ext-ae-001'
        prefix: agwSubnetCidr
        nsgId: nsgRtExt.outputs.nsgAgwId
        routeTableId: nsgRtExt.outputs.rtAgwId
      }
      {
        name: 'snet-msgq-${env}-ext-ae-001'
        prefix: msgqExtSubnetCidr
      }
      {
        name: 'snet-api-${env}-ext-ae-001'
        prefix: apiExtSubnetCidr
      }
    ]
  }
  dependsOn: [
    rgExternal
  ]
}

// 4. Internal VNet Module
module vnetInternal './modules/network.bicep' = {
  name: 'vnet-int-${env}'
  scope: resourceGroup(internalRgName) // <--- FIX: Use parameter directly
  params: {
    location: location
    vnetName: 'vnet-d365-${env}-int-ae-001'
    addressPrefix: internalVnetCidr
    tags: mandatoryTagsInt
    subnets: [
      {
        name: 'snet-data-${env}-int-ae-001'
        prefix: dataIntSubnetCidr
        routeTableId: nsgRtInt.outputs.rtDefaultIntId
      }
      {
        name: 'snet-apim-${env}-int-ae-001'
        prefix: apimIntSubnetCidr
        nsgId: nsgRtInt.outputs.nsgApimId
      }
      {
        name: 'snet-sb-${env}-int-ae-001'
        prefix: sbIntSubnetCidr
      }
      {
        name: 'snet-api-${env}-int-ae-001'
        prefix: apiIntSubnetCidr
      }
      {
        name: 'snet-pe-${env}-int-ae-001'
        prefix: peIntSubnetCidr
      }
      {
        name: 'snet-mgmt-${env}-int-ae-001'
        prefix: mgmtIntSubnetCidr
      }
    ]
  }
  dependsOn: [
    rgInternal
  ]
}
