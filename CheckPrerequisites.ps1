$CommandLocation = Split-Path $MyInvocation.MyCommand.Path -Parent;

## Include scripts
try
{
    . ("$($CommandLocation)\CheckFunctions.ps1");
}
catch
{
    Write-Output "Including scripts failed. Exception will be reraised";
    Throw;
}

## Checking session for package provider
InstallPackageProviderIfPossible -PackageProvider "Nuget";

## Checking session for modules
ImportModule -ModuleName "AzureRM";

