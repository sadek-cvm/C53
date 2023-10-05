#==========================================================================
# AUTEUR: Richard Jean 
# DATE  : 10 février 2023
#
# Tous les utilisateurs de la OU FORMATION
#
# Création de la structure des dossiers personnels 
#==========================================================================
Clear-Host

$NomOrdi = "SERVEUR1"

$NomPersoPartage  = "PERSO$"

$lettre = "X:"

#recherche tous les utilisateurs de la OU FORMATION si le nom débute par EMP
$chemin = "OU=FORMATION,DC=FORMATION,DC=LOCAL"
$noms = (Get-ADuser -SearchBase $chemin -Filter "Name -like 'EMP*'").Name

foreach ($nom in $noms)
{
  #---------------------------------------------------------
  #Création du dossier personnel pour l'utilisateur
  $cheminPerso = "\\$NomOrdi\$NomPersoPartage\$nom"
  
  New-Item -Path $cheminPerso `
           -ItemType directory 

  icacls.exe $cheminPerso /grant $nom":(OI)(CI)(M)" 

  #---------------------------------------------------------
  #Modification des propriétés de l'utilisateur
  Set-ADUser -Identity $nom `
             -HomeDrive $lettre `
             -HomeDirectory $cheminPerso
}
