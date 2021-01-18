Import-Module -Name sqlps -DisableNameChecking -Force

Get-ADUser -Filter * -SearchBase "OU=fiance,DC=ucertify,DC=com" `
-Properties DisplayName,PostalCode,MobilePhone,OfficePhone > $PSScriptRoot\AdResults.txt
Invoke-Sqlcmd -DataBase ClientDB -ServerInstance .\ucertify3 -Query 'SELECT * FROM dbo.Client_A_Contacts' `
> $PSScriptRoot\SQLResults.txt