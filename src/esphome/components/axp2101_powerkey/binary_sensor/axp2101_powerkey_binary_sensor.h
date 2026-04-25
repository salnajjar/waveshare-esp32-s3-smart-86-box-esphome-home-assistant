#pragma once

#include "esphome/components/binary_sensor/binary_sensor.h"
#include "esphome/components/i2c/i2c.h"
#include "esphome/core/component.h"

namespace esphome::axp2101_powerkey {

class AXP2101PowerKeyBinarySensor : public binary_sensor::BinarySensor,
                                    public PollingComponent,
                                    public i2c::I2CDevice {
 public:
  void setup() override;
  void update() override;
  void dump_config() override;

 protected:
  bool read_register_(uint8_t reg, uint8_t *value);
  bool write_register_(uint8_t reg, uint8_t value);
  bool press_active_{false};
};

}  // namespace esphome::axp2101_powerkey

