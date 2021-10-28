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
    ///These are all of the pi pins currently active.
    public static var piPins:[Int:PhysicalPin] = [:]
    ///These are all of the pi pins currently active.
    public static var analogPins:[Int:PhysicalPin] = [:]
    ///These are all of the pi pins currently active.
    public static var pca9685Pins:[Int:PhysicalPin] = [:]
    
    ///Returns the named pin, if possible.
    public static func pin(name: String) -> PhysicalPin? {
        for pin in piPins {
            if pin.value.state.name == name {
                return pin.value
            }
        }
        for pin in analogPins {
            if pin.value.state.name == name {
                return pin.value
            }
        }
        for pin in pca9685Pins {
            if pin.value.state.name == name {
                return pin.value
            }
        }
        return nil
    }
    
    public static func pinsForProtocol(deviceProtocol: DeviceProtocol) -> [PhysicalPin] {
        var pinStates: [PinState] = []
        var pins:[PhysicalPin] = []
        
        switch deviceProtocol {
        case .GPIO:
            pinStates = defaultRPi40States
        case .MCP3008:
            pinStates = defaultAnalogStates
        case .PCA9685:
            pinStates = defaultPCA9685State
        default:
            break
        }
        
        for pinState in pinStates {
            pins.append(PhysicalPin(state: pinState, channel: 0))
        }
        return pins
        
    }
    
    ///
    public static func loadPins() {
        
        for (i,pinState) in defaultRPi40States.enumerated() {
            piPins[i] = PhysicalPin(state: pinState, channel: 0)
        }
        for (i,pinState) in defaultAnalogStates.enumerated() {
            analogPins[i] = PhysicalPin(state: pinState, channel: 0)
        }
        for (i,pinState) in defaultPCA9685State.enumerated() {
            pca9685Pins[i] = PhysicalPin(state: pinState, channel: 0)
        }
    }
    
    //    {
    //
    //
    //        let pin:[String] = name.components(separatedBy: ".")
    //        print(pin)
    //        if let pinProtocol = DeviceProtocol(rawValue: pin[0]) {
    //            let pinState = PinState(name: name, deviceProtocol: pinProtocol )
    //
    //            let newPin = Pin(state: pinState, channel: 0)
    //
    //            return newPin
    //        }
    //    }
    
    
    
}
