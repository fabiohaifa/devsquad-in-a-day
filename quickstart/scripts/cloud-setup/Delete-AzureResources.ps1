param (
    # Azure DevOps organization where you want to create this HOL resources
    [parameter(mandatory=$true)]
    [string]$projectName = '<projectName>',
    
    # Simple alias for the project (less than 8 characters)
    [parameter(mandatory=$true)]
    [string]$projectAlias = '<projectAlias>',
)

$filter = ("rg-" + $projectAlias + "-")

$myServicePrincipals = Get-AzADServicePrincipal -DisplayName ("SP-"+$projectName+"-DevTest") | Select-Object DisplayName
Write-Host "`nService Principal`n-----------------"
$myServicePrincipals | ForEach-Object  {
    Write-Host $_.DisplayName
}

$myResourceGroups = Get-AzResourceGroup | ? ResourceGroupName -match $filter | Select-Object ResourceGroupName
Write-Host "`nResource Group`n-----------------"
$myResourceGroups | ForEach-Object  {
    Write-Host $_.ResourceGroupName
}

$answer = read-host -prompt "`nPress 'y' to delete all the resources listed above."
$yesList = 'yes','y'

if ($yesList -contains $answer.ToLower()) {
    Get-AzResourceGroup | ? ResourceGroupName -match $filter | Remove-AzResourceGroup -AsJob -Force
    Get-AzADServicePrincipal -DisplayName ("SP-"+$projectName+"-DevTest") | Remove-AzADServicePrincipal -Force
} else {
    Write-Host "[Command Skipped] Your resources were not deleted."
}

