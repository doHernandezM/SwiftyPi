//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 9/30/21.
//


import Foundation

public var defaultRPi40States: [PinState] = [
    PinState(name: "3v3.01", deviceProtocol: DeviceProtocol.v3),
    PinState(name: "5v.01", deviceProtocol: DeviceProtocol.v5),
    PinState(name: "GPIO.02", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "5v.02", deviceProtocol: DeviceProtocol.v5),
    PinState(name: "GPIO.03", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "Ground.01", deviceProtocol: DeviceProtocol.Ground),
    PinState(name: "GPIO.04", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.14", deviceProtocol: DeviceProtocol.UART),
    PinState(name: "Ground.02", deviceProtocol: DeviceProtocol.Ground),
    PinState(name: "GPIO.15", deviceProtocol: DeviceProtocol.UART),
    PinState(name: "GPIO.17", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.18", deviceProtocol: DeviceProtocol.PWM),
    PinState(name: "GPIO.27", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "Ground.03", deviceProtocol: DeviceProtocol.Ground),
    PinState(name: "GPIO.22", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.23", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "3v3.02", deviceProtocol: DeviceProtocol.v3),
    PinState(name: "GPIO.24", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.10", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "Ground.04", deviceProtocol: DeviceProtocol.Ground),
    PinState(name: "GPIO.09", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "GPIO.25", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.11", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "GPIO.08", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "Ground.05", deviceProtocol: DeviceProtocol.Ground),
    PinState(name: "GPIO.07", deviceProtocol: DeviceProtocol.SPI),
    PinState(name: "I2C.27", deviceProtocol: DeviceProtocol.I2C),
    PinState(name: "I2C.28", deviceProtocol: DeviceProtocol.I2C),
    PinState(name: "GPIO.05", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "Ground.06", deviceProtocol: DeviceProtocol.Ground),
    PinState(name: "GPIO.06", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.12", deviceProtocol: DeviceProtocol.PWM),
    PinState(name: "GPIO.13", deviceProtocol: DeviceProtocol.PWM),
    PinState(name: "Ground.07", deviceProtocol: DeviceProtocol.Ground),
    PinState(name: "GPIO.19", deviceProtocol: DeviceProtocol.PWM),
    PinState(name: "GPIO.16", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.26", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "GPIO.20", deviceProtocol: DeviceProtocol.GPIO),
    PinState(name: "Ground.08", deviceProtocol: DeviceProtocol.Ground),
    PinState(name: "GPIO.21", deviceProtocol: DeviceProtocol.GPIO),
]

public var defaultAnalogStates: [PinState] = [
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

public var defaultPCA9685State: [PinState] = [
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

public var defaultPinTypes: [Pin] = [
    Pin(name: "3v3", pinProtocols: [.v3]),
    Pin(name: "5v", pinProtocols: [.v5]),
    Pin(name: "Ground", pinProtocols: [.Ground]),
    Pin(name: "GPIO", pinProtocols: [.GPIO]),
    Pin(name: "PWM", pinProtocols: [.PWM]),
    Pin(name: "I2C", pinProtocols: [.I2C]),
    Pin(name: "SPI", pinProtocols: [.SPI]),
    Pin(name: "UART", pinProtocols: [.UART]),
    Pin(name: "MCP3008", pinProtocols: [.MCP3008]),
    Pin(name: "PCA9685", pinProtocols: [.PCA9685]),
]

public var boardPinsLiveRPi40:[Pin] {
    get{
        var livePins: [Pin] = []
        
        for pin in boardPinsDefaultRPi40 {
            if !pin.isDeadPPin() {
                livePins.append(pin)
            }
        }
        return livePins
    }
}

public func boardPins(pinProtocols:PinBarMode) -> [Pin] {
    var thePins: [Pin] = []
    
    for pin in boardPinsDefaultRPi40 {
        switch pinProtocols {
        case .All:
            pin.currentProtocol = pin.pinProtocols.last ?? .Ground
            if !pin.isDeadPPin() {
                thePins.append(pin)
            }
        case .GPIO:
            if pin.pinProtocols.contains(.GPIO) {
                pin.currentProtocol = .GPIO
                thePins.append(pin)
            }
        case .PWM:
            if pin.pinProtocols.contains(.PWM) {
                pin.currentProtocol = .PWM
                thePins.append(pin)
            }
        case .PCA9685:
            if pin.pinProtocols.contains(.PCA9685) {
                pin.currentProtocol = .PCA9685
                thePins.append(pin)
            }
        case .MCP3008:
            if pin.pinProtocols.contains(.MCP3008) {
                pin.currentProtocol = .MCP3008
                thePins.append(pin)
            }
        }
    }
    return thePins
}

public var boardPinsDefaultRPi40: [Pin] = [
    Pin(name: "3v3", pinProtocols: [.v3]),
    Pin(name: "5v.01", pinProtocols: [.v5]),
    Pin(name: "GPIO.02", pinProtocols: [.GPIO]),
    Pin(name: "5v.02", pinProtocols: [.v5]),
    Pin(name: "GPIO.03", pinProtocols: [.GPIO]),
    Pin(name: "Ground.01", pinProtocols: [.Ground]),
    Pin(name: "GPIO.04", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.14", pinProtocols: [.GPIO,.UART]),
    Pin(name: "Ground.02", pinProtocols: [.Ground]),
    Pin(name: "GPIO.15", pinProtocols: [.GPIO,.UART]),
    Pin(name: "GPIO.17", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.18", pinProtocols: [.GPIO,.PWM], channel: 0),
    Pin(name: "GPIO.27", pinProtocols: [.GPIO]),
    Pin(name: "Ground.03", pinProtocols: [.Ground]),
    Pin(name: "GPIO.22", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.23", pinProtocols: [.GPIO]),
    Pin(name: "3v3.02", pinProtocols: [.v3]),
    Pin(name: "GPIO.24", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.10", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "Ground.04", pinProtocols: [.Ground]),
    Pin(name: "GPIO.09", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "GPIO.25", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.11", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "GPIO.08", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "Ground.05", pinProtocols: [.Ground]),
    Pin(name: "GPIO.07", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "I2C.27", pinProtocols: [.GPIO,.I2C]),
    Pin(name: "I2C.28", pinProtocols: [.GPIO,.I2C]),
    Pin(name: "GPIO.05", pinProtocols: [.GPIO]),
    Pin(name: "Ground.06", pinProtocols: [.Ground]),
    Pin(name: "GPIO.06", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.12", pinProtocols: [.GPIO,.PWM], channel: 0),
    Pin(name: "GPIO.13", pinProtocols: [.GPIO,.PWM], channel: 1),
    Pin(name: "Ground.07", pinProtocols: [.Ground]),
    Pin(name: "GPIO.19", pinProtocols: [.GPIO,.PWM], channel: 1),
    Pin(name: "GPIO.16", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.26", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.20", pinProtocols: [.GPIO]),
    Pin(name: "Ground.08", pinProtocols: [.Ground]),
    Pin(name: "GPIO.21", pinProtocols: [.GPIO]),
]
