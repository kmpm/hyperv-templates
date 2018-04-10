

param (
    [Parameter(Mandatory=$true)]
    [string]$flavour
)

$flavoursFolder = '.\flavours'
$flavourFile = Join-Path -Path $flavoursFolder -ChildPath "$($flavour).ps1"


if (-Not (Test-Path $flavourFile)) {
    Write-Host $flavour "is not a valid flavour"
    exit 1    
}

$buildDir = Join-Path $PSScriptRoot 'build'

if (-Not (Test-Path $buildDir)) {
    Write-Host "Creating $buildDir"
    mkdir $buildDir
}



& $flavourFile $PSScriptRoot $buildDir
