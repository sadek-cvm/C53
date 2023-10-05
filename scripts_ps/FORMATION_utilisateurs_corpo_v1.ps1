#==========================================================================
# Technique: Fichier CSV, cmdlet
#
# Cr�ation de plusieurs utilisateurs
# - supprime tous les utilisateurs dont le nom d�bute par EMP
# - cr�ation des utilisateurs
#
# AUTEUR: Richard Jean
# DATE  : 5 f�vrier 2023
#
# COMMENTAIRES: 
#	Le fichier CSV contient les informations pour cr�er les utilisateurs
#==========================================================================
Clear-Host

#----------------------------------------------------------------------------
# Supprime tous les utilisateurs de la OU FORMATION si le nom d�bute par EMP
#----------------------------------------------------------------------------
$chemin = "OU=FORMATION,DC=FORMATION,DC=LOCAL"
Get-ADUser -Filter 'SamAccountName -like "EMP*"' `
           -SearchBase $chemin | Remove-ADUser -Confirm:$false

#----------------------------------------------------------------------------
# Fichier CSV
#----------------------------------------------------------------------------
$NomFichier = "FORMATION_donnees.csv"
$FichierCSV = Import-Csv -Path $NomFichier `
                         -Delimiter ";"

# Initialisation des variable
$nomDNS = (Get-ADDomain).DnsRoot

$motDePasse = "AAAaaa111"
$mdp = ConvertTo-SecureString -AsPlainText $MotdePasse -Force

$Compte = 0

Foreach ($Ligne in $FichierCSV)
{
  $parent = $Ligne.Parent
  $prenom = $Ligne.Prenom
  $nom    = $Ligne.Nom
  $code   = $Ligne.Code
  $login  = $Ligne.Login
  
  New-ADUser -Name $login `
             -SamAccountName $login `
             -UserPrincipalName "$login@$nomDNS" `
             -Path $parent `
             -GivenName $prenom `
             -Surname $nom `
             -DisplayName "$prenom $nom - $code" `
             -AccountPassword $mdp `
             -PasswordNeverExpires $true `
             -Enabled $true

   Write-Host "$login" -ForegroundColor Yellow
   
   $Compte++
}

Write-Host "Cr�ation de $Compte utilisateurs." -ForegroundColor Cyan
