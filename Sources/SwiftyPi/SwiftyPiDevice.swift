//
//  File.swift
//
// Another change
//  Created by Dennis Hernandez on 8/27/21.
//

import Foundation
import SwiftyGPIO


///This mainly internal enum will allow us to keep track of what protocol to use for our device.
///Determine the type of ``Pin`` array to draw. GPIO = 40 Pin Pi, mcp3008 = MCP3008, pca9685 = PCA9685
public enum DeviceProtocol: Int, CaseIterable {
    case gpio, pwm, mcp3008, pca9685, uart, i2c, spi
}

public enum Device: String {
    case digital,analog, pwm
}

///Enum for adjusting device activation frequency.
///
///`High` is generally equal to ON. Use `low` and `medium` when the devices need to be cycled on or off.
public enum DeviceMode: String {
    case off, low, medium, high
}

///Change rPi board type here.
///
///Currently supports all boards from SwiftyGPIO. Obvi, this is ignored in macOS.
public let board: SupportedBoard = . RaspberryPi3

///Holds current values of the device.
///
///While you can access the device's values directly, the state let's you store them for comparison. Every ``SwiftyPiDevice`` will have a `name` string identifier. It will be unique and will be the main way that the SP reconizes devices.
protocol DeviceState {
    var name: String { get set }
}

///Returns the pin value as a bool, false for off, true for on.
extension GPIOName {
    static func name(pin:Int) -> GPIOName? {
        return GPIOName(rawValue: "P" + String(pin))
    }
}

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
