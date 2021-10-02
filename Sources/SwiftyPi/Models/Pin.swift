//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 9/14/21.
//

import Foundation
import SwiftyGPIO
import Combine

//MARK: Pin
///This is our basic "pin" device.
///
///The best way to use this is to get the ``int``/``bool``/``mode``.
open class Pin:SwiftyPiDevice, ObservableObject {
    ///Change rPi board type here.
    ///
    ///Currently supports all boards from SwiftyGPIO. Obvi, this is ignored in macOS.
    public static var board: SupportedBoard = . RaspberryPi3
    
    @Published public var state:PinState = PinState()
    
    var gpio: GPIO? = nil
    var pwm: PWMOutput? = nil
    
    ///Add a custom block here. This block will be called during each loop.
    open var handler: CompletionHandler? = nil
    
    ///Create a default state then define a device. For PWM/UART/I2C device represents the channel number.
    required public init(state:PinState, channel:Int) {
        self.state = state
        
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
        case .Ground:
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
            if (self.state.deviceProtocol == DeviceProtocol.GPIO) {
                self.state.value = self.gpio!.value
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
            if (self.state.deviceProtocol == DeviceProtocol.GPIO) {
                self.gpio!.value = newValue
            } else {
                self.gpio!.value = (newValue == 0) ? 1 : 0
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

public class PinState: ObservableObject {
    @Published public var name: String = ""
    @Published public var customName: String = ""
    @Published public var pin: Int = 4
    @Published public var value: Int = 0
    @Published public var previousValue: Int = 1
    @Published public var deviceProtocol = DeviceProtocol.GPIO
    @Published public var type = DeviceType.DigitalPin
    
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
        case .UART, .I2C, .SPI, .Ground, .v5, .v3:
            break
        }
    }
}

