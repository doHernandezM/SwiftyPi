//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 9/30/21.
//


import Foundation

public var rPi40Pins: [PinState] = [
    PinState(name: "3v3.01", deviceProtocol: DeviceProtocol.v3),
    PinState(name: "5v.01", deviceProtocol: DeviceProtocol.v5),
    PinState(name: "GPIO.02", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "5v.02", deviceProtocol: DeviceProtocol.v5),
    PinState(name: "GPIO.03", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "Ground.01", deviceProtocol: DeviceProtocol.ground),
    PinState(name: "GPIO.04", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.14", deviceProtocol: DeviceProtocol.UART),
    PinState(name: "Ground.02", deviceProtocol: DeviceProtocol.ground),
    PinState(name: "GPIO.15", deviceProtocol: DeviceProtocol.UART),
    PinState(name: "GPIO.17", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.18", deviceProtocol: DeviceProtocol.PWM),
    PinState(name: "GPIO.27", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "Ground.03", deviceProtocol: DeviceProtocol.ground),
    PinState(name: "GPIO.22", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.23", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "3v3.02", deviceProtocol: DeviceProtocol.v3),
    PinState(name: "GPIO.24", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.10", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "Ground.04", deviceProtocol: DeviceProtocol.ground),
    PinState(name: "GPIO.09", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "GPIO.25", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.11", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "GPIO.08", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "Ground.05", deviceProtocol: DeviceProtocol.ground),
    PinState(name: "GPIO.07", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "I2C.27", deviceProtocol: DeviceProtocol.I2C),
    PinState(name: "I2C.28", deviceProtocol: DeviceProtocol.I2C),
    PinState(name: "GPIO.05", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "Ground.06", deviceProtocol: DeviceProtocol.ground),
    PinState(name: "GPIO.06", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.12", deviceProtocol: DeviceProtocol.PWM),
    PinState(name: "GPIO.13", deviceProtocol: DeviceProtocol.PWM),
    PinState(name: "Ground.07", deviceProtocol: DeviceProtocol.ground),
    PinState(name: "GPIO.19", deviceProtocol: DeviceProtocol.PWM),
    PinState(name: "GPIO.16", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.26", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.20", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "Ground.08", deviceProtocol: DeviceProtocol.ground),
    PinState(name: "GPIO.21", deviceProtocol: DeviceProtocol.GPIO),
]

public var analogPins: [PinState] = [
    PinState(name: "vDD", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "A0", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "vREF", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "A1", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "aGND", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "A2", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "SCLK", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "A3", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "MISO", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "A4", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "MOSI", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "A5", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "CE", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "A6", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "dGND", deviceProtocol: DeviceProtocol.MCP3008),
    PinState(name: "A7", deviceProtocol: DeviceProtocol.MCP3008),
]

public var pca9685pins: [PinState] = [
    PinState(name: "PWM.00", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.01", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.02", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.03", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.04", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.05", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.06", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.07", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.08", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.09", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.10", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.11", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.12", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.13", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.14", deviceProtocol: DeviceProtocol.PCA9685),
    PinState(name: "PWM.15", deviceProtocol: DeviceProtocol.PCA9685),
]

