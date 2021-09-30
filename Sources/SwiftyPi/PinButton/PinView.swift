//
//  PinView.swift
//  ARPinView
//
//  Created by Dennis Hernandez on 9/24/21.
//

#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
import SwiftUI
import ManualStack

//public typealias Pins = [Pin]
//extension Pins {

///Use this to tell the ``PinView`` how to behave.
public struct PinViewState: Codable {
    public var type: DeviceProtocol = DeviceProtocol.PWM
    public var background:Color?
    public var horizontal:Bool = true
    
    public init(type: DeviceProtocol, background: Color, horizontal: Bool){
        self.type = type
        self.background = background
        self.horizontal = horizontal
    }
}

/////Determine the type of ``Pin`` array to draw. rPI = 40 Pin Pi, ic = MCP3008, pwm = PCA9685
//public enum PinType: Int, CaseIterable, Codable {
//    case rPi, ic, pwm
//}

public enum Position: Int, Codable {
    case left, center, right, top, bottom
}
///Provide the ``PinView``  with a ``PinViewState`` to get stated
public struct PinView: View {
    
    public var state: PinViewState
    public var backgroundColor: Color  {
        get {
            switch self.state.type {
            case .GPIO:
                return .clear
            case .MC3008:
                return .black.opacity(0.75)
            case .PWM:
                return .clear
            default:
                return .clear
            }
        }
    }
    
    ///Makes the ``Pin`` consistent with the ``PinView``.
    public var pins: [PinButton] {
        get {
            var internalPins: [PinButton] = []
            
            switch self.state.type {
            case .GPIO:
                internalPins = PinButton.setPinType(type: DeviceProtocol.GPIO, pins: rPi40Pins)
            case .MC3008:
                internalPins = PinButton.setPinType(type: DeviceProtocol.MC3008, pins: analogPins)
            case .PWM:
                internalPins = PinButton.setPinType(type: DeviceProtocol.PWM, pins: pwmPins)
            default:
                break
            }
            return internalPins
        }
    }
    
    public var body: some View {
        let isHorizontal = (self.state.type == DeviceProtocol.MC3008)
        ScrollView{
        ManualStack(isVertical: !isHorizontal) {
            ForEach(pins, id:\.self){ pin in
                let pinLocation = pins.firstIndex(of: pin) ?? 0
                
                if (pinLocation % 2 == 0 && self.state.type != DeviceProtocol.PWM) {
                    ManualStack(isVertical: isHorizontal) {PinButtonView(pin: pin)
                        if let individualPin = PinButtonView(pin: pins[pinLocation + 1]){individualPin}
                    }
                } else if (self.state.type == DeviceProtocol.PWM) {
                    PinButtonView(pin: pin)
                } else {
                    EmptyView()
                }
            }//.padding(Edge.Set.all, 9.0)
        }.background(state.background)
        }
    }
    
    public init() {
        self.state = PinViewState(type: DeviceProtocol.GPIO, background: .clear, horizontal: false)
    }

    public init(state: PinViewState, delegate:PinDelegate?) {
        self.state = state
        for pin in pins {
            pin.delegate = delegate
        }
    }
    
    public init(state: PinViewState) {
        self.state = state
    }
    
}

struct PinView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PinView(state: PinViewState(type: DeviceProtocol.PWM, background: Color.clear, horizontal: false), delegate: nil)
                .preferredColorScheme(.light)
            PinView(state: PinViewState(type: DeviceProtocol.MC3008, background: Color.clear, horizontal: false), delegate: nil)
                .preferredColorScheme(.dark)
        }
    }
}

public protocol PinDelegate {
    func pinAction(pin:PinButton)
}
#endif
