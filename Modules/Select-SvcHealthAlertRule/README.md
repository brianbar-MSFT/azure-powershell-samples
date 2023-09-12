# Select-SvcHealthAlertRule

## Synopsis
Selects Azure Service Health Alert Rules and the email receivers
associated with it.

## Description
Selects all Azure Activity Log alert rules in the pipeline and
then filters out all alert rules except Service Health alert rules.
It then gets each Action Group associated to the Service Health alert
rule and each email receiver in the Action Group(s).

## Parameter: InputObject
One or more Alert Rule objects collected by Get-AzActivityLogAlert.

## Example:
Get-AzActivityLogAlert | Select-SvcHealthAlertRule
| Select-Object -Property AlertRuleName, ActionGroupName, EmailReceivers

## Example:
Get-AzActivityLogAlert | Select-SvcHealthAlertRule -verbose
Will run Select-SvcHealthAlertRule and output Write-Verbose information
