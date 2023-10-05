#==========================================================================
# AUTEUR: Richard Jean
# DATE:   14 septembre 2022
#
# La variable $info contient toutes les unités d'organisation
# qui sont sous "OU=FORMATION,DC=FORMATION,DC=LOCAL".
#
# Le contenu de la variable $info est triées en ordre alphabétique selon
# la propriété CanonicalName.
#==========================================================================
Clear-Host

$OU = "OU=FORMATION,DC=FORMATION,DC=LOCAL"

$info = Get-ADOrganizationalUnit -Filter * `
                                 -SearchBase $OU `
                                 -Properties CanonicalName | Sort-Object CanonicalName

Write-Host ("-" * 100) -ForegroundColor Yellow
Write-Host ("CanonicalName") -ForegroundColor Yellow
Write-Host ("-------------") -ForegroundColor Yellow
$info.CanonicalName

Write-Host ("-" * 100) -ForegroundColor Yellow
Write-Host ("DistinguishedName") -ForegroundColor Yellow
Write-Host ("-----------------") -ForegroundColor Yellow
$info.DistinguishedName

Write-Host ("-" * 100) -ForegroundColor Yellow
