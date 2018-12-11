$DeployResourceGroup = ("$($PSScriptRoot)\DeployResourceGroup.ps1");





[string[]]$ResourcesToDeploy = @("DwhServer","Dwh");

foreach($Resource in $ResourcesToDeploy)
{
    $TemplateFilePath = ("$($PSScriptRoot)\Templates\$($Resource).json");
    $ParametersFilePath = ("$($PSScriptRoot)\Templates\$($Resource)Parameters.json");

    $TemplateFilePath;
    $ParametersFilePath;
}