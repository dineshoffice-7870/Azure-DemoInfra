# 1. Ensure active Azure context
$context = Get-AzContext
if (-not $context) {
    Connect-AzAccount -TenantId "47848096-692a-4785-9fae-3fa902f1c5dc"
}

# 2. Set subscription context explicitly
Select-AzSubscription -SubscriptionId "deea32a9-3878-447f-b154-e1a277fd260e" -TenantId "47848096-692a-4785-9fae-3fa902f1c5dc"

# Define target Resource Groups
$resourceGroups = @(
    "rg-internal-network-nonprod-001",
    "rg-external-network-nonprod-001"
)

foreach ($rgName in $resourceGroups) {
    Write-Host "Processing Resource Group: $rgName..." -ForegroundColor Cyan

    # Get Resource Group
    $rg = Get-AzResourceGroup -Name $rgName -ErrorAction Stop
    $rgTags = $rg.Tags
    if (-not $rgTags) { $rgTags = @{} }
    $rgTags['Environment'] = 'nonprod'

    Set-AzResourceGroup -Name $rgName -Tag $rgTags | Out-Null
    Write-Host "  [+] Updated RG Tag: $rgName" -ForegroundColor Green

    # Get All Resources in the RG
    $resources = Get-AzResource -ResourceGroupName $rgName -ErrorAction Stop

    foreach ($resource in $resources) {
        $tags = $resource.Tags
        if (-not $tags) { $tags = @{} }
        $tags['Environment'] = 'nonprod'

        # Merge new tag onto resource
        Update-AzTag -ResourceId $resource.ResourceId -Tag $tags -Operation Merge | Out-Null
        Write-Host "  [+] Tag updated: $($resource.Name) ($($resource.ResourceType))" -ForegroundColor Green
    }
}

Write-Host "`nAll resources and RGs updated successfully to Environment=nonprod!" -ForegroundColor Yellow