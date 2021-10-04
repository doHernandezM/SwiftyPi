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

open class Rule: ObservableObject, Hashable, Equatable {
    @Published public var id: UUID = UUID()
    @Published public var inputCondition: [RuleConditional]? = nil
    @Published public var outputCondition: [RuleConditional]? = nil
    
    public static func == (lhs: Rule, rhs: Rule) -> Bool {
        if lhs.id == rhs.id { return true}
        return false
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
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

