$tenantId = '<enter your tenant id here>'

$subscriptions = Get-AzSubscription -TenantId $tenantId

foreach ($subscription in $subscriptions) {
    $r = Get-AzSubscription -SubscriptionName $subscription.Name | Set-AzContext
    
    Get-AzActivityLogAlert | 
    Select-SvcHealthAlertRule
   
} #foreach