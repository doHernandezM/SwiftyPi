//
//  File.swift
//
// Another change
//  Created by Dennis Hernandez on 8/27/21.
//

import Foundation
import SwiftyGPIO

//MARK:SwiftyPi
public enum SwiftyPiType: String {
    case statusLED, button, relay, light, pump, motor, stepper
}

public enum SwiftyPiProtocol: String {
    case GPIO, PWM, MC3008, PCA9685, UART, I2C, SPI
}

public enum SwiftyPiMode: String {
    case off, low, medium, high//high is equal to on
}

//Change board type here. Currently supports all board from SwiftyGPIO
fileprivate let board: SupportedBoard = . RaspberryPi3

public struct SwiftyPiDeviceState: Codable {
    var name: String = ""
    var pin: Int = 4
    var value: Int = 0
    var lastPinValue: Int = 0
    var type: SwiftyPiType.RawValue = SwiftyPiType.statusLED.rawValue
    var deviceProtocol: SwiftyPiProtocol.RawValue = SwiftyPiProtocol.GPIO.rawValue
    
    public init() {
        
    }
}

public class SwiftyPiDevice {
    var state = SwiftyPiDeviceState()
    
    var gpio: GPIO? = nil
    var pwm: PWMOutput? = nil
    var uart: UARTInterface? = nil
    var i2c: I2CInterface? = nil
    
    var lastPinValue: Int = 0
    
    public var timer: SwiftyPiTimer? = nil
    
    public var handler: CompletionHandler? = nil
    
    //Create a default state then define a device. For PWM/UART/I2C device represents the channel number.
    public init(state:SwiftyPiDeviceState, device:Int) {
        self.state = state
        
        switch self.state.deviceProtocol {
        case SwiftyPiProtocol.GPIO.rawValue:
            self.gpio = SwiftyGPIO.GPIOs(for:board)[GPIOName.name(pin:self.state.pin)!]!
            self.setupGPIO()
        case SwiftyPiProtocol.PWM.rawValue:
            let pwms = SwiftyGPIO.hardwarePWMs(for:board)!
            pwm = pwms[device]?[GPIOName.name(pin:self.state.pin)!]
        case SwiftyPiProtocol.UART.rawValue:
            let uarts = SwiftyGPIO.UARTs(for:board)!
            uart = uarts[device]
        case SwiftyPiProtocol.I2C.rawValue:
            let i2cs = SwiftyGPIO.hardwareI2Cs(for:board)!
            i2c = i2cs[device]
        default:
            break
        }
        
    }
    
    func setupGPIO() {
        #if os(OSX) || os(iOS)
        print("Apple Platform, no GPIO: setup")
        return
        #else
        
        gpio!.value = 0
        
        switch type {
        case .statusLED:
            gpio!.direction = .OUT
        case .button:
            gpio!.direction = .IN
            gpio!.pull = .down
            
            timer = SwiftyPiTimer(timeInterval: 1.0, loops: 5)
            timer?.handler = { [self] in
                if self.handler != nil {
                    self.handler!()
                }
            }
        case .relay:
            gpio!.direction = .OUT
        case .light:
            gpio!.direction = .OUT
        case .pump:
            gpio!.direction = .OUT
        default:
            break
        }
        
        
        #endif
        
    }
    
    public func action() {
        self.handler?()
        print("Device Handler called")
    }
    
    private var value: Int {
        get {
            #if os(OSX) || os(iOS)
            print("Apple Platform, no GPIO: getValue")
            return 0
            #else
            
            if (type == .relay) {
                return self.gpio!.value
            } else {
                return (self.gpio!.value == 0) ? 1 : 0
            }
            
            
            return self.gpio!.value
            #endif
        }
        set(newValue){
            #if os(OSX) || os(iOS)
            print("Apple Platform, no GPIO: setValue")
            return
            #else
            
            lastPinValue = self.gpio!.value
            if (type == .relay) {
                self.gpio!.value = newValue
            } else {
                self.gpio!.value = (newValue == 0) ? 1 : 0
            }
            //            self.delegate?.didSet(value: newValue)
            #endif
        }
    }
    
    
    
    public var bool: Bool {
        get {
            return (self.value == 1) ? true : false
        }
        set(newValue){
            self.value = newValue ? 1 : 0
        }
    }
    
    public var int: Int {
        get {
            return self.value
        }
        set(newValue){
            self.value = newValue
        }
    }
    
    public var mode: SwiftyPiMode {
        get {
            return bool ? .high : .off
        }
        set(newValue){
            self.value = (newValue == .high) ? 1 : 0
        }
    }
}

extension GPIOName {
    static func name(pin:Int) -> GPIOName? {
        return GPIOName(rawValue: "P" + String(pin))
    }
}

//protocol SwiftyPiDeviceDelegate {
//    func valueChanged()
//    func didSet(value: Int)
//    func actionHappened()
//}
