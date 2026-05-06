# Waveshare ESP32 Smart 86 Box ESPHome Home Assistant

ESPHome build output and source for running the Waveshare ESP32-S3 Smart 86 Box with Home Assistant.

This repository also includes an experimental ESP32-P4 Smart 86 Box build target.

See [CHANGELOG.md](CHANGELOG.md) for the project changelog generated from Git commits.

## Status

**2026-05-06:** Rebuilt the ESP32-S3 firmware with smaller centered RGB565 screen images and matching page background fills, reducing firmware size while keeping the display layout tidy.

**2026-05-05:** Updated both ESP32-S3 and ESP32-P4 builds to ESPHome 2026.4.4.

Everything is working nicely overall with caveats:

**Audio:** Volume should not be set above 83%, as higher levels can introduce noticeable distortion.

**Physical:** The on-device buttons work to control the volume up and down, but volume adjustment from the buttons is a little finicky.

**OTA Updates:** The screen can glitch heavily while an OTA flash is in progress.

## Built Firmware Images

### ESP32-S3 Smart 86 Box

Compiled firmware images are included in this repository under:

```text
.pioenvs/esp32-s3-box-3/
```

Useful files:

- [firmware.factory.bin](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/raw/main/.pioenvs/esp32-s3-box-3/firmware.factory.bin)
- [firmware.ota.bin](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/raw/main/.pioenvs/esp32-s3-box-3/firmware.ota.bin)
- [firmware.bin](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/raw/main/.pioenvs/esp32-s3-box-3/firmware.bin)
- [firmware.elf](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/raw/main/.pioenvs/esp32-s3-box-3/firmware.elf)
- [firmware.map](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/raw/main/.pioenvs/esp32-s3-box-3/firmware.map)

Use `firmware.factory.bin` for first-time flashing, and `firmware.ota.bin` for OTA updates.

### ESP32-P4 Smart 86 Box

An experimental P4 build is included under:

```text
.pioenvs/esp32-p4-smart-86-box/
```

Useful files:

- [firmware.factory.bin](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/raw/main/.pioenvs/esp32-p4-smart-86-box/firmware.factory.bin)
- [firmware.ota.bin](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/raw/main/.pioenvs/esp32-p4-smart-86-box/firmware.ota.bin)
- [firmware.bin](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/raw/main/.pioenvs/esp32-p4-smart-86-box/firmware.bin)

The P4 configuration is [esp32-p4-smart-86-box.yaml](esp32-p4-smart-86-box.yaml). It currently includes hosted Wi-Fi, display, touch, microphone, speaker, voice assistant wiring, OTA, API, and diagnostics. Bluetooth proxy is not enabled in this preview because the ESP32-P4 uses a hosted ESP32-C6 radio and the stock ESPHome Bluetooth proxy path expects local ESP32 Bluetooth headers.

## Building In This Folder

If you changed only C++ files under `src/`, build from this folder with the included PowerShell wrapper:

```powershell
.\build.ps1
```

The wrapper runs PlatformIO with the ESPHome-generated `platformio.ini` and writes build output under:

```text
.pio/build/esp32-s3-box-3/
```

It also mirrors the main firmware binaries back to:

```text
.pioenvs/esp32-s3-box-3/
```

Do not build this folder with the ESP-IDF extension's raw `ninja` task. ESPHome generates a PlatformIO project with required build flags; skipping those flags causes linker errors such as `undefined reference to app_main`.

To clean the local build output:

```powershell
.\clean.ps1
```

If you changed `esp32-s3-box-3.yaml`, regenerate and build with:

```powershell
.\generate.ps1
```

To upload the S3 build over OTA or serial, use the project wrapper rather than running `python -m esphome upload` directly:

```powershell
.\upload.ps1 192.168.1.188
```

or:

```powershell
.\upload.ps1 COM12
```

The ESPHome release used for generation is controlled by `version.txt`. `build.ps1`, `generate.ps1`, and `upload.ps1` call `ensure_esphome_source.ps1`, which clones the matching `esphome-$version` source tree if it is not already present. To move to a future ESPHome release, change `version.txt` and run `.\generate.ps1` or `.\build.ps1`.

Do not upload this build with plain `python -m esphome upload ...` unless your shell already has the same `PYTHONPATH` as the wrapper scripts. The global ESPHome package on a workstation may be older than `version.txt`, and can produce firmware without this project's patched display/audio source.

Each build updates `firmware_build_info.json`, increments the firmware build number, stamps the current date/time, and exposes that value in Home Assistant as the `ESP32 S3 Box 3 Firmware Build` diagnostic text sensor.

## First-Time Setup

1. Flash the device with `firmware.factory.bin`.
2. Power-cycle the device after flashing and wait for it to boot.
3. If the device does not already have Wi-Fi credentials, it will start its fallback Wi-Fi access point after a short wait. This build uses a 90 second AP timeout.
4. On your phone or computer, open Wi-Fi settings and connect to the ESPHome fallback hotspot for the device. It should appear with a name based on `ESP32 S3 Box 3` or `esp32-s3-box-3`.
5. After connecting, the captive portal should open automatically. If it does not, open a browser and go to:

```text
http://192.168.4.1
```

6. Select your home Wi-Fi network, enter the Wi-Fi password, and save.
7. The device will reboot and join your Wi-Fi network.

## Adding To Home Assistant

1. Open Home Assistant.
2. Go to `Settings` > `Devices & services`.
3. Home Assistant may automatically discover the ESPHome device. If it appears, choose `Configure`.
4. If it is not discovered automatically, select `Add integration`, search for `ESPHome`, and enter the device address.

Useful addresses to try:

```text
esp32-s3-box-3.local
```

or the IP address assigned by your router.

5. Follow the prompts to finish adding the device.

After setup, the device should appear as an ESPHome device in Home Assistant and expose its available controls and sensors.
