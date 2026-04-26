Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$env:PLATFORMIO_CORE_DIR = "C:\PlatformIO\core"
$env:PLATFORMIO_HOME_DIR = "C:\PlatformIO\home"
$env:PLATFORMIO_WORKSPACE_DIR = Join-Path $ProjectDir ".pio"

Set-Location $ProjectDir
python -m platformio run -t clean
