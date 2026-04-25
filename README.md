# Waveshare ESP32-S3 Smart 86 Box ESPHome Home Assistant

ESPHome build output and source for running the Waveshare ESP32-S3 Smart 86 Box with Home Assistant.

## Status

Everything is working nicely overall.

One audio note: volume should not be set above 83%, as higher levels can introduce noticeable distortion.

The on-device volume buttons work, but volume adjustment from the buttons is a little finicky.

## Built Firmware Images

Compiled firmware images are included in this repository under:

```text
.pioenvs/esp32-s3-box-3/
```

Useful files:

```text
firmware.factory.bin
firmware.ota.bin
firmware.bin
bootloader.bin
partitions.bin
ota_data_initial.bin
```

Use `firmware.factory.bin` for first-time flashing, and `firmware.ota.bin` for OTA updates.
