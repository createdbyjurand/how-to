# powershell ./start.ps1
# powershell -ExecutionPolicy ByPass -File start.ps1

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
  Start-Process powershell "-NoProfile -NoExit -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit
}

########################### variables ###########################

if (!$host) {
  $host = Get-Host
}

$terminalWindowWidth = $host.ui.rawui.windowsize.width

$latestNodeVersion = nvm list available
$latestNodeVersion = $latestNodeVersion[3].split("|")
$latestNodeLtsVersion = $latestNodeVersion[2].replace(" ", "")
$latestNodeVersion = $latestNodeVersion[1].replace(" ", "")

$currentNodeVersion = node -v
$currentNodeVersion = $currentNodeVersion.Substring(1)
$currrentNpmVersion = npm -v

$currrentNpmVersion = npm -v
$latestNpmVersion = ""
$npmGloballyOutdated = npm -g outdated

foreach ($line in $npmGloballyOutdated) {
  if ($line -match "^npm.*$") {
    $latestNpmVersion = ($line -split "\s+")[3]
    Break
  }
}

########################### functions ###########################

function Write-HostWithTab($left, $right) {
  $i = $terminalWindowWidth - $left.length - $right.length
  $s = " "
  while ($i -gt 2) {
    $s += "."
    $i--
  }
  $s += " "
  Write-Host -NoNewLine "`r$left" -ForegroundColor Cyan
  Write-Host -NoNewLine $s -ForegroundColor DarkGray
  Write-Host $right -ForegroundColor Green
}

function Remove-NpmCacheFolder {
  $Message = "Removing \npm-cache"
  Write-Host -NoNewline $Message
  Remove-Item -Path "$env:APPDATA\npm-cache" -Recurse
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

function Remove-NpmFile {
  $Message = "Removing \nodejs\npm"
  Write-Host -NoNewline $Message
  Remove-Item -Path "$env:APPDATA\nodejs\npm"
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

function Remove-NpmCmdFile {
  $Message = "Removing \nodejs\npm.cmd"
  Write-Host -NoNewline $Message
  Remove-Item -Path "$env:APPDATA\nodejs\npm.cmd"
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

function Remove-NpmPs1File {
  $Message = "Removing \nodejs\npm.ps1"
  Write-Host -NoNewline $Message
  Remove-Item -Path "$env:APPDATA\nodejs\npm.ps1" -ErrorAction Ignore
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

function Remove-NpxFile {
  $Message = "Removing \nodejs\npx"
  Write-Host -NoNewline $Message
  Remove-Item -Path "$env:APPDATA\nodejs\npx"
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

function Remove-NpxCmdFile {
  $Message = "Removing \nodejs\npx.cmd"
  Write-Host -NoNewline $Message
  Remove-Item -Path "$env:APPDATA\nodejs\npx.cmd"
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

function Remove-NpxPs1File {
  $Message = "Removing \nodejs\npx.ps1"
  Write-Host -NoNewline $Message
  Remove-Item -Path "$env:APPDATA\nodejs\npx.ps1" -ErrorAction Ignore
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

function Rename-NpmFolderToNpmOld {
  $Message = "Renaming \nodejs\node_modules\npm to npm_old"
  Write-Host -NoNewline $Message
  Rename-Item -Path "$env:APPDATA\nodejs\node_modules\npm" -NewName "npm_old"
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

function Install-LatestNpmVersionUsingNpmOldFolder {
  $Message = "Installing npm@latest"
  Write-Host -NoNewline $Message
  Invoke-Expression -Command "node `"$env:APPDATA\nodejs\node_modules\npm_old\bin\npm-cli.js`" i -g npm@latest"
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

function Remove-NpmOldFolder {
  $Message = "Removing \nodejs\node_modules\npm_old"
  Write-Host -NoNewline $Message
  Remove-Item -Path "$env:APPDATA\nodejs\node_modules\npm_old" -Recurse
  Write-HostWithTab -left $Message -right "[   OK   ]"
}

########################### middleware functions ###########################

function Update-Node {
  Remove-NpmCacheFolder
}

function Update-Npm {
  Remove-NpmCacheFolder
  Remove-NpmFile
  Remove-NpmCmdFile
  Remove-NpmPs1File
  Remove-NpxFile
  Remove-NpxCmdFile
  Remove-NpxPs1File
  Rename-NpmFolderToNpmOld
  Install-LatestNpmVersionUsingNpmOldFolder
  Remove-NpmOldFolder
}

########################### code ###########################

if ($currentNodeVersion -ne $latestNodeLtsVersion) {
  $Input = Read-Host -Prompt "Do you want to update Node? Y/N"
  if ($Input -eq "Y" -Or $Input -eq "y") {
    Update-Node
  }
} else {
  Write-Host "Node is up to date" -ForegroundColor Green
}

if ($currrentNpmVersion -ne $latestNpmVersion -And $latestNpmVersion -ne "") {
  $Input = Read-Host -Prompt "Do you want to update Npm? Y/N"
  if ($Input -eq "Y" -Or $Input -eq "y") {
    Update-Npm
  }
} else {
  Write-Host "Npm is up to date" -ForegroundColor Green
}

Write-HostWithTab -left "Script ended" -right "[  DONE  ]"
