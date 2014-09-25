param(
[string] $APIKey,
[string] $Username,
[string] $Password,
[string] $Format,
[int] $Permission,
[string] $Expires,
[string] $File,
[switch] $Help
)
$Name = [io.path]::GetFileNameWithoutExtension("$File")
$Paste = Get-Content -LiteralPath $File -Raw
if ($Help -eq $true){
    [int] $hm = 0
    while($hm -lt 1 -or $hm.choice -gt 6){
        Write-Host "What do you need help with?"
        Write-Host "1. API Key"
        Write-Host "2. Username & Password"
        Write-Host "3. Format"
        Write-Host "4. Permission"
        Write-Host "5. Expires"
        Write-Host "6. File"
        Write-Host "Example Call:"
        Write-Host '.\New-Pastebin.ps1 -APIKey "################################" -Username "Name" -Password "Pass" -Format "Powershell" -Permission "0" -Expires "N" -File "C:\Files\yourfile.ps1"'
        [int] $hm = Read-Host "[1-6]:>"
        switch($hm){
            1 {
                Clear-Host
                Write-Host "The api key for your account can be found on pastebin at:"
                Write-Host ""
                Write-Host "http://pastebin.com/api#1"
                pause
                exit
            }
            2 {
                Clear-Host
                Write-Host "Your username and password are the same ones you use for pastebin(they will not be collected or used in any way execpt for pasting your paste, they will also not be saved.):"
                pause
                exit
            }
            3 {
                Clear-Host
                Write-Host "'Format' is the syntax highlighting for the code you are uploading, the codes for each format can be found on the Pastebin website at:"
                write-Host ""
                Write-Host "http://pastebin.com/api#5"
                pause
                exit
            }
            4 {
               Clear-Host
               Write-Host "'Permission' is used to specify whether you want your paste: Public, Unlisted, or Private."
               Write-Host ""
               Write-Host "0 = Public"
               Write-Host "1 = Unlisted"
               Write-Host "2 = Private" 
               pause
               exit
            }
            5 {
                Clear-Host
                Write-Host "'Expires' tells Pastebin how long to keep you paste on their servers."
                Write-Host ""
                Write-Host "N = Never Expires"
                Write-Host "1H = 1 Hour"
                Write-Host "1D = 1 Day"
                Write-Host "1W = 1 Week"
                Write-Host "2W = 2 Weeks"
                Write-Host "1M = 1 Month"
                pause
                exit
            }
            6 {
                Clear-Host
                Write-Host "'File' is the long path to the file you would like to upload to Pastebin."
                pause
                exit
            }
            default {exit}
        }
    }
}
function post_http($url,$parameters) 
        { 
            $http_request = New-Object -ComObject Msxml2.XMLHTTP 
            $http_request.open("POST", $url, $false) 
            $http_request.setRequestHeader("Content-type","application/x-www-form-urlencoded") 
            $http_request.setRequestHeader("Content-length", $parameters.length); 
            $http_request.setRequestHeader("Connection", "close") 
            $http_request.send($parameters) 
            $script:Session=$http_request.responseText 
        }
post_http "https://pastebin.com/api/api_login.php" "api_dev_key=$APIKey&api_user_name=$Username&api_user_password=$Password" 
post_http "http://pastebin.com/api/api_post.php" "api_user_key=$Session&api_option=paste&api_dev_key=$APIKey&api_paste_name=$Name&api_paste_code=$Paste&api_paste_private=$Permission&api_paste_format=$Format&api_paste_expire_date=$Expires"