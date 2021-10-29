//
//  Utilities.swift.swift
//  PiMaker
//
//  Created by Dennis Hernandez on 10/10/21.
//

import Foundation
import Combine
import SwiftyGPIO

///Returns the pin value as a bool, false for off, true for on.
extension GPIOName {
    static func name(pin:Int) -> GPIOName? {
        return GPIOName(rawValue: "P" + String(pin))
    }
}

///Change rPi board type here.
///
///Currently supports all boards from SwiftyGPIO. Obvi, this is ignored in macOS.
public let board: SupportedBoard = . RaspberryPi3


///This mainly internal enum will allow us to keep track of what protocol to use for our device.
public enum PinType: String, Codable {
    case GPIO, PWM, MCP3008, PCA9685, UART, I2C, SPI
    ///These are dead pins that don't do anything.
    case Ground
    case v5 = "5v"
    case v3 = "3v3"
    
    static func isDeadProtocol(pinProtocols:PinType) -> Bool{
        switch pinProtocols {
        case .GPIO, .PWM, .MCP3008, .PCA9685, .UART, .I2C, .SPI:
            return false
        default:
            break
        }
        return true
    }
}

public enum PinBarMode:Int, CaseIterable {
    case All, GPIO, PWM, PCA9685, MCP3008
}

public class Pin:Codable, Hashable, Identifiable, Equatable, ObservableObject {
    
    ///Get the pin name or number.
    ///
    ///Returns the pin number or the name of the pin if it is a named pin.. Use nameBacking for unformatted name.
    public var name: String {
        get {
            if let suffix = nameBacking.split(separator: ".", maxSplits: Int.max, omittingEmptySubsequences: true).last {
                return String(suffix)
            }
            return nameBacking
        }
        set(newValue) {
            nameBacking = newValue
        }
    }
    
    public var nameBacking: String = "unnamed"
    
    ///UUID
    ///
    ///Generally change this if you are making a copy of a pin.
    public var id: UUID = UUID()
    
    //MARK: Pin capabilities and types
    /// Returns the currently used protocol for this pin.
    ///
    /// This will determine what color to use for the pin button and which conditionals/values are valid. .Ground is default if not explicitly set while the last pin in `pinProtocol` is default.
    @Published public var currentProtocol: PinType = .Ground {
        didSet {
            self.setupType()
        }
    }
    ///All of a pins available modes.
    @Published public var pinProtocols: [PinType] = [.Ground] {
        didSet {
            if pinProtocols.count > 0 {
                currentProtocol = pinProtocols.last ?? .Ground
            } else {
                currentProtocol = .Ground
            }
        }
    }
    
    ///Some pins have multiple channels. 0 is default, otherwise 1.
    @Published public var channel = 0
    
    ///Set when the value of int changes. Very fleeting.
    public var toggled:Bool = false
    public var gpio: GPIO? = nil
    public var pwm: PWMOutput? = nil
    
    ///Add a custom block here. This block will be called during each loop.
    open var handler: CompletionHandler? = nil
    
    //MARK: Protocol Support
    public enum CodingKeys:String, CodingKey {
        case id
        
        case currentProtocol
        case pinProtocols
        case channel
        case name
    }
    
    public static func == (lhs: Pin, rhs: Pin) -> Bool {
        ((lhs.id == rhs.id) && (lhs.currentProtocol == rhs.currentProtocol))
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        
        hasher.combine(currentProtocol)
        hasher.combine(pinProtocols.count)
        hasher.combine(channel)
        hasher.combine(name)
    }
    
    ///Returns a copy of the pin with a new UUID.
    ///
    ///Avoid duplicating a pin without changing it id.
    public func copy() -> Pin {
        let newCopy: Pin = Pin()
        newCopy.id = UUID()
        
        newCopy.currentProtocol = self.currentProtocol
        newCopy.pinProtocols = self.pinProtocols
        newCopy.channel = self.channel
        newCopy.name = self.name
        return newCopy
    }
    
    //MARK: Inits
    public init() {
        self.currentProtocol = .Ground
        self.pinProtocols = [.Ground]
        
        self.name = "Unamed Pin"
        self.channel = 0
    
    }
    
    public init(name:String, pinProtocols:[PinType]) {
        self.currentProtocol = pinProtocols.last ?? .Ground
        self.pinProtocols = pinProtocols
        
        self.name = name
        self.channel = 0
    
    }
    
