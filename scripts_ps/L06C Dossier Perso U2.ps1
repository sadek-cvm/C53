#==========================================================================
# AUTEUR: Richard Jean
# DATE  : 10 février 2023
#
# Modification du dossier personnel de l'utilisateur U2
#==========================================================================
Clear-Host

$NomOrdi         = "SERVEUR1"
$NomDossierPerso = "_Perso2"
$chemin          = "\\$NomOrdi\E$\$NomDossierPerso"

$NomPartagePerso = "Perso2$"
$cheminUNC       = "\\$NomOrdi\$NomPartagePerso"

#Création du dossier racine
New-Item -Path $chemin `
         -ItemType directory 

icacls.exe $chemin /inheritance:r

# S-1-5-18 est le SID pour "Système"
# S-1-3-4  est le SID pour "DROITS DU PROPRIÉTAIRE"
icacls.exe $chemin /grant "Administrateurs:(OI)(CI)(F)"
icacls.exe $chemin /grant "TECH:(OI)(CI)(F)"
icacls.exe $chemin /grant "*S-1-5-18:(OI)(CI)(F)"
icacls.exe $chemin /grant "*S-1-3-4:(OI)(CI)(M)"
icacls.exe $chemin /grant "Utilisateurs du domaine:(RX)" 

#Création du partage sur le dossier racine
New-SMBShare -Name $NomPartagePerso `
             -Path "C:\$NomDossierPerso" `
             -FullAccess "Tout le monde" `
             -FolderEnumerationMode AccessBased `
             -CachingMode none `
             -CIMSession $NomOrdi

#==========================================================================
#Création du dossier personnel pour l'utilisateur U2
$nomUsager = "U2"

New-Item -Path "$chemin\$nomUsager" `
         -ItemType directory 

icacls.exe "$chemin\$nomUsager" /grant $nomUsager":(OI)(CI)(M)" 

#==========================================================================
#Modification des propriétés de l'utilisateur U2 pour son dossier personnel
Set-ADUser -Identity $nomUsager `
           -HomeDrive "X:" `
           -HomeDirectory "$cheminUNC\$nomUsager"
