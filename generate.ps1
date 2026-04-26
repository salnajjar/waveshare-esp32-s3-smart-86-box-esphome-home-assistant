Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$EspHomeDir = "C:\Users\Seri Al-Najjar\Documents\Dev\ESP32\ESP-S3-Touch-LCD-4B-2\esphome-2026.4.2"

$env:PLATFORMIO_CORE_DIR = "C:\PlatformIO\core"
$env:PLATFORMIO_HOME_DIR = "C:\PlatformIO\home"
$env:PLATFORMIO_WORKSPACE_DIR = Join-Path $ProjectDir ".pio"
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
