#==========================================================================
# Technique: Fichier CSV avec PowerShell
#
# Création de la structure des unités d'organisation (version 5)
# 
# COMMENTAIRES: 
#   Le fichier csv contient
#   - le nom de la UO
#   - le DistinguishedName de son parent
#==========================================================================
Clear-Host

Function Create_OU {
  Param(
        [Parameter(Mandatory=$True)] [String]$message,
        [Parameter(Mandatory=$True)] [String]$couleur
       )
  
  Write-Host $message -ForegroundColor $couleur

  $NomFichier = "UO_FORMATION.csv"
  $FichierCSV = Import-Csv -Path $NomFichier `
                           -Delimiter ";"

  $Compte = 0

  Foreach ($Ligne in $FichierCSV)
  {
    $Nom    = $Ligne.Nom
    $Parent = $Ligne.Parent
    
    New-ADOrganizationalUnit -Name $Nom `
                             -Path $Parent `
                             -ProtectedFromAccidentalDeletion $false
    
    $Compte++
  }

  Write-Host "Création de $Compte unités d'organisation."
}

#-------------------------------------------------------------------------------
$OU = "OU=FORMATION,DC=formation,DC=local"

try
{
  Get-ADOrganizationalUnit -Identity $OU | Out-Null
  
  Set-ADOrganizationalUnit -Identity $OU `
                           -ProtectedFromAccidentalDeletion $false

  Remove-ADOrganizationalUnit -Identity $OU `
                              -Recursive `
                              -Confirm:$false

  $message = "$OU existe, donc on l'efface."
  $couleur = "Green"
  Create_OU $message $couleur
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
{
  $message = "$OU n'existe pas."
  $couleur = "Yellow"
  Create_OU $message $couleur
}
catch
{
  Write-Warning "ERREUR INATTENDUE !!!"
}
