//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 10/3/21.
//

import Foundation

public class PinRuleState: RuleState {
    public var ruleOperator = Operators.equals
    public var value:Int = -1
}

public class PinRuleConditional: RuleConditional {
    public var object: SwiftyPiDevice? = nil
    public var state: PinRuleState? = nil
    
    public init(object: Pin, state:PinRuleState?) {
        self.object = object
        self.state = state
    }
    
    public func solve() -> Bool{
        if (object == nil) || (state == nil) || ((object is Pin) == false) {return false}
        
        switch state?.ruleOperator {
            ///`aPin == aState.Value`
        case .equals:
            return (object as! Pin) == state!
            ///`aPin > aState.Value`
        case .greater:
            return (object as! Pin) > state!
            ///`aPin >= aState.Value`
        case .greaterEquals:
            return (object as! Pin) >= state!
            ///`aPin < aState.Value`
        case .less:
            return (object as! Pin) < state!
            ///`aPin <= aState.Value`
        case .lessEquals:
            return (object as! Pin) <= state!
        default:
            break
        }
        
        return false
    }
    
}
