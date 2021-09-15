//
//  File.swift
//
// Another change
//  Created by Dennis Hernandez on 8/27/21.
//

import Foundation
import SwiftyGPIO


///This mainly internal enum will allow us to keep track of what protocol to use for our device.
public enum SwiftyPiProtocol: String {
    case GPIO, PWM, MC3008, PCA9685, UART, I2C, SPI
}
public typealias SwiftyPiValueType = SwiftyPiProtocol

///Enum for adjusting device activation frequency.
///
///`High` is generally equal to ON. Use `low` and `medium` when the devices need to be cycled on or off.
public enum SwiftyPiMode: String {
    case off, low, medium, high
}

///Change rPi board type here.
///
///Currently supports all boards from SwiftyGPIO. Obvi, this is ignored in macOS.
public let board: SupportedBoard = . RaspberryPi3

public struct SwiftyPiPinState: SwiftyPiDeviceState, Codable {
    public var name: String = ""
    public var pin: Int = 4
    public var value: Int = 0
    public var previousValue: Int = 1
    public init() {
    }
}
///Holds current values of the device.
///
///While you can access the device's values directly, the state let's you store them for comparison. Every ``SwiftyPiDevice`` will have a `name` string identifier. It will be unique and will be the main way that the SP reconizes devices.
protocol SwiftyPiDeviceState {
    var name: String { get set }
}

///Main base clase for ``SwiftyPiDevice``.
///
///Do not use this class directly, use one of the subclasses in order to use a specific type of device (GPIO pin, ADC pin, LCD etc).
open class SwiftyPiDevice {
    
    ///
    var state:SwiftyPiPinState = SwiftyPiPinState()
    var delegate: SwiftyPiDeviceDelegate? = nil
    
    var gpio: GPIO? = nil
    var pwm: PWMOutput? = nil
    var i2c: I2CInterface? = nil
    
    ///Add a custom block here. This block will be called during each loop.
    open var handler: CompletionHandler? = nil
    
    ///Create a default state then define a device. For PWM/UART/I2C device represents the channel number.
    public init(state:SwiftyPiPinState, device:Int) {
        self.state = state
    }
    
    ///This is a stub for compatability.
    open func action() {
        if self.handler != nil {
            self.handler!()
        }
    }
    
}
protocol SwiftyPiDeviceDelegate {
    func didSet(value: Int)
    func valueChanged(value: Int)
}
