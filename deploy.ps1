param(
 [Parameter(Mandatory=$True)][string]$subscriptionId,
 [Parameter(Mandatory=$True)][string]$resourceGroupName,
 [string] $templateFilePath = "template.json",
 [string]$parametersFilePath = "parameters.json"
)

$ErrorActionPreference = "Stop";

# sign in and select subscription
Write-Output "Logging in to Azure..."
Login-AzureRmAccount -SubscriptionId $subscriptionId;

# load params for easy access
$params = ConvertFrom-Json -InputObject (Get-Content $parametersFilePath -Raw);

# Create the resource group unless it exists
$resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue;
if(!$resourceGroup)
{
  Write-Output "Creating resource group $($resourceGroupName) in location $($params.parameters.location.value)";
  New-AzureRMResourceGroup -Name $resourceGroupName `
    -Location $params.parameters.location.value `
    -Verbose;
}
else
{
  Write-Output "Using existing resource group $($resourceGroupName)";
}

# Executing test deployment
Write-Output "Testing deployment...";
$testResult = Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
  -TemplateFile $templateFilePath `
  -TemplateParameterFile $parametersFilePath -ErrorAction Stop;

if($testResult.Count -gt 0)
{
  Write-Output ($testResult | ConvertTo-Json -Depth 5 | Out-String);
  Write-Output "Errors in template. Deployment aborted";
  exit;
}

# Start Deploying
Write-Output "Starting deployment...";
New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
  -TemplateFile $templateFilePath `
  -TemplateParameterFile $parametersFilePath `
  -Verbose;
