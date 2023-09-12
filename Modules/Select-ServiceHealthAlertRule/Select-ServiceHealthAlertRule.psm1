function Select-SvcHealthAlertRule {
    <#
    .SYNOPSIS
    Selects Azure Service Health Alert Rules and the email receiviers
    associated with it.
    .DESCRIPTION
    Selects all Azure Activity Log alert rules in the pipeline and
    then filters out all alert rules except Service Health alert rules.
    It then gets each Action Group associated to the Service Health alert
    rule and each email receivier in the Action Group(s).
    .PARAMETER InputObject
    One or more Alert Rule objects collected by Get-AzActivityLogAlert.
    .EXAMPLE
    Get-AzActivityLogAlert | Select-SvcHealthAlertRule `
    | Select-Object -Property AlertRuleName, ActionGroupName, EmailReceivers
    .EXAMPLE
    Get-AzActivityLogAlert | Select-SvcHealthAlertRule -verbose
    Will run Select-SvcHealthAlertRule and output Write-Verbose information
    #>
        [CmdletBinding()]
        param (
            [Parameter(ValueFromPipeline=$true)]
            [object[]]$inputObject
        )
        
        BEGIN {}
    
        PROCESS {
            foreach ($alertRule in $inputObject) {            
                # Filter out non-Service Health activity log alert rules
                if ($alertRule.ConditionAllof.Field -eq 'category' -and $alertRule.ConditionAllof.Equal -eq 'ServiceHealth') {
                    Write-Verbose "Processing Service Health Alert Rule: $alertRuleName"
    
                    $flatAlertRules = $alertRule | ConvertFrom-Json
    
                    foreach ($flatAlertRule in $flatAlertRules) {
                        $alertRuleName = $flatAlertRule.Name
            
                        $actionGroupIds = $flatAlertRule.Properties.actions.actionGroups | Select-Object -ExpandProperty actiongroupId
            
                        $agResults = @()
                        $emlResults = @()
                        foreach ($actionGroupId in $actionGroupIds) {
                            $actionGroup = Get-AzResource -ResourceId $actionGroupId
            
                            $actionGroupName = $actionGroup.Name
                            $emailReceivers = ($actionGroup.Properties.emailReceivers).EmailAddress -join ','
    
                            $agResults += $actionGroupName
                            $emlResults += $emailReceivers
            
                        } #foreach
    
                        $agResultsString = $agResults -join ','
                        $emlResultsString = $emlResults -join ','
    
                        Write-Verbose "Outputting for Service Health Alert Rule: $alertRuleName"
                        $props = @{
                            'AlertRuleName' = $alertRuleName
                            'ActionGroupName' = $agResultsString
                            'EmailReceivers' = $emlResultsString
                        }
                        $obj = New-Object -TypeName PSObject -Property $props
                        Write-Output $obj
    
                    } #foreach
    
                } #if
    
            } #foreach
        
        } #PROCESS
    
        END {}
    
    } #function
