//
//  Models.swift
//  ARPinView
//
//  Created by Dennis Hernandez on 9/24/21.
//
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import SwiftUI

//MARK: Pin
///Pin model for the Pin view
///
/// - Note: This is different from SwiftPi.Pin.
public class PinButton: Hashable, Codable {
    public static func == (lhs: PinButton, rhs: PinButton) -> Bool {
        return lhs.state.text == rhs.state.text
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(state.text)
    }
    public var delegate:PinDelegate? = nil
    
    enum CodingKeys: String, CodingKey {
        case state
    }
    
    
    public var state: PinButtonState = PinButtonState(text: "8", enabled: true)
    
    public init() {}
    
    public init(text: String, position: Position, type: DeviceProtocol) {
        self.state.text = text
        self.state.color = pinColor(deviceProtocol: type)
        self.state.position = position
        self.state.type = type
    }
    
    public func isVertical() -> Bool {
        if (self.state.position == Position.top || self.state.position == Position.bottom){
            return true
        }
        return false
    }
    
    public func label() -> String {
        var label = ""
        
        if isVertical() {
            for (i,char) in self.state.text.enumerated() {
                label = label + [char]
                if i != (self.state.text.count - 1) {
                    label = label + "\r"
                }
            }
            
            return label
        }
        
        return self.state.text
    }
    
    func frame() -> (width:Double,height:Double) {
        if self.isVertical() {
            return (26.0,126.0)
        }
        return (126.0,26.0)
    }
    
    func squareHeight() -> Double {
        return 26.0
    }
    
    public static func setPinType(type:DeviceProtocol, pins:[PinButton]) -> [PinButton]{
        for (_,pin) in pins.enumerated() {
            pin.state.type = type
        }
        return pins
    }
    
}

public var rPi40Pins: [PinButton] = [
    PinButton(text: "3v3.01", position: Position.left, type: DeviceProtocol.v3),
    PinButton(text: "5v.01", position: Position.right, type: DeviceProtocol.v5),
    PinButton(text: "GPIO.02", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "5v.02", position: Position.right, type: DeviceProtocol.v5),
    PinButton(text: "GPIO.03", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.01", position: Position.right, type: DeviceProtocol.ground),
    PinButton(text: "GPIO.04", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.14", position: Position.right, type: DeviceProtocol.UART),
    PinButton(text: "Ground.02", position: Position.left, type: DeviceProtocol.ground),
    PinButton(text: "GPIO.15", position: Position.right, type: DeviceProtocol.UART),
    PinButton(text: "GPIO.17", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.18", position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.27", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.03", position: Position.right, type: DeviceProtocol.ground),
    PinButton(text: "GPIO.22", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.23", position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "3v3.02", position: Position.left, type: DeviceProtocol.v3),
    PinButton(text: "GPIO.24", position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.10", position: Position.left, type: DeviceProtocol.SPI),
    PinButton(text: "Ground.04", position: Position.right, type: DeviceProtocol.ground),
    PinButton(text: "GPIO.09", position: Position.left, type: DeviceProtocol.SPI),
    PinButton(text: "GPIO.25", position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.11", position: Position.left, type: DeviceProtocol.SPI),
    PinButton(text: "GPIO.08", position: Position.right, type: DeviceProtocol.SPI),
    PinButton(text: "Ground.05", position: Position.left, type: DeviceProtocol.ground),
    PinButton(text: "GPIO.07", position: Position.right, type: DeviceProtocol.SPI),
    PinButton(text: "I2C.27", position: Position.left, type: DeviceProtocol.I2C),
    PinButton(text: "I2C.28", position: Position.right, type: DeviceProtocol.I2C),
    PinButton(text: "GPIO.05", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.06", position: Position.right, type: DeviceProtocol.ground),
    PinButton(text: "GPIO.06", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.12", position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.13", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.07", position: Position.right, type: DeviceProtocol.ground),
    PinButton(text: "GPIO.19", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.16", position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.26", position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.20", position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.08", position: Position.left, type: DeviceProtocol.ground),
    PinButton(text: "GPIO.21", position: Position.right, type: DeviceProtocol.GPIO),
]

public var analogPins: [PinButton] = [
    PinButton(text: "vDD", position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A0", position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "vREF", position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A1", position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "aGND", position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A2", position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "SCLK", position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A3", position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "MISO", position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A4", position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "MOSI", position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A5", position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "CE", position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A6", position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "dGND", position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A7", position: Position.bottom, type: DeviceProtocol.MC3008),
]

public var pwmPins: [PinButton] = [
    PinButton(text: "PWM.00", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.01", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.02", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.03", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.04", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.05", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.06", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.07", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.08", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.09", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.10", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.11", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.12", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.13", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.14", position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.15", position: Position.right, type: DeviceProtocol.PWM),
]

#endif
