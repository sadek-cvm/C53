#==========================================================================
# Création de plusieurs groupes
# Joindre des utilisateurs qui existent à des groupes 
#==========================================================================
Clear-Host

#---------------------------------------------
# Initialisation des variables pour le domaine
#---------------------------------------------
$nomDom = (Get-ADDomain).DistinguishedName
$chemin = "OU=GROUPES,OU=FORMATION,$nomDom"

#-----------------------------------------------------------------------------
# Supprime tous les groupes dans l'unité d'organisation GROUPES sous FORMATION
#-----------------------------------------------------------------------------
Get-ADGroup -Filter * `
            -SearchBase $chemin | Remove-ADGroup -Confirm:$false

#-----------------------------------------------------------
# Importation du contenu des fichiers CSV dans des variables
#-----------------------------------------------------------
$FGroupe = "C53 L07D ListeGroupes.csv"
$ListeGroupe = Import-Csv -Path $FGroupe `
                          -Delimiter ":"

$FUtilisateur = "C53 L07D ListeMembres.csv"
$ListeUtilisateur = Import-Csv -Path $FUtilisateur `
                               -Delimiter ";"

#-----------------------------------------------------------------------------------
# La création des groupes se fait dans l'unité d'organisation GROUPES sous FORMATION
#-----------------------------------------------------------------------------------
Foreach ($Ligne in $ListeGroupe)
{  
  $nom     = $Ligne.Nom
  $type    = $Ligne.Type
  $etendue = $Ligne.Etendue
   
  New-ADGroup -Name $nom `
              -GroupCategory $type `
              -GroupScope $etendue `
              -Path $chemin
}

Write-Host "Création des groupes dans $chemin" -ForegroundColor Yellow

#----------------------------------------------
# Ajout des utilisateurs aux groupes appropriés
#----------------------------------------------
Foreach ($Ligne in $ListeUtilisateur)
{
  $login = $Ligne.Login
  $groupes = ($Ligne.groupe) -split(",")

  Foreach ($groupe in $groupes)
  {
    # La commande ajoute un groupe à un utilisateur
	Add-ADGroupMember -Identity $groupe  `
	                  -Members $login 
  }
}

#--------------------------------------------------------
# Affiche les membres de chaque groupe de la OU "GROUPES"
#--------------------------------------------------------
$groupes = (Get-ADGroup -Filter * -SearchBase $chemin).Name

Foreach ($groupe in $groupes)
{
 Write-Host $("-" * 80) -ForegroundColor Yellow
 Write-Host "Voici les membres du groupe $groupe" -ForegroundColor Yellow
 Write-Host $("-" * 80) -ForegroundColor Yellow
 (Get-ADGroupMember -Identity $groupe).Name | Sort-Object
}
