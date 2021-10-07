//
//  Rules.swift
//  AR Maker
//
//  Created by Dennis Hernandez on 10/2/21.
//

import Foundation
//import Combine

open class RuleController {
    public static var rules:[Rule] = []
    
    public init() {
    }
}

open class Rule: Codable, ObservableObject, Hashable, Equatable {
    @Published public var id: UUID = UUID()
    @Published public var name: String = ""
    @Published public var inputCondition: [RuleConditional]? = nil
    @Published public var outputCondition: [RuleConditional]? = nil
    
    public static func == (lhs: Rule, rhs: Rule) -> Bool {
        if lhs.id == rhs.id { return true}
        return false
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    public init() {
        self.name = id.uuidString
    }
    
    public init(inputCondition: [RuleConditional]?, outputCondition: [RuleConditional]?) {
        self.inputCondition = inputCondition
        self.outputCondition = outputCondition
        self.name = id.uuidString
    }
    
    public func conditionals(returnInput: Bool) -> [PinRuleConditional]{
        if returnInput {
            if self.inputCondition == nil {return []}
            return self.inputCondition as! [PinRuleConditional]
        } else {
            if self.outputCondition == nil {return []}
            return self.outputCondition as! [PinRuleConditional]
        }
    }
    
    //MARK: Codable Support
    public enum CodingKeys:String, CodingKey {
        case id
        case name
        case inputCondition
        case outputCondition
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(UUID, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        inputCondition = try values.decode([PinRuleConditional].self, forKey: .inputCondition)
        outputCondition = try values.decode([PinRuleConditional].self, forKey: .outputCondition)
        }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(inputCondition, forKey: .inputCondition)
        try container.encode(outputCondition, forKey: .outputCondition)
    }
    
}

public protocol RuleConditional {
    var object: SwiftyPiDevice? {get set}
    var state: PinRuleState? { get set }
    func solve() -> Bool
}

public protocol RuleState {
    var ruleOperator: Operators  { get set }
}

