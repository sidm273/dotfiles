################
# Created/Changed using: ChatGPT Sol 6.1
# HUMAN VERIFICATION: LGTM.
################
Set-Alias du dust
Set-Alias vi nvim
Set-Alias vim nvim
Set-Alias n nvim
Set-Alias j just

. "$PSScriptRoot/yazi.ps1"

function x { exit }

if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    (& zoxide init powershell --cmd cd) | Out-String | Invoke-Expression
}
if (Get-Command starship -ErrorAction SilentlyContinue) {
    (& starship init powershell) | Out-String | Invoke-Expression
}
