

param (
    [Parameter(Mandatory=$true)]
    [string]$flavour

    # [string]$variables
)

$flavoursFolder = '.\flavours'
$flavourFile = Join-Path -Path $flavoursFolder -ChildPath "$($flavour).ps1"

if (-Not (Test-Path $flavourFile)) {
    Write-Host $flavour "is not a valid flavour"
    exit 1    
}

$buildDir = Join-Path $PSScriptRoot 'build_cache'

if (-Not (Test-Path $buildDir)) {
    Write-Host "Creating $buildDir"
    mkdir $buildDir
}

# if (-Not (Test-Path -IsValid -Path $variables )) {
#     $variables=Null
# }

& $flavourFile $PSScriptRoot $buildDir
