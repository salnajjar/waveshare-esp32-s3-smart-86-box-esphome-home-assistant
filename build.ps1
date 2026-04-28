Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$env:PLATFORMIO_CORE_DIR = "C:\PlatformIO\core"
$env:PLATFORMIO_HOME_DIR = "C:\PlatformIO\home"
$env:PLATFORMIO_WORKSPACE_DIR = Join-Path $ProjectDir ".pio"
$EspHomeDir = (& powershell -ExecutionPolicy Bypass -File (Join-Path $ProjectDir "ensure_esphome_source.ps1") | Select-Object -Last 1)
$env:PYTHONPATH = $EspHomeDir

Set-Location $ProjectDir
& powershell -ExecutionPolicy Bypass -File (Join-Path $ProjectDir "update_build_metadata.ps1")
if ($LASTEXITCODE -ne 0) {
  throw "Build metadata update failed"
}
python -m esphome compile .\esp32-s3-box-3.yaml
if ($LASTEXITCODE -ne 0) {
  throw "ESPHome compile failed"
}

$FirmwareDir = Join-Path $ProjectDir ".pioenvs\esp32-s3-box-3"
$MirrorDir = Join-Path $ProjectDir ".pioenvs\esp32-s3-box-3"
New-Item -ItemType Directory -Force -Path $MirrorDir | Out-Null

foreach ($Name in @("firmware.bin", "firmware.factory.bin", "firmware.ota.bin", "bootloader.bin", "partitions.bin", "ota_data_initial.bin")) {
  $Source = Join-Path $FirmwareDir $Name
  $Destination = Join-Path $MirrorDir $Name
  if ((Test-Path $Source) -and ($Source -ne $Destination)) {
    Copy-Item -Force $Source $Destination
  }
}

Write-Host ""
Write-Host "Build complete."
Write-Host "Factory firmware: $FirmwareDir\firmware.factory.bin"
Write-Host "OTA firmware:     $FirmwareDir\firmware.ota.bin"
Write-Host "Mirrored to:      $MirrorDir"
