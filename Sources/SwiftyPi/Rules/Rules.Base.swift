//
//  Rules.swift
//  AR Maker
//
//  Created by Dennis Hernandez on 10/2/21.
//

import Foundation
//import Combine

open class Rules {
    public static var rules:[Rule] = []
    
    public init() {
        
    }
}

open class Rule: ObservableObject {
    @Published public var inputCondition: [RuleConditional]? = nil
    @Published public var outputCondition: [RuleConditional]? = nil
}

public protocol RuleConditional {
    var object: SwiftyPiDevice? {get set}
    var state: PinRuleState? { get set }
    func solve() -> Bool
}

public protocol RuleState {
    var ruleOperator: Operators  { get set }
}

