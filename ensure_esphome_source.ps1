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

$VoiceAssistantPath = Join-Path $EspHomeDir "esphome\components\voice_assistant\voice_assistant.cpp"
if (Test-Path $VoiceAssistantPath) {
  $voiceAssistantSource = Get-Content -Raw -Encoding UTF8 $VoiceAssistantPath
  $patchedVoiceAssistantSource = $voiceAssistantSource -replace "static const size_t SPEAKER_BUFFER_SIZE = 64 \* RECEIVE_SIZE;", @"
// The Smart 86 Box builds can briefly stall while display/audio tasks share the loop.
// Keep more incoming API audio queued so short stalls do not drop TTS chunks.
static const size_t SPEAKER_BUFFER_SIZE = 256 * RECEIVE_SIZE;
"@
  if ($patchedVoiceAssistantSource -ne $voiceAssistantSource) {
    Set-Content -Encoding UTF8 -Path $VoiceAssistantPath -Value $patchedVoiceAssistantSource
  }
}

Write-Output $EspHomeDir
