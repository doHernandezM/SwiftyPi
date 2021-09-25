//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 9/14/21.
//

import Foundation
import SwiftyGPIO

public struct PinState: DeviceState, Codable {
    public var name: String = ""
    public var pin: Int = 4
    public var value: Int = 0
    public var previousValue: Int = 1
    public init() {
    }
}

//MARK:Pin
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
        
        self.gpio = SwiftyGPIO.GPIOs(for:Pin.board)[GPIOName.name(pin:self.state.pin)!]!
        self.setup()
        
    }
    
    func setup() {
#if os(OSX) || os(iOS)
        print("Apple Platform, no GPIO: setup")
        return
#else
        self.gpio!.int = 0
        
        switch self.state.type {
        case SwiftyPiType.statusLED.rawValue:
            self.gpio!.direction = .OUT
        case SwiftyPiType.button.rawValue:
            self.gpio!.direction = .IN
            self.gpio!.pull = .down
        case SwiftyPiType.relay.rawValue:
            self.gpio!.direction = .OUT
        case SwiftyPiType.light.rawValue:
            self.gpio!.direction = .OUT
        case SwiftyPiType.pump.rawValue:
            self.gpio!.direction = .OUT
        default:
            break
        }
#endif
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
#if os(OSX) || os(iOS)
            print("Apple Platform, no GPIO: getValue")
            return 0
#else
            if (self.state.type == DeviceProtocol.Pin.rawValue) {
                self.state.value = self.gpio!.int
            }
            if self.state.value != self.state.previousValue {
                self.delegate?.valueChanged()
            }
            return self.state.value
#endif
        }
        set{
#if os(OSX) || os(iOS)
            print("Apple Platform, no GPIO: setValue")
            return
#else
            if (self.state.type == SwiftyPiType.relay.rawValue) {
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

///Returns the pin value as a bool, false for off, true for on.
extension GPIOName {
    static func name(pin:Int) -> GPIOName? {
        return GPIOName(rawValue: "P" + String(pin))
    }
}


