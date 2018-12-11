function InstallModuleIfPossible ([string] $ModuleName)
## Installs a module if requested and is missing
{
    try
    {
        Write-Output "Trying to install module $($ModuleName)...";
        if(Find-Module -Name $ModuleName)
        {
            Install-Module -Name $ModuleName
            Write-Output "Module $($ModuleName) successfully installed!";
        }
        else
        {
            throw [System.ArgumentException]::new("Module $($ModuleName) not found in gallery!");
        }
    }
    catch [System.ArgumentException]
    {
        Write-Output "The module $($ModuleName) cannot be found in the gallery! Exception will be reraised.";
        Throw;
    }
    catch 
    {
        Write-Output "Module $($ModuleName) cannot be installed. Reraising the exception.";
        Throw;
    }
}

function InstallPackageProviderIfPossible([string]$PackageProvider)
{
    [bool]$HasPackageProvider = IsModuleImported $PackageProvider;
    
    if(!($HasPackageProvider))
    {
        try
        {
            $ErrorActionPreference = 1; ## Stop if error occurs
            Write-Output "Trying to install package provider $($PackageProvider)...";
            Find-PackageProvider -Name $PackageProvider | Install-PackageProvider -Force; 
            Write-Output "Package provider $($PackageProvider) installed succesfully!";
        }
        catch
        {
            throw;
        }
    }
    else
    {
        Write-Output "Check passed: Package Manager $($PackageManager) is imported.";
    }
}

function IsModuleImported ([string] $ModuleName)
## Check if pre requisites are loaded
{
    if(Get-Module -Name $ModuleName)
    {
        Write-Output "Check passed: $($ModuleName) is imported.";
        return $true;
    }
    else
    {
        Write-Warning "Check failed: $($ModuleName) is not imported";
        return $false;
    }
}

function ImportModule ([string] $ModuleName)
{
    [bool]$IsImported = IsModuleImported $ModuleName;

    if(!($IsImported))
    {        
        if(Get-Module -Name $ModuleName -ListAvailable)
        {
            try 
            {
                Import-Module -Name $ModuleName;
                Write-Output "Module $($ModuleName) imported successfully!";
            }
            catch
            {
                Write-Output "Importing module $($ModuleName) failed...";
                Throw;
            }
        }
        else
        {
            InstallModuleIfPossible $ModuleName;
            ImportModule $ModuleName;
        }
    }
}