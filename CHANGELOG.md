# Changelog

This changelog is generated from the Git commit history for this project.

## 2026-06-02

- Updated the project ESPHome source pin from 2026.5.1 to 2026.5.2.
- Raised the S3 and P4 ESPHome minimum versions to 2026.5.2.
- Kept the PCA9554 output-state preservation patch in the ESPHome source preparation step so the S3 display continues to initialize correctly.

## 2026-05-26

- Updated the project ESPHome source pin from 2026.5.0 to 2026.5.1.
- Raised the S3 and P4 ESPHome minimum versions to 2026.5.1.
- Updated the ESP32-P4 preview project version marker to 2026.5.1.

## 2026-05-21

- Updated the project ESPHome source pin from 2026.4.5 to 2026.5.0.
- Raised the S3 and P4 ESPHome minimum versions to 2026.5.0.
- Kept the automatic S3 display source fix in the ESPHome source preparation step so PCA9554 output state is preserved after future source updates.
- Updated the source patcher for ESPHome 2026.5.0 voice assistant and I2S speaker changes so the existing larger audio buffer and pinned speaker task fixes continue to apply.
- Added ESPHome Dashboard import metadata to the S3 and P4 YAML files so the devices can be adopted for future ESPHome-managed updates from this repository.
- Rebuilt the ESP32-S3 firmware as build b66 with ESPHome 2026.5.0.
- Rebuilt and mirrored the ESP32-P4 preview firmware binaries with ESPHome 2026.5.0.

## 2026-05-07

- Updated the project ESPHome source pin from 2026.4.4 to 2026.4.5.
- Raised the S3 and P4 ESPHome minimum versions to 2026.4.5.
- Rebuilt the ESP32-S3 firmware as build b63 with ESPHome 2026.4.5.
- Rebuilt and mirrored the ESP32-P4 preview firmware binaries with ESPHome 2026.4.5.
- Fixed the S3 blank-screen regression on ESPHome 2026.4.5 by preserving PCA9554 expander output state during setup.
- Rebuilt and OTA-tested the ESP32-S3 firmware as build b64 with the display fix.

## 2026-05-06

- Rebuilt the ESP32-S3 firmware as build b62 with reduced-size RGB565 assistant images.
- Centered the reduced S3 state images on the 480 x 480 display and restored per-state background fills for the newly exposed border area.
- Switched the S3 image references to local repository image files so local builds do not depend on the raw GitHub branch already containing the new assets.
- Reduced the S3 firmware flash footprint by roughly 1.15 MB compared with the previous full-size image build.

## 2026-05-05

- Added a tap-to-stop button on the S3 timer-finished screen so the timer alarm can be stopped from the same location as the countdown.
- Reworked the S3 timer-finished flow to draw the finished screen before starting alarm playback, reducing avoidable blocking warnings.
- Fixed S3 timer countdown drift by rendering remaining time from a monotonic display anchor rather than delayed timer tick cadence.
- Sanitized S3 assistant speech text before display so newline and tab characters do not trigger missing font glyph warnings.
- Increased the shared ESPHome voice assistant receive buffer used by both S3 and P4 builds to reduce dropped TTS audio chunks when the device briefly stalls.
- Updated the P4 preview config to require ESPHome 2026.4.4 and rebuilt the P4 firmware binaries with the shared voice assistant buffer fix.
- Added an upload wrapper and raised the S3 config minimum to ESPHome 2026.4.4 so local uploads do not silently use an older global ESPHome install.
- Updated both ESP32-S3 and ESP32-P4 firmware builds to ESPHome 2026.4.4.

## 2026-05-02

- [506827e](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/506827e) Added an experimental ESP32-P4 Smart 86 Box build, including a separate ESPHome YAML, compiled firmware binaries, and README download links.

## 2026-04-28
- [8bd4daa](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/8bd4daa) Fixed the input / output dialogue boxes to make them rounded and positioned correctly.
- [8ae3041](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/8ae3041) ESPHome 2026.4.3 build broke the display output, this has been corrected
- [0002b22](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/0002b22) Updated readme.md
- [a1b7f17](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/a1b7f17) Updated to ESPHome 2026.4.3

## 2026-04-27

- [5eaac19](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/5eaac19) Made the text boxes better placed for "heard" and "responded"
- [caac2d6](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/caac2d6) Made the readme more descriptive and accurate.
- [a197b6a](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/a197b6a) Performance tuning and tweaking to increase responsiveness.
- [1ff393a](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/1ff393a) Updated the readme.md to give links directly to the firmware files to download.
- [0430dd6](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/0430dd6) Changed the image display format from RGB to ARGB to reduce memory usage. Made the images full screen. Added a time and date display in the top right corner.
- [ac17277](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/ac17277) Made custom images and resized them to the correct dimensions for the display

## 2026-04-26

- [f23c4f3](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/f23c4f3) Cleaned up the build environment and embedded version information into the firmware.
- [a3c6f37](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/a3c6f37) Displays the device IP address in ESPHome and blanks the screen before performing an OTA update.
- [8b34676](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/8b34676) Added diagnostic data as sensors for Home Assistant
- [2e8833e](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/2e8833e) Updated the readme
- [17e5bfb](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/17e5bfb) Added the yaml file to the repo
- [a9fef34](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/a9fef34) Update generated ESPHome build

## 2026-04-25

- [5126fb8](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/5126fb8) Add Bluetooth proxy controls and diagnostics
- [f58da77](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/f58da77) Add first-time setup instructions
- [0bdbf57](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/0bdbf57) Add compiled build artifacts and usage notes
- [06725ba](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/06725ba) Add ESPHome Smart 86 Box project
- [16e346a](https://github.com/salnajjar/Waveshare-ESP32-S3-Smart-86-Box-ESPHome-Home-Assistant/commit/16e346a) Initial commit
