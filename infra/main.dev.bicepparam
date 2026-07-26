using 'main.bicep'

param env = 'nonprod'
param location = 'australiaeast'

param externalRgName = 'rg-external-network-nonprod-001'
param internalRgName = 'rg-internal-network-prod-001'

param externalVnetCidr = '10.144.16.0/20'
param internalVnetCidr = '10.144.32.0/20'

param agwSubnetCidr = '10.144.16.0/24'
param msgqExtSubnetCidr = '10.144.17.0/28'
param apiExtSubnetCidr = '10.144.17.32/27'

param dataIntSubnetCidr = '10.144.32.0/28'
param apimIntSubnetCidr = '10.144.32.32/27'
param sbIntSubnetCidr = '10.144.32.64/27'
param apiIntSubnetCidr = '10.144.32.96/27'
param peIntSubnetCidr = '10.144.32.128/27'
param mgmtIntSubnetCidr = '10.144.32.192/28'

param mandatoryTagsExt = {
  Name: 'vnet-d365-nonprod-ext-ae-001'
  ApplicationID: 'D365'
  Owner: 'ICT'
  Cluster: 'No'
  Environment: 'Dev'
  ApplicationRole: 'D365 CRM External VNet'
  BusinessUnit: 'NESA'
  CostCentre: 'NESA-ICT'
  Deployment: 'ARM/Bicep'
}

param mandatoryTagsInt = {
  Name: 'vnet-d365-nonprod-int-ae-001'
  ApplicationID: 'D365'
  Owner: 'ICT'
  Cluster: 'No'
  Environment: 'Dev'
  ApplicationRole: 'D365 CRM Internal VNet'
  BusinessUnit: 'NESA'
  CostCentre: 'NESA-ICT'
  Deployment: 'ARM/Bicep'
}
