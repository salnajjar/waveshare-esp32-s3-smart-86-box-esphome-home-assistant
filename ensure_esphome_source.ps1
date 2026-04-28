Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$VersionPath = Join-Path $ProjectDir "version.txt"
if (!(Test-Path $VersionPath)) {
  throw "Missing version.txt"
}

$Version = (Get-Content -Raw -Encoding UTF8 $VersionPath).Trim()
if ($Version.Length -eq 0) {
  throw "version.txt is empty"
}

$SourceRoot = $env:ESPHOME_SOURCE_ROOT
if ([string]::IsNullOrWhiteSpace($SourceRoot)) {
  $SourceRoot = "C:\Users\Seri Al-Najjar\Documents\Dev\ESP32\ESP-S3-Touch-LCD-4B-2"
}

$EspHomeDir = Join-Path $SourceRoot "esphome-$Version"
if (!(Test-Path $EspHomeDir)) {
  Write-Host "ESPHome $Version source not found. Cloning to $EspHomeDir"
  git clone --depth 1 --branch $Version https://github.com/esphome/esphome.git $EspHomeDir
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to clone ESPHome $Version"
  }
}

$ConstPath = Join-Path $EspHomeDir "esphome\const.py"
if (!(Test-Path $ConstPath)) {
  throw "Invalid ESPHome source path: $EspHomeDir"
}

Write-Output $EspHomeDir
