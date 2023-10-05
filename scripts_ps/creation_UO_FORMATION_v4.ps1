#==========================================================================
# Technique: Fichier CSV avec PowerShell
#
# Création de la structure des unités d'organisation (version 4)
#
# COMMENTAIRES: 
#   Le fichier csv contient
#   - le nom de la UO
#   - le DistinguishedName de son parent
#==========================================================================
Clear-Host

#-------------------------------------------------------------------------------
$OU = "OU=FORMATION,DC=formation,DC=local"

# Test si la OU existe
$resultat = [adsi]::Exists("LDAP://$OU")

if($resultat -eq "True")
{
  $message = "$OU existe, donc on l'efface."
  Write-Host $message -ForegroundColor Green

  Set-ADOrganizationalUnit -Identity $OU `
                           -ProtectedFromAccidentalDeletion $false

  Remove-ADOrganizationalUnit -Identity $OU `
                              -Recursive `
                              -Confirm:$false 
}
else
{
  $message = "$OU n'existe pas."
  Write-Host $message -ForegroundColor Yellow
}

#-------------------------------------------------------------------------------
# Cr�ation de la structure des UO en utilisant le fichier CSV
$FichierCSV = Import-Csv -Path "UO_FORMATION.csv" `
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

$message = "Cr�ation de $Compte unit�s d'organisation."
Write-Host $message
