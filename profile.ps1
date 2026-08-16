Set-PSReadLineOption -Colors @{
  Parameter = "White"
  Operator = "White"
}

# Open the shortcut for developer settings, go to the VC folder, find the 64 version, right click, press 'properties' and on the first page copy the command and past it below
# . "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat"

# 1. Import the VS Developer Shell module
Import-Module "C:\Program Files\Microsoft Visual Studio\18\Community\Common7\Tools\Microsoft.VisualStudio.DevShell.dll"

# 2. Initialize the environment for x64 development
Enter-VsDevShell -VsInstallPath "C:\Program Files\Microsoft Visual Studio\18\Community" -SkipAutomaticLocation -Arch amd64

Set-PSReadlineOption -EditMode Vi

# Aliases
function gits { git status @args }
function vim { nvim @args }
function d { cd ~/Desktop }
function ex { explorer.exe .}

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

$env:CXX = "clang++.exe"
$env:CC = "clang.exe"

(&mise activate pwsh) | Out-String | Invoke-Expression
Invoke-Expression  (&task --completion powershell | Out-String)

# [System.Console]::OutputEncoding = [System.Text.Encoding]::Unicode

if ($PWD.Path -eq "$env:SystemRoot\System32") {
    Set-Location $HOME
}

Set-Variable -Name MaximumHistoryCount -Value 30000

Set-PSReadLineOption –HistoryNoDuplicates:$true
Set-PSReadLineOption -ViModeIndicator:Cursor

# Fzf
# Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
#     $command = Get-Content (Get-PSReadlineOption).HistorySavePath | ForEach-Object -Begin { $hash = @{} } -Process { if (!$hash[$_]) { $hash[$_] = $true; $_ } } | fzf --tac
#     [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
# }

Set-PSReadLineKeyHandler -Chord Ctrl+r -ScriptBlock {
    $history = Get-Content (Get-PSReadlineOption).HistorySavePath
    if ($history) {
        [array]::Reverse($history)
        $unique = $history | Select-Object -Unique
        [array]::Reverse($unique)
        
        # Adding --scheme=history ensures recent matches stay closest to your cursor
        $command = $unique | fzf --tac --no-sort
        if ($command) {
          [Microsoft.PowerShell.PSConsoleReadLine]::Insert($command)
        }
    }
}

Set-PSReadLineKeyHandler -Chord 'Ctrl+Spacebar' -Function Complete

# Note: To set global env variables, use the setup_env_variables script
