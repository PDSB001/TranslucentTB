param(
    [string] $OutputDir = (Join-Path $PSScriptRoot '../../../outputs'),
    [string] $WorkDir = (Join-Path $PSScriptRoot '../../installer-build')
)
$ErrorActionPreference = 'Stop'
$OutputDir = [IO.Path]::GetFullPath($OutputDir)
$WorkDir = [IO.Path]::GetFullPath($WorkDir)
New-Item $WorkDir -ItemType Directory -Force | Out-Null
New-Item $OutputDir -ItemType Directory -Force | Out-Null

function Get-VerifiedFile([string] $Url, [string] $Destination, [string] $Sha256) {
    if (-not (Test-Path -LiteralPath $Destination)) {
        Invoke-WebRequest $Url -OutFile $Destination
    }
    if ((Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash -ne $Sha256) {
        throw "SHA-256 mismatch: $Destination"
    }
}

$portableZip = Join-Path $WorkDir 'portable.zip'
Get-VerifiedFile 'https://github.com/PDSB001/TranslucentTB/releases/download/2026.2-26h2-temp.1/TranslucentTB-UNOFFICIAL-26H2-portable-x64.zip' $portableZip 'B4BD1B31BB143340C9F2EB98AF389996FAF43F0AD8CD614787843B4EA2F8C630'
$compilerSetup = Join-Path $WorkDir 'innosetup-6.7.3.exe'
Get-VerifiedFile 'https://github.com/jrsoftware/issrc/releases/download/is-6_7_3/innosetup-6.7.3.exe' $compilerSetup '9C73C3BAE7ED48D44112A0F48E66742C00090BDB5BEF71D9D3C056C66E97B732'
$compilerDir = Join-Path $WorkDir 'inno'
if (-not (Test-Path (Join-Path $compilerDir 'ISCC.exe'))) {
    $compilerProcess = Start-Process -FilePath $compilerSetup -ArgumentList @('/PORTABLE=1', '/CURRENTUSER', '/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', '/NOICONS', "/DIR=`"$compilerDir`"") -WindowStyle Hidden -Wait -PassThru
    if ($compilerProcess.ExitCode -ne 0) { throw "Inno extraction failed: $($compilerProcess.ExitCode)" }
}
Get-VerifiedFile 'https://raw.githubusercontent.com/jrsoftware/issrc/1f29baac6c6dfd35e04c237af2ea51c482ee782a/Files/Languages/ChineseSimplified.isl' (Join-Path $compilerDir 'Languages/ChineseSimplified.isl') 'E0B0B350E2245F3C5E65586DFE43D574F6E7F06F2261149ABA284954B3FC9A8D'
$payloadDir = Join-Path $WorkDir 'payload'
Expand-Archive -LiteralPath $portableZip -DestinationPath $payloadDir -Force
& (Join-Path $compilerDir 'ISCC.exe') "/DPayloadDir=$payloadDir" "/DOutputDir=$OutputDir" (Join-Path $PSScriptRoot 'temporary-26h2.iss')
if ($LASTEXITCODE -ne 0) { throw "Installer compilation failed: $LASTEXITCODE" }
Get-FileHash (Join-Path $OutputDir 'TranslucentTB-UNOFFICIAL-26H2-Setup-x64.exe') -Algorithm SHA256
