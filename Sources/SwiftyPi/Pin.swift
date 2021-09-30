//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 9/14/21.
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

//MARK: Pin
///This is our basic "pin" device.
///
///The best way to use this is to get the ``int``/``bool``/``mode``.
open class Pin:SwiftyPiDevice {
    ///Change rPi board type here.
    ///
    ///Currently supports all boards from SwiftyGPIO. Obvi, this is ignored in macOS.
    public static var board: SupportedBoard = . RaspberryPi3
    
    public var state:PinState = PinState()
    
    var gpio: GPIO? = nil
    var pwm: PWMOutput? = nil
    
    ///Add a custom block here. This block will be called during each loop.
    open var handler: CompletionHandler? = nil
    
    ///Create a default state then define a device. For PWM/UART/I2C device represents the channel number.
    required public init(state:PinState, channel:Int) {
        self.state = state
        print("initDevice")
        
        switch state.deviceProtocol {
        case .GPIO:
            self.gpio = SwiftyGPIO.GPIOs(for:Pin.board)[GPIOName.name(pin:self.state.pin)!]!
        case .PWM:
            break
        case .MCP3008:
            break
        case .PCA9685:
            break
        case .UART:
            break
        case .I2C:
            break
        case .SPI:
            break
        case .ground:
            break
        case .v5:
            break
        case .v3:
            break
        }
    }
    
    
    ///Fires handler.
    ///
    ///This should be called when the timer loops or when you have a custom handler. Make sure to update the main value. Calling `super.action()` will call the handler block.
    open func action() {
        self.state.value = self.int
        
        self.handler?()
    }
    
    ///Returns the pin value as a 0 for off or 1 for on. Make sure that you get the pin value from here, rather than overridding or accessing the pin in a different function.
    open var int: Int {
        get {
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
            print("Apple Platform, no GPIO: getValue")
            return 0
#else
            if (self.state.deviceProtocol == DeviceProtocol.GPIO.rawValue) {
                self.state.value = self.gpio!.int
            }
            if self.state.value != self.state.previousValue {
                self.delegate?.valueChanged()
            }
            return self.state.value
#endif
        }
        set{
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
            print("Apple Platform, no GPIO: setValue")
            return
#else
            if (self.state.deviceProtocol == DeviceProtocol.GPIO.rawValue) {
                self.gpio!.int = newValue
            } else {
                self.gpio!.int = (newValue == 0) ? 1 : 0
            }
            self.delegate?.didSet(int: newValue)
#endif
        }
    }
    
    ///Returns the pin value as a bool, false for off, true for on.
    open var bool: Bool {
        get {return (self.int == 1) ? true : false}
        set {self.int = newValue ? 1 : 0}
    }
    
    ///Returns the pin value as a ``SwiftyPiMode``.
    open var mode: DeviceMode {
        get {return bool ? .high : .off}
        set {self.int = (newValue == .high) ? 1 : 0}
    }
    
    
}

public struct PinState: Codable {
    public var name: String = ""
    public var pin: Int = 4
    public var value: Int = 0
    public var previousValue: Int = 1
    public var deviceProtocol = DeviceProtocol.GPIO
    public var type = DeviceType.DigitalPin
    public init() {
    }
    
    public init(name: String, deviceProtocol:DeviceProtocol) {
        self.name = name
        self.deviceProtocol = deviceProtocol
        switch deviceProtocol {
        case .GPIO:
            self.type = .DigitalPin
        case .PWM:
            self.type = .PWMPin
        case .MCP3008:
            self.type = .AnalogPin
        case .PCA9685:
            self.type = .DigitalPin
        case .UART, .I2C, .SPI, .ground, .v5, .v3:
            break
        }
    }
}

#if os(iOS) || os(watchOS) || os(macOS)
public func pinColor(deviceProtocol:DeviceProtocol) -> Color {
    switch deviceProtocol {
    case .GPIO:
        return Color.green
    case .PWM:
        return Color.yellow
    case .MCP3008:
        return Color.gray
    case .PCA9685:
        return Color.yellow
    case .UART:
        return Color.purple
    case .I2C:
        return Color.red
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
