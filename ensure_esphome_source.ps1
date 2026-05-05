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
  $patchedVoiceAssistantSource = $patchedVoiceAssistantSource.Replace(@"
    memset(this->speaker_buffer_, 0, SPEAKER_BUFFER_SIZE);

    this->speaker_buffer_size_ = 0;
"@, @"
    memset(this->speaker_buffer_, 0, SPEAKER_BUFFER_SIZE);

    this->speaker_buffer_start_ = 0;
    this->speaker_buffer_size_ = 0;
"@)
  $patchedVoiceAssistantSource = $patchedVoiceAssistantSource.Replace(@"
          if (this->speaker_buffer_index_ + RECEIVE_SIZE < SPEAKER_BUFFER_SIZE) {
            received_len = this->socket_->read(this->speaker_buffer_ + this->speaker_buffer_index_, RECEIVE_SIZE);
"@, @"
          if (this->speaker_buffer_index_ + RECEIVE_SIZE > SPEAKER_BUFFER_SIZE && this->speaker_buffer_start_ > 0) {
            memmove(this->speaker_buffer_, this->speaker_buffer_ + this->speaker_buffer_start_,
                    this->speaker_buffer_size_);
            this->speaker_buffer_index_ = this->speaker_buffer_size_;
            this->speaker_buffer_start_ = 0;
          }
          if (this->speaker_buffer_index_ + RECEIVE_SIZE <= SPEAKER_BUFFER_SIZE) {
            received_len = this->socket_->read(this->speaker_buffer_ + this->speaker_buffer_index_, RECEIVE_SIZE);
"@)
  $patchedVoiceAssistantSource = $patchedVoiceAssistantSource.Replace(@"
      size_t write_chunk = std::min<size_t>(this->speaker_buffer_size_, 8 * 1024);
      size_t written = this->speaker_->play(this->speaker_buffer_, write_chunk, pdMS_TO_TICKS(25));
"@, @"
      size_t write_chunk = std::min<size_t>(this->speaker_buffer_size_, 8 * 1024);
      size_t written = this->speaker_->play(this->speaker_buffer_ + this->speaker_buffer_start_, write_chunk,
                                            pdMS_TO_TICKS(25));
"@)
  $patchedVoiceAssistantSource = $patchedVoiceAssistantSource.Replace(@"
        memmove(this->speaker_buffer_, this->speaker_buffer_ + written, this->speaker_buffer_size_ - written);
        this->speaker_buffer_size_ -= written;
        this->speaker_buffer_index_ -= written;
"@, @"
        this->speaker_buffer_start_ += written;
        this->speaker_buffer_size_ -= written;
        if (this->speaker_buffer_size_ == 0) {
          this->speaker_buffer_start_ = 0;
          this->speaker_buffer_index_ = 0;
        }
"@)
  $patchedVoiceAssistantSource = $patchedVoiceAssistantSource.Replace(@"
    if (this->speaker_buffer_index_ + msg.data_len < SPEAKER_BUFFER_SIZE) {
      memcpy(this->speaker_buffer_ + this->speaker_buffer_index_, msg.data, msg.data_len);
"@, @"
    if (this->speaker_buffer_index_ + msg.data_len > SPEAKER_BUFFER_SIZE && this->speaker_buffer_start_ > 0) {
      memmove(this->speaker_buffer_, this->speaker_buffer_ + this->speaker_buffer_start_, this->speaker_buffer_size_);
      this->speaker_buffer_index_ = this->speaker_buffer_size_;
      this->speaker_buffer_start_ = 0;
    }
    if (this->speaker_buffer_index_ + msg.data_len <= SPEAKER_BUFFER_SIZE) {
      memcpy(this->speaker_buffer_ + this->speaker_buffer_index_, msg.data, msg.data_len);
"@)
  if ($patchedVoiceAssistantSource -ne $voiceAssistantSource) {
    Set-Content -Encoding UTF8 -Path $VoiceAssistantPath -Value $patchedVoiceAssistantSource
  }
}

$VoiceAssistantHeaderPath = Join-Path $EspHomeDir "esphome\components\voice_assistant\voice_assistant.h"
if (Test-Path $VoiceAssistantHeaderPath) {
  $voiceAssistantHeader = Get-Content -Raw -Encoding UTF8 $VoiceAssistantHeaderPath
  $patchedVoiceAssistantHeader = $voiceAssistantHeader.Replace(@"
  uint8_t *speaker_buffer_{nullptr};
  size_t speaker_buffer_index_{0};
"@, @"
  uint8_t *speaker_buffer_{nullptr};
  size_t speaker_buffer_start_{0};
  size_t speaker_buffer_index_{0};
"@)
  if ($patchedVoiceAssistantHeader -ne $voiceAssistantHeader) {
    Set-Content -Encoding UTF8 -Path $VoiceAssistantHeaderPath -Value $patchedVoiceAssistantHeader
  }
}

$I2sSpeakerPath = Join-Path $EspHomeDir "esphome\components\i2s_audio\speaker\i2s_audio_speaker.cpp"
if (Test-Path $I2sSpeakerPath) {
  $i2sSpeakerSource = Get-Content -Raw -Encoding UTF8 $I2sSpeakerPath
  $patchedI2sSpeakerSource = $i2sSpeakerSource
  if ($patchedI2sSpeakerSource -notmatch '#include <array>') {
    $patchedI2sSpeakerSource = $patchedI2sSpeakerSource -replace '#include <driver/i2s_std.h>', "#include <driver/i2s_std.h>`r`n`r`n#include <array>"
  }
  $patchedI2sSpeakerSource = $patchedI2sSpeakerSource -replace 'static const std::vector<int16_t> Q15_VOLUME_SCALING_FACTORS = \{', 'static const std::array<int16_t, 100> Q15_VOLUME_SCALING_FACTORS = {'
  $patchedI2sSpeakerSource = $patchedI2sSpeakerSource -replace 'xTaskCreate\(I2SAudioSpeaker::speaker_task, "speaker_task", TASK_STACK_SIZE, \(void \*\) this, TASK_PRIORITY,\s*&this->speaker_task_handle_\);', 'xTaskCreatePinnedToCore(I2SAudioSpeaker::speaker_task, "speaker_task", TASK_STACK_SIZE, (void *) this, TASK_PRIORITY, &this->speaker_task_handle_, 1);'
  if ($patchedI2sSpeakerSource -ne $i2sSpeakerSource) {
    Set-Content -Encoding UTF8 -Path $I2sSpeakerPath -Value $patchedI2sSpeakerSource
  }
}

Write-Output $EspHomeDir
