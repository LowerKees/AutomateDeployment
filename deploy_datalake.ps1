Function Deploy-Datalake {
    param(
        [Parameter(Mandatory=$true, Position=0)][string]$subscriptionId,
        [string]$resourceGroupName = "rgdevdatalake",
        [string]$templateFilePath = "$($PSScriptRoot)/datalake/template.json",
        [string]$parametersFilePath = "$($PSScriptRoot)/datalake/parameters.json"
    )

    $ErrorActionPreference = "Stop";

    # load params for easy access
    $params = ConvertFrom-Json -InputObject (Get-Content $parametersFilePath -Raw);

    # Create the resource group unless it exists
    $resourceGroup = Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorAction SilentlyContinue;
    if (!$resourceGroup) {
        Write-Output "Creating resource group $($resourceGroupName) in location $($params.parameters.location.value)";
        New-AzureRMResourceGroup -Name $resourceGroupName `
            -Location $params.parameters.location.value `
            -Verbose;
    }
    else {
        Write-Output "Using existing resource group $($resourceGroupName)";
    }

    # Executing test deployment
    Write-Output "Testing deployment...";
    $testResult = Test-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroupName `
        -TemplateFile $templateFilePath `
        -TemplateParameterFile $parametersFilePath -ErrorAction Stop;

    if ($testResult.Count -gt 0) {
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
}