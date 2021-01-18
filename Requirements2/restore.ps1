# Martha Schiebel #000923205
Clear-Host
try {
    ##Create AD unit named Fiance
    New-ADOrganizationalUnit -Name fiance -ProtectedFromAccidentalDeletion $False

    ## Variable that imports from fiancepersonnel to the AD from the ForEach below
    $NewAD = Import-CSV $PSScriptRoot\financePersonnel.csv
    $Path = "OU=fiance,DC=ucertify,DC=com"

    foreach ($ADUser in $NewAD) {

        $First = $ADUser.First_Name
        $Last = $ADUser.Last_Name
        $Name = $First + " " + $Last
        $Postal = $ADUser.PostalCode
        $Office = $ADUser.OfficePhone
        $Mobile = $ADUser.MobilePhone

        ## Calls the variables set from above
        New-ADUser -Name $Name -GivenName $First -Surname $Last -DisplayName $Name -PostalCode $Postal `
            -OfficePhone $Office -MobilePhone $Mobile -Path $Path
    }

    Import-Module -Name sqlps -DisableNameChecking -Force

    ## Create Object for local SQL Connection
    $servername = ".\UCERTIFY3"
    $sever = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $servername
    $databasename = "ClientDB";
    $db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database -ArgumentList $servername, $databasename
    $db.create()

    Invoke-Sqlcmd -ServerInstance $servername -Database $databasename -InputFile $PSScriptRoot\Client_A_Contacts.sql

    $tb = 'dbo.Client_A_Contacts'
    $db = 'ClientDB'

    Import-CSV $PSScriptRoot\NewClientData.csv | ForEach-Object { Invoke-Sqlcmd `
            -Database $databasename -ServerInstance $servername -Query "insert into $tb (first_name,last_name,city,county,zip,officePhone,mobilePhone) VALUES `
('$($_.first_name)','$($_.last_name)','$($_.city)','$($_.county)','$($_.zip)','$($_.officePhone)','$($_.mobilePhone)')"

    }
}
# An exception handling using a try-catch for System.OutofMemoryException
catch [System.OutOfMemoryException] {
    Write-Host "A system out of memory exception has occured."
}
    