//
//  File.swift
//
// Another change
//  Created by Dennis Hernandez on 8/27/21.
//

import Foundation
import SwiftyGPIO



///Returns the pin value as a bool, false for off, true for on.
extension GPIOName {
    static func name(pin:Int) -> GPIOName? {
        return GPIOName(rawValue: "P" + String(pin))
    }
}


///This mainly internal enum will allow us to keep track of what protocol to use for our device.
public enum DeviceProtocol: String, Codable {
    case GPIO, PWM, MCP3008, PCA9685, UART, I2C, SPI
    ///These are dead pins that don't do anything.
    case Ground
    case v5 = "5v"
    case v3 = "3v3"
    
    static func isDeadProtocol(deviceProtocol:DeviceProtocol) -> Bool{
        switch deviceProtocol {
        case .GPIO, .PWM, .MCP3008, .PCA9685, .UART, .I2C, .SPI:
            return false
        default:
            break
        }
        return true
    }
    
}

public enum DeviceType: String, Codable {
    case DigitalPin,AnalogPin, PWMPin, Serial, LCD
}

///Enum for adjusting device activation frequency.
///
///`High` is generally equal to ON. Use `low` and `medium` when the devices need to be cycled on or off.
public enum DeviceMode: String, Codable {
    case off, low, medium, high
}

///Change rPi board type here.
///
///Currently supports all boards from SwiftyGPIO. Obvi, this is ignored in macOS.
public let board: SupportedBoard = . RaspberryPi3

///Main base clase for ``SwiftyPiDevice``.
///
///Do not use this class directly, use one of the subclasses in order to use a specific type of device (GPIO pin, ADC pin, LCD etc).
public protocol SwiftyPiDevice {
    ///Change rPi board type here.
    ///
    ///Currently supports all boards from SwiftyGPIO. Obvi, this is ignored in macOS.
    static var board: SupportedBoard { get set}

    ///All devices must have a state.
    var state:PinState { get set }
    
    ///Add a custom block here. This block will be called during each loop.
    var handler: CompletionHandler? { get set }
    
    ///Create a default state then define a device. For PWM/UART/I2C channel represents the channel number.
    init(state:PinState, channel:Int)
    
    ///This is a stub for compatability.
    func action()
    
}
