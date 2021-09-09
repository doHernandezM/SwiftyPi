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

public class SwiftyPiDevice {
    var gpio: GPIO? = nil
    var pwm: PWMOutput? = nil
    var uart: UARTInterface? = nil
    var i2c: I2CInterface? = nil
    var deviceProtocol: SwiftyPiProtocol = .GPIO
    
    var lastPinValue: Int = 0
    var type: SwiftyPiType
    public var timer: SwiftyPiTimer? = nil
    
    var delegate: SwiftyPiDeviceDelegate? = nil
    
    var handler: CompletionHandler? = nil //{print("No completion handler defined")}
    
    public init(i2cNumber: Int, theType: SwiftyPiType) {
        let i2cs = SwiftyGPIO.hardwareI2Cs(for:board)!
        i2c = i2cs[i2cNumber]
        
        self.type = theType
        self.deviceProtocol = .I2C
    }
    
    public init(uartNumber: Int, theType: SwiftyPiType) {
        let uarts = SwiftyGPIO.UARTs(for:board)!
        uart = uarts[uartNumber]
        
        self.type = theType
        self.deviceProtocol = .UART
    }
    
    public init(pwmChannel: Int, pwnPinName: String, theType: SwiftyPiType) {
        let pwms = SwiftyGPIO.hardwarePWMs(for:board)!
        pwm = pwms[pwmChannel]?[GPIOName(rawValue: pwnPinName)!]
        
        self.type = theType
        self.deviceProtocol = .PWM
        
    }
    
    public init(gpioPinName: String, theType: SwiftyPiType) {
        self.gpio = SwiftyGPIO.GPIOs(for:board)[GPIOName(rawValue: gpioPinName)!]!
        
        self.type = theType
        self.deviceProtocol = .GPIO
        
        self.setupGPIO()
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
                    print("Type:\(self.type), Pin:\(self.gpio?.name)")
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
        
//        gpio?.onChange{ [self]_ in
//            gpio!.clearListeners()
//
//            self.delegate?.valueChanged()
//        }
        #endif
        
    }
    
    public func action() {
        self.handler?()
        self.delegate?.actionHappened()
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
            self.delegate?.didSet(value: newValue)
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

protocol SwiftyPiDeviceDelegate {
    func valueChanged()
    func didSet(value: Int)
    func actionHappened()
}
