//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 10/1/21.
//

import Foundation
import SwiftyGPIO

//MARK: Pins
public class PinController {
    
///Master pins
///
///These are all of the pins currently active.
public var pins:[Int:Pin] = [:]
///Returns the named pin, if possible.
public func pin(name: String) -> Pin? {
    for pin in pins {
        if pin.value.state.name == name {
            print("returnPin:\(pin.value.state.name)")
            return pin.value
        }
    }
    
    let pin:[String] = name.components(separatedBy: ".")
    print(pin)
    if let pinProtocol = DeviceProtocol(rawValue: pin[0]) {
        
        let pinState = PinState(name: name, deviceProtocol: pinProtocol )
        
        let newPin = Pin(state: pinState, channel: 0)
//        pins.append(newPin)
//        print("returnPin:\(pin.value.state.name)")
        return newPin
    }
    return nil
}
    
}
