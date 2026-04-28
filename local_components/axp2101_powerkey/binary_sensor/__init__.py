import esphome.codegen as cg
from esphome.components import binary_sensor, i2c
import esphome.config_validation as cv

DEPENDENCIES = ["i2c"]

axp2101_powerkey_ns = cg.esphome_ns.namespace("axp2101_powerkey")
AXP2101PowerKeyBinarySensor = axp2101_powerkey_ns.class_(
    "AXP2101PowerKeyBinarySensor",
    binary_sensor.BinarySensor,
    cg.PollingComponent,
    i2c.I2CDevice,
)

CONFIG_SCHEMA = (
    binary_sensor.binary_sensor_schema(AXP2101PowerKeyBinarySensor)
    .extend(cv.polling_component_schema("100ms"))
    .extend(i2c.i2c_device_schema(0x34))
)


async def to_code(config):
    var = await binary_sensor.new_binary_sensor(config)
    await cg.register_component(var, config)
    await i2c.register_i2c_device(var, config)

