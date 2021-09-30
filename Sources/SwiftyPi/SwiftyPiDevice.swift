//
//  File.swift
//
// Another change
//  Created by Dennis Hernandez on 8/27/21.
//

import Foundation
import SwiftyGPIO

#if os(iOS)
import UIKit
import SwiftUI
#elseif os(watchOS)
import WatchKit
import SwiftUI
#elseif os(macOS)
import AppKit
import SwiftUI
#endif

///Returns the pin value as a bool, false for off, true for on.
extension GPIOName {
    static func name(pin:Int) -> GPIOName? {
        return GPIOName(rawValue: "P" + String(pin))
    }
}

public struct PinState: Codable {
    public var name: String = ""
    public var pin: Int = 4
    public var value: Int = 0
    public var previousValue: Int = 1
    public var type = DeviceProtocol.GPIO
    public init() {
    }
}

///This mainly internal enum will allow us to keep track of what protocol to use for our device.
public enum DeviceProtocol: String, Codable {
    case GPIO, PWM, MC3008, PCA9685, UART, I2C, SPI
    ///These are dead pins that don't do anything.
    case ground
    case v5 = "5v"
    case v3 = "3v3"
    
}

#if os(iOS) || os(watchOS) || os(macOS)
public func pinColor(deviceProtocol:DeviceProtocol) -> Color {
    switch deviceProtocol {
    case .GPIO:
        return Color.green
    case .PWM:
        return Color.blue
    case .MC3008:
        return Color.red
    case .PCA9685:
        return Color.yellow
    case .UART:
        return Color.purple
    case .I2C:
        return Color.yellow
    case .SPI:
        return Color.blue
    
    case .ground:
        return Color.gray
    case .v5:
        return Color.pink
    case .v3:
        return Color.orange
    }
    
//    return .accentColor
}
#endif

public enum Device: String, Codable {
    case DigitalPin,AnalogPin, PWMPin
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
