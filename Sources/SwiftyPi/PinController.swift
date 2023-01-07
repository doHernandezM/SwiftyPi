//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 10/1/21.
//

import Foundation

//MARK: Pins
public class PinController {
    
    ///Master pins
    ///
    ///These are all of the pi pins currently active.
    public static var piPins:[Int:Pin] = [:]
    ///These are all of the pi pins currently active.
    public static var analogPins:[Int:Pin] = [:]
    ///These are all of the pi pins currently active.
    public static var pca9685Pins:[Int:Pin] = [:]
    
    ///Returns the named pin, if possible.
    public static func pin(name: String) -> Pin? {
        for (_, pin) in piPins {
            if pin.name == name {
                return pin
            }
        }
        for (_, pin) in analogPins {
            if pin.name == name {
                return pin
            }
        }
        for (_, pin) in pca9685Pins {
            if pin.name == name {
                return pin
            }
        }
        return nil
    }
    
//    public static func pinsForProtocol(deviceProtocol: PinType) -> [Pin] {
//        var pinStates: [PinState] = []
//        var pins:[Pin] = []
//        
//        switch deviceProtocol {
//        case .GPIO:
//            pinStates = defaultRPi40States
//        case .MCP3008:
//            pinStates = defaultAnalogStates
//        case .PCA9685:
//            pinStates = defaultPCA9685State
//        default:
//            break
//        }
//        
//        for pinState in pinStates {
//            pins.append(Pin(state: pinState, channel: 0))
//        }
//        return pins
//        
//    }
//    
//    ///
//    public static func loadPins() {
//        
//        for (i,pinState) in defaultRPi40States.enumerated() {
//            piPins[i] = Pin(state: pinState, channel: 0)
//        }
//        for (i,pinState) in defaultAnalogStates.enumerated() {
//            analogPins[i] = Pin(state: pinState, channel: 0)
//        }
//        for (i,pinState) in defaultPCA9685State.enumerated() {
//            pca9685Pins[i] = Pin(state: pinState, channel: 0)
//        }
//    }
    
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
