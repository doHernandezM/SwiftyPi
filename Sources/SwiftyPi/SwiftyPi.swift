//
//  File.swift
//
//
//  Created by Dennis Hernandez on 8/27/21.
//

import Foundation
import SwiftyGPIO

//MARK:SwiftyPi
enum SwiftyPiType: String {
    case statusLED, button, relay, light, pump
}

public enum SwiftyPiMode: String {
    case off, low, medium, high//high is equal to on
}

class SwiftyPiDevice {
    var pin: GPIO
    var lastPinValue: Int = 0
    var type: SwiftyPiType
    var timer: SwiftyPiTimer? = nil
    
    var handler: CompletionHandler? = nil
    
    init(thePin: GPIO, theType: SwiftyPiType) {
        self.pin = thePin
        self.type = theType
        
        self.setup()
    }
    
    init(thePin: String, theType: SwiftyPiType) {
        self.pin = SwiftyGPIO.GPIOs(for:.RaspberryPi3)[GPIOName(rawValue: thePin)!]!
        self.type = theType
        
        self.setup()
    }
    
    func setup() {
        #if os(OSX) || os(iOS)
        print("Apple Platform, no GPIO: setup")
        return
        #else
        
        pin.value = 0
        
        switch type {
        case .statusLED:
            pin.direction = .OUT
        case .button:
            pin.direction = .IN
            pin.pull = .down
            
            timer = SwiftyPiTimer(timeInterval: 1.0, loops: 5)
            timer?.handler = { [self] in
                if self.handler != nil {
                    self.handler!()
//                    print("Type:\(self.type), Pin:\(self.pin.name)")
                }
            }
        case .relay:
            pin.direction = .OUT
        case .light:
            pin.direction = .OUT
        case .pump:
            pin.direction = .OUT
        }
        #endif
        
    }
    
    public func action() {
        self.handler?()
    }
    
    private var value: Int {
        get {
            #if os(OSX) || os(iOS)
            print("Apple Platform, no GPIO: getValue")
            return 0
            #else
            
            if (type == .relay) {
                return self.pin.value
            } else {
                return (self.pin.value == 0) ? 1 : 0
            }
            
            
            return self.pin.value
            #endif
        }
        set(newValue){
            #if os(OSX) || os(iOS)
            print("Apple Platform, no GPIO: setValue")
            return
            #else
            
            lastPinValue = self.pin.value
            if (type == .relay) {
                self.pin.value = newValue
            } else {
                self.pin.value = (newValue == 0) ? 1 : 0
            }
            #endif
        }
    }
    
    
    
    var bool: Bool {
        get {
            return (self.value == 1) ? true : false
        }
        set(newValue){
            self.value = newValue ? 1 : 0
        }
    }
    
    var int: Int {
        get {
            return self.value
        }
        set(newValue){
            self.value = newValue
        }
    }
    
    var mode: SwiftyPiMode {
        get {
            return bool ? .high : .off
        }
        set(newValue){
            self.value = (newValue == .high) ? 1 : 0
        }
    }
}
