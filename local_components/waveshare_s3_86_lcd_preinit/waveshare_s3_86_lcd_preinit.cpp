#include "waveshare_s3_86_lcd_preinit.h"
#include "esphome/core/hal.h"
#include "esphome/core/log.h"

namespace esphome::waveshare_s3_86_lcd_preinit {

static const char *const TAG = "waveshare_s3_86_lcd_preinit";

static constexpr uint8_t PCA9554_OUTPUT_REG = 0x01;
static constexpr uint8_t PCA9554_CONFIG_REG = 0x03;
static constexpr uint8_t LCD_RESET_BIT = 1 << 5;
static constexpr uint8_t LCD_STRAP_BIT = 1 << 6;

void WaveshareS386LcdPreinit::setup() {
  uint8_t output = 0;
  uint8_t config = 0xFF;

  if (!this->read_u8_(PCA9554_OUTPUT_REG, &output) || !this->read_u8_(PCA9554_CONFIG_REG, &config)) {
    this->mark_failed();
    return;
  }

  // Match the Waveshare BSP: hold strap low, pulse the LCD reset line, then release the strap.
  config &= ~(LCD_RESET_BIT | LCD_STRAP_BIT);
  output &= ~LCD_STRAP_BIT;
  output |= LCD_RESET_BIT;
  if (!this->write_u8_(PCA9554_OUTPUT_REG, output) || !this->write_u8_(PCA9554_CONFIG_REG, config)) {
    this->mark_failed();
    return;
  }
  delay(200);

  output &= ~LCD_RESET_BIT;
  if (!this->write_u8_(PCA9554_OUTPUT_REG, output)) {
    this->mark_failed();
    return;
  }
  delay(200);

  output |= LCD_RESET_BIT;
  if (!this->write_u8_(PCA9554_OUTPUT_REG, output)) {
    this->mark_failed();
    return;
  }
  delay(200);

  config |= LCD_STRAP_BIT;
  if (!this->write_u8_(PCA9554_CONFIG_REG, config)) {
    this->mark_failed();
    return;
  }
}

void WaveshareS386LcdPreinit::dump_config() {
  ESP_LOGCONFIG(TAG, "Waveshare ESP32-S3 86 Box LCD pre-init");
  LOG_I2C_DEVICE(this);
  if (this->is_failed()) {
    ESP_LOGE(TAG, ESP_LOG_MSG_COMM_FAIL);
  }
}

float WaveshareS386LcdPreinit::get_setup_priority() const {
  return setup_priority::HARDWARE + 50.0f;
}

bool WaveshareS386LcdPreinit::read_u8_(uint8_t reg, uint8_t *value) {
  auto err = this->read_register(reg, value, 1);
  if (err != i2c::ERROR_OK) {
    ESP_LOGE(TAG, "read_register(0x%02X) failed: %d", reg, static_cast<int>(err));
    return false;
  }
  return true;
}

bool WaveshareS386LcdPreinit::write_u8_(uint8_t reg, uint8_t value) {
  auto err = this->write_register(reg, &value, 1);
  if (err != i2c::ERROR_OK) {
    ESP_LOGE(TAG, "write_register(0x%02X) failed: %d", reg, static_cast<int>(err));
    return false;
  }
  return true;
}

}  // namespace esphome::waveshare_s3_86_lcd_preinit
