//
//  Models.swift
//  ARPinView
//
//  Created by Dennis Hernandez on 9/24/21.
//
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)

import SwiftUI


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
    
    public init(text: String, color: Color, position: Position, type: DeviceProtocol) {
        self.state.text = text
        self.state.color = color
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
    PinButton(text: "3v3.01", color: .orange, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "5v.01", color: .red, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.02", color: .pink, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "5v.02", color: .red, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.03", color: .pink, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.01", color: .gray, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.04", color: .green, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.14", color: .purple, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.02", color: .gray, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.15", color: .purple, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.17", color: .green, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.18", color: .green, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.27", color: .green, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.03", color: .gray, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.22", color: .green, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.23", color: .green, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "3v3.02", color: .orange, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.24", color: .green, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.10", color: .blue, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.04", color: .gray, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.09", color: .blue, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.25", color: .green, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.11", color: .blue, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.08", color: .blue, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.05", color: .gray, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.07", color: .blue, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "I2C.27", color: .yellow, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "I2C.28", color: .yellow, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.05", color: .green, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.06", color: .gray, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.06", color: .green, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.12", color: .green, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.13", color: .green, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.07", color: .gray, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.19", color: .green, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.16", color: .green, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.26", color: .green, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.20", color: .green, position: Position.right, type: DeviceProtocol.GPIO),
    PinButton(text: "Ground.08", color: .gray, position: Position.left, type: DeviceProtocol.GPIO),
    PinButton(text: "GPIO.21", color: .green, position: Position.right, type: DeviceProtocol.GPIO),
]

public var analogPins: [PinButton] = [
    PinButton(text: "vDD", color: .gray, position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A0", color: .gray, position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "vREF", color: .gray, position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A1", color: .gray, position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "aGND", color: .gray, position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A2", color: .gray, position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "SCLK", color: .gray, position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A3", color: .gray, position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "MISO", color: .gray, position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A4", color: .gray, position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "MOSI", color: .gray, position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A5", color: .gray, position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "CE", color: .gray, position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A6", color: .gray, position: Position.bottom, type: DeviceProtocol.MC3008),
    PinButton(text: "dGND", color: .gray, position: Position.top, type: DeviceProtocol.MC3008),
    PinButton(text: "A7", color: .gray, position: Position.bottom, type: DeviceProtocol.MC3008),
]

public var pwmPins: [PinButton] = [
    PinButton(text: "PWM.00", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.01", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.02", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.03", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.04", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.05", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.06", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.07", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.08", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.09", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.10", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.11", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.12", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.13", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.14", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
    PinButton(text: "PWM.15", color: .yellow, position: Position.right, type: DeviceProtocol.PWM),
]

#endif
