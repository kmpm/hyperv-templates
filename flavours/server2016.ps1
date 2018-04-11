param (
    [Parameter(Mandatory=$true)]
    [string]$projRoot=$(Read-Host -Prompt "Provide path project root"),
    [Parameter(Mandatory=$true)]
    [string]$buildDir=$(Read-Host -Prompt "Provide path to build folder"),

    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]]$userVariables
)

$winbase = Join-Path -Resolve $projRoot "win"

$isoFolder = Join-Path $buildDir "answer-iso"
$outputFile = Join-Path $buildDir "answer.iso"


Write-Host "Cleaning up any temporary files from previous run..."
if (test-path $isoFolder){
    remove-item $isoFolder -Force -Recurse
}

if (test-path $outputFile){
    remove-item $outputFile
}

Write-Host "Creating answer.iso"
mkdir $isoFolder

Copy-Item $winbase\answer_files\2016\Autounattend.xml $isoFolder\
Copy-Item $winbase\scripts\oracle-cert.cer $isoFolder\
Copy-Item $winbase\scripts\bootstrap.ps1 $isoFolder\
Copy-Item $winbase\scripts\unattend.xml $isoFolder\


$textFile = "$isoFolder\Autounattend.xml"
$c = Get-Content -Encoding UTF8 $textFile




# Enable UEFI, disable Non UEFI
$c | ForEach-Object { 
    $_ -replace '<!-- Start Non UEFI -->','<!-- Start Non UEFI' 
} | ForEach-Object { 
    $_ -replace '<!-- Finish Non UEFI -->','Finish Non UEFI -->' 
} | ForEach-Object { 
    $_ -replace '<!-- Start UEFI compatible','<!-- Start UEFI compatible -->' 
} | ForEach-Object { 
    $_ -replace 'Finish UEFI compatible -->','<!-- Finish UEFI compatible -->' 
} | Set-Content -Path $textFile

& .\mkisofs.exe -r -iso-level 4 -UDF -o $outputFile $isoFolder

if (test-path $isoFolder){
    remove-item $isoFolder -Force -Recurse
}

if (-Not (test-path $outputFile)) {
    exit 123
}


Write-Host 'Running Packer'
& packer build @userVariables -var-file='my-variables.json' -var build_dir=$buildDir -var base_dir=$winbase --force $winbase\server2016_1_base.json