    public init(name:String, pinProtocols:[PinType], channel:Int) {
        self.currentProtocol = pinProtocols.last ?? .Ground
        self.pinProtocols = pinProtocols
        
        self.name = name
        self.channel = channel
        
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        
        do{
            pinProtocols = try container.decode([PinType].self, forKey: .pinProtocols)
            currentProtocol = try container.decode(PinType.self, forKey: .currentProtocol)
        }
        catch{
            print(error)
            pinProtocols = []
        }
        do{
            channel = try container.decode(Int.self, forKey: .channel)
        }
        catch{
            channel = 0
        }
        name = try container.decode(String.self, forKey: .name)
    
    }
    
    func setupType() {
        switch self.currentProtocol {
        case .GPIO:
            if let newGPIO = SwiftyGPIO.GPIOs(for:board)[GPIOName.name(pin:Int(self.name) ?? 01)!] {
                self.gpio = newGPIO
            }
        default:
            break
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        
        try container.encode(currentProtocol, forKey: .currentProtocol)
        try container.encode(pinProtocols, forKey: .pinProtocols)
        try container.encode(channel, forKey: .channel)
        try container.encode(name, forKey: .name)
    }
    
    public func isDeadPPin() -> Bool{
        switch self.pinProtocols.last {
        case .GPIO, .PWM, .MCP3008, .PCA9685, .UART, .SPI:
            return false
        default:
            break
        }
        return true
    }
    
    public func write() -> Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            return data
        }
        catch {
            print(error)
            print("PinW:Failed to decode JSON")
            return nil
        }
    }
    
    public static func read(data: Data) -> Pin? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(Pin.self, from: data)
            return decoded
        } catch {
            print(error)
            print("PinR:Failed to decode JSON")
            return nil
        }
    }
    
    
    
    public func nextProtocol() -> PinType {
        let nextIndex = (pinProtocols.firstIndex(of: currentProtocol) ?? 0) + 1
        
        if nextIndex == pinProtocols.endIndex {
            currentProtocol = pinProtocols[0]
            return currentProtocol
        } else {
            currentProtocol = pinProtocols[nextIndex]
        }
        return currentProtocol
        
    }
    
    public func previousProtocol() -> PinType {
        let nextIndex = (pinProtocols.firstIndex(of: currentProtocol) ?? 0) - 1
        
        if nextIndex == 0 {
            currentProtocol = pinProtocols[pinProtocols.endIndex]
            return currentProtocol
        } else {
            currentProtocol = pinProtocols[nextIndex]
        }
        return currentProtocol
    }
    
    //MARK: SwiftyGPIO
    ///Fires handler.
    ///
    ///This should be called when the timer loops or when you have a custom handler. Make sure to update the main value. Calling `super.action()` will call the handler block.
    open func action() {
        self.handler?()
        
    }
    
    ///Returns the pin value as a 0 for off or 1 for on. Make sure that you get the pin value from here, rather than overridding or accessing the pin in a different function.
    open var int: Int {
        get {
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
            print("Apple Platform, no GPIO: getValue")
            return 0
#else
            if (self.state.deviceProtocol == DeviceProtocol.GPIO) {
                self.state.value = self.gpio!.value
            }
            if self.state.value != self.state.previousValue {
                self.delegate?.valueChanged()
            }
            return self.state.value
#endif
        }
        set{
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
            print("Apple Platform, no GPIO: setValue")
            return
#else
            if (self.state.deviceProtocol == DeviceProtocol.GPIO) {
                self.gpio!.value = newValue
            } else {
                self.gpio!.value = (newValue == 0) ? 1 : 0
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
    
    //    ///Returns the pin value as a ``DeviceMode``.
    //    open var mode: DeviceMode {
    //        get {return bool ? .high : .off}
    //        set {self.int = (newValue == .high) ? 1 : 0}
    //    }
    
    
}

var defaultPinTypes: [Pin] = [
    Pin(name: "3v3", pinProtocols: [.v3]),
    Pin(name: "5v", pinProtocols: [.v5]),
    Pin(name: "Ground", pinProtocols: [.Ground]),
    Pin(name: "GPIO", pinProtocols: [.GPIO]),
    Pin(name: "PWM", pinProtocols: [.PWM]),
    Pin(name: "I2C", pinProtocols: [.I2C]),
    Pin(name: "SPI", pinProtocols: [.SPI]),
    Pin(name: "UART", pinProtocols: [.UART]),
    Pin(name: "MCP3008", pinProtocols: [.MCP3008]),
    Pin(name: "PCA9685", pinProtocols: [.PCA9685]),
]

var boardPinsLiveRPi40:[Pin] {
    get{
        var livePins: [Pin] = []
        
        for pin in boardPinsDefaultRPi40 {
            if !pin.isDeadPPin() {
                livePins.append(pin)
            }
        }
        return livePins
    }
}

func boardPins(pinProtocols:PinBarMode) -> [Pin] {
    var thePins: [Pin] = []
    
    for pin in boardPinsDefaultRPi40 {
        switch pinProtocols {
        case .All:
            pin.currentProtocol = pin.pinProtocols.last ?? .Ground
            if !pin.isDeadPPin() {
                thePins.append(pin)
            }
        case .GPIO:
            if pin.pinProtocols.contains(.GPIO) {
                pin.currentProtocol = .GPIO
                thePins.append(pin)
            }
        case .PWM:
            if pin.pinProtocols.contains(.PWM) {
                pin.currentProtocol = .PWM
                thePins.append(pin)
            }
        case .PCA9685:
            if pin.pinProtocols.contains(.PCA9685) {
                pin.currentProtocol = .PCA9685
                thePins.append(pin)
            }
        case .MCP3008:
            if pin.pinProtocols.contains(.MCP3008) {
                pin.currentProtocol = .MCP3008
                thePins.append(pin)
            }
        }
    }
    return thePins
}

var boardPinsDefaultRPi40: [Pin] = [
    Pin(name: "3v3", pinProtocols: [.v3]),
    Pin(name: "5v.01", pinProtocols: [.v5]),
    Pin(name: "GPIO.02", pinProtocols: [.GPIO]),
    Pin(name: "5v.02", pinProtocols: [.v5]),
    Pin(name: "GPIO.03", pinProtocols: [.GPIO]),
    Pin(name: "Ground.01", pinProtocols: [.Ground]),
    Pin(name: "GPIO.04", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.14", pinProtocols: [.GPIO,.UART]),
    Pin(name: "Ground.02", pinProtocols: [.Ground]),
    Pin(name: "GPIO.15", pinProtocols: [.GPIO,.UART]),
    Pin(name: "GPIO.17", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.18", pinProtocols: [.GPIO,.PWM], channel: 0),
    Pin(name: "GPIO.27", pinProtocols: [.GPIO]),
    Pin(name: "Ground.03", pinProtocols: [.Ground]),
    Pin(name: "GPIO.22", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.23", pinProtocols: [.GPIO]),
    Pin(name: "3v3.02", pinProtocols: [.v3]),
    Pin(name: "GPIO.24", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.10", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "Ground.04", pinProtocols: [.Ground]),
    Pin(name: "GPIO.09", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "GPIO.25", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.11", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "GPIO.08", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "Ground.05", pinProtocols: [.Ground]),
    Pin(name: "GPIO.07", pinProtocols: [.GPIO,.SPI]),
    Pin(name: "I2C.27", pinProtocols: [.GPIO,.I2C]),
    Pin(name: "I2C.28", pinProtocols: [.GPIO,.I2C]),
    Pin(name: "GPIO.05", pinProtocols: [.GPIO]),
    Pin(name: "Ground.06", pinProtocols: [.Ground]),
    Pin(name: "GPIO.06", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.12", pinProtocols: [.GPIO,.PWM], channel: 0),
    Pin(name: "GPIO.13", pinProtocols: [.GPIO,.PWM], channel: 1),
    Pin(name: "Ground.07", pinProtocols: [.Ground]),
    Pin(name: "GPIO.19", pinProtocols: [.GPIO,.PWM], channel: 1),
    Pin(name: "GPIO.16", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.26", pinProtocols: [.GPIO]),
    Pin(name: "GPIO.20", pinProtocols: [.GPIO]),
    Pin(name: "Ground.08", pinProtocols: [.Ground]),
    Pin(name: "GPIO.21", pinProtocols: [.GPIO]),
]
