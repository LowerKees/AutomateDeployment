# include the scripts
."$($PSScriptRoot)/deploy_datalake.ps1";

# sign in and select subscription
Write-Output "Logging in to Azure..."
Login-AzureRmAccount;

# get subscription and start deploying!
$Subscription = Get-AzureRmSubscription -SubscriptionName "Visual Studio Professional";

# start deploying
Deploy-Datalake -subscriptionId $Subscription.SubscriptionId;