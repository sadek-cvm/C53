#==========================================================================
# Technique: Fichier CSV, cmdlet
#
# Création de plusieurs utilisateurs
# - si l'utilisateur existe alors ne rien faire
# - si l'utilisateur n'existe pas alors il sera créé
#
# AUTEUR: Richard Jean
# DATE  : 5 février 2023
#
# COMMENTAIRES: 
#	Le fichier CSV contient les informations pour créer les utilisateurs
#==========================================================================
Clear-Host

# Fichier CSV
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
 
  $resultat = $(try {Get-ADUser -Identity $login} catch {$null})

  if ($resultat -ne $null)
  {
    $message = "$login existe."
    Write-Host $message  -ForegroundColor Green  
  }
  else
  {
    $message = "$login n'existe pas."
    Write-Host $message -ForegroundColor Yellow    

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
    
     Write-Host "$login existe" -ForegroundColor Green
     
	 $Compte++
  }
}

Write-Host "Création de $Compte utilisateurs." -ForegroundColor Cyan
