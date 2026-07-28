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


// 2. Route Tables & NSGs Modules
module nsgRtExt './modules/nsg-rt-ext.bicep' = {
  name: 'nsg-rt-ext-${env}'
  scope: resourceGroup(externalRgName)
  params: {
    location: location
    env: env
    tags: mandatoryTagsExt
  }
  dependsOn: [ rgExternal ]
}

module nsgRtInt './modules/nsg-rt-int.bicep' = {
  name: 'nsg-rt-int-${env}'
  scope: resourceGroup(internalRgName)
  params: {
    location: location
    env: env
    tags: mandatoryTagsInt
  }
  dependsOn: [ rgInternal ]
}

// 3. External VNet Module
module vnetExternal './modules/network.bicep' = {
  name: 'vnet-ext-${env}'
  scope: resourceGroup(externalRgName)
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
        nsgId: nsgRtExt.outputs.nsgSbId
        routeTableId: nsgRtExt.outputs.rtSbId
      }
      {
        name: 'snet-api-${env}-ext-ae-001'
        prefix: apiExtSubnetCidr
        nsgId: nsgRtExt.outputs.nsgApiId
        routeTableId: nsgRtExt.outputs.rtApiId
      }
    ]
  }
  dependsOn: [ rgExternal, nsgRtExt ] // <--- Ensures NSGs & RTs exist first
}

// 4. Internal VNet Module
module vnetInternal './modules/network.bicep' = {
  name: 'vnet-int-${env}'
  scope: resourceGroup(internalRgName)
  params: {
    location: location
    vnetName: 'vnet-d365-${env}-int-ae-001'
    addressPrefix: internalVnetCidr
    tags: mandatoryTagsInt
    subnets: [
      {
        name: 'snet-data-${env}-int-ae-001'
        prefix: dataIntSubnetCidr
        nsgId: nsgRtInt.outputs.nsgDataId
        routeTableId: nsgRtInt.outputs.rtDataId
      }
      {
        name: 'snet-apim-${env}-int-ae-001'
        prefix: apimIntSubnetCidr
        nsgId: nsgRtInt.outputs.nsgApimId
        routeTableId: nsgRtInt.outputs.rtApimId
      }
      {
        name: 'snet-sb-${env}-int-ae-001'
        prefix: sbIntSubnetCidr
        nsgId: nsgRtInt.outputs.nsgSbId
        routeTableId: nsgRtInt.outputs.rtSbId
      }
      {
        name: 'snet-api-${env}-int-ae-001'
        prefix: apiIntSubnetCidr
        nsgId: nsgRtInt.outputs.nsgApiId
        routeTableId: nsgRtInt.outputs.rtApiId
      }
      {
        name: 'snet-pe-${env}-int-ae-001'
        prefix: peIntSubnetCidr
        nsgId: nsgRtInt.outputs.nsgPeId
        routeTableId: nsgRtInt.outputs.rtPeId
      }
      {
        name: 'snet-mgmt-${env}-int-ae-001'
        prefix: mgmtIntSubnetCidr
        nsgId: nsgRtInt.outputs.nsgMgmtId
        routeTableId: nsgRtInt.outputs.rtMgmtId
      }
    ]
  }
  dependsOn: [ rgInternal, nsgRtInt ] // <--- Ensures NSGs & RTs exist first
}
