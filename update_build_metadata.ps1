Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$YamlPath = Join-Path $ProjectDir "esp32-s3-box-3.yaml"
$BuildInfoPath = Join-Path $ProjectDir "firmware_build_info.json"

$buildNumber = 1
if (Test-Path $BuildInfoPath) {
  $existing = Get-Content -Raw -Encoding UTF8 $BuildInfoPath | ConvertFrom-Json
  if ($existing.PSObject.Properties.Name -contains "build_number") {
    $buildNumber = [int] $existing.build_number + 1
  }
} elseif (Test-Path $YamlPath) {
  $yamlForNumber = Get-Content -Raw -Encoding UTF8 $YamlPath
  $match = [regex]::Match($yamlForNumber, '(?m)^  build_number: "(\d+)"')
  if ($match.Success) {
    $buildNumber = [int] $match.Groups[1].Value + 1
  }
}

$time = Get-Date
$buildTime = $time.ToString("yyyy-MM-dd HH:mm:ss zzz")
$buildId = "b{0}-{1}" -f $buildNumber, $time.ToString("yyyyMMdd-HHmmss")
$espHomeVersion = (python -m esphome version).Replace("Version:", "").Trim()
if ($LASTEXITCODE -ne 0) {
  throw "Failed to read ESPHome version"
}

$buildInfo = [ordered]@{
  build_number = $buildNumber
  build_id = $buildId
  build_time_str = $buildTime
  esphome_version = $espHomeVersion
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($BuildInfoPath, (($buildInfo | ConvertTo-Json) + "`r`n"), $utf8NoBom)

$yaml = Get-Content -Raw -Encoding UTF8 $YamlPath
$metadataBlock = @"
  build_number: "$buildNumber"
  build_id: "$buildId"
  build_time: "$buildTime"
  build_esphome_version: "$espHomeVersion"
"@

if ($yaml -match "(?ms)^  build_number:.*?^  build_esphome_version:.*?\r?\n") {
  $yaml = [regex]::Replace($yaml, "(?ms)^  build_number:.*?^  build_esphome_version:.*?\r?\n", $metadataBlock + "`r`n", 1)
} else {
  $yaml = $yaml -replace "(?m)^(  screen_idle_timeout: .*\r?\n)", "`$1`r`n$metadataBlock`r`n"
}

[System.IO.File]::WriteAllText($YamlPath, $yaml, $utf8NoBom)
Write-Host "Build metadata: $buildId, ESPHome $espHomeVersion, $buildTime"
