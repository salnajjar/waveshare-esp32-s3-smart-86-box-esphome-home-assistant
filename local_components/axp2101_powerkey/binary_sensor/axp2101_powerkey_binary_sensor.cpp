#include "axp2101_powerkey_binary_sensor.h"
#include "esphome/core/log.h"

namespace esphome::axp2101_powerkey {

static const char *const TAG = "axp2101_powerkey.binary_sensor";

static const uint8_t AXP2101_INTEN2 = 0x41;
static const uint8_t AXP2101_INTSTS2 = 0x49;
static const uint8_t AXP2101_PKEY_NEGATIVE_EDGE = 0x02;

void AXP2101PowerKeyBinarySensor::setup() {
  uint8_t int_enable = 0;
  if (!this->read_register_(AXP2101_INTEN2, &int_enable)) {
    this->mark_failed();
    return;
  }

  if (!this->write_register_(AXP2101_INTEN2, int_enable | AXP2101_PKEY_NEGATIVE_EDGE)) {
    this->mark_failed();
    return;
  }

  this->write_register_(AXP2101_INTSTS2, AXP2101_PKEY_NEGATIVE_EDGE);
  this->publish_state(false);
}

void AXP2101PowerKeyBinarySensor::update() {
  uint8_t status = 0;
  if (!this->read_register_(AXP2101_INTSTS2, &status))
    return;

  if ((status & AXP2101_PKEY_NEGATIVE_EDGE) == 0)
    return;

  this->write_register_(AXP2101_INTSTS2, AXP2101_PKEY_NEGATIVE_EDGE);
  if (!this->press_active_) {
    this->press_active_ = true;
    this->publish_state(true);
    this->set_timeout("release", 75, [this]() {
      this->press_active_ = false;
      this->publish_state(false);
    });
  }
}

void AXP2101PowerKeyBinarySensor::dump_config() {
  LOG_BINARY_SENSOR("", "AXP2101 Power Key", this);
  LOG_I2C_DEVICE(this);
  LOG_UPDATE_INTERVAL(this);
}

bool AXP2101PowerKeyBinarySensor::read_register_(uint8_t reg, uint8_t *value) {
  return this->read_byte(reg, value);
}

bool AXP2101PowerKeyBinarySensor::write_register_(uint8_t reg, uint8_t value) {
  return this->write_byte(reg, value);
}

}  // namespace esphome::axp2101_powerkey
