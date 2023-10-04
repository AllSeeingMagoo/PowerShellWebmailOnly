$Response = 'Y'
$User = $null
$UsersList = @()
$Mailbox = $null
$MailboxList = @()
$WriteOutList = $null

Do {
    $Mailbox = Read-Host 'Please type the email address of the shared inbox to give access to'
    $Response = Read-Host 'Would you like to add more shared inboxes? (Y/N)'
    $MailboxList += $Mailbox
} Until ($Response -eq 'N')

Do {
    $User = Read-Host 'Please type the email address of the user to be added'
    $Response = Read-Host 'Would you like to add more users? (Y/N)'
    $UsersList += $User
} Until ($Response -eq 'N')

# Connect to Exchange Online
Connect-ExchangeOnline

ForEach ($Mailbox in $MailboxList) {
    ForEach ($User in $UsersList) {
        Add-MailboxPermission -Identity $Mailbox -User $User -AccessRights FullAccess -AutoMapping $false -Verbose
        Add-RecipientPermission $Mailbox -AccessRights SendAs -Trustee $User -Confirm:$false
    }
}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false

Read-Host -Prompt "Press Enter to exit"