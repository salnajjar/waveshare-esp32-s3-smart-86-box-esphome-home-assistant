#pragma once

#include "esphome/components/i2c/i2c.h"
#include "esphome/core/component.h"

namespace esphome::waveshare_s3_86_lcd_preinit {

class WaveshareS386LcdPreinit : public Component, public i2c::I2CDevice {
 public:
  void setup() override;
  void dump_config() override;
  float get_setup_priority() const override;

 protected:
  bool read_u8_(uint8_t reg, uint8_t *value);
  bool write_u8_(uint8_t reg, uint8_t value);
};

}  // namespace esphome::waveshare_s3_86_lcd_preinit
