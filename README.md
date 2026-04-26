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