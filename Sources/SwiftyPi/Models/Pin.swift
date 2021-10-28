//
//  Utilities.swift.swift
//  PiMaker
//
//  Created by Dennis Hernandez on 10/10/21.
//

import Foundation
import Combine

///This mainly internal enum will allow us to keep track of what protocol to use for our device.
public enum PinType: String, Codable {
    case GPIO, PWM, MCP3008, PCA9685, UART, I2C, SPI
    ///These are dead pins that don't do anything.
    case Ground
    case v5 = "5v"
    case v3 = "3v3"
    
    public static func isDeadProtocol(pinProtocols:PinType) -> Bool{
        switch pinProtocols {
        case .GPIO, .PWM, .MCP3008, .PCA9685, .UART, .I2C, .SPI:
            return false
        default:
            break
        }
        return true
    }
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
    @Published public var currentProtocol: PinType = .Ground
    ///All of a pins available modes.
    @Published public var pinProtocols: [PinType] = [.Ground]
    
    ///Some pins have multiple channels. 0 is default, otherwise 1.
    @Published public var channel = 0
    
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
    
    public required init(from decoder: Decoder) throws {
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
    
    
    
}

