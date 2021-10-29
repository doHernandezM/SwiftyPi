//
//  Conditional.swift.swift
//  PiMaker
//
//  Created by Dennis Hernandez on 10/18/21.
//

import Foundation
//import SwiftUI

class Conditional: Identifiable, Codable {
    var id = UUID()
    var pin: Pin
    var operation = Operators.equals
    var value: String = "0"
    
    var isInput = true
    
    init(pin:Pin){
        self.pin = pin
    }
    
    static func nextOperator(anOperation: Operators) -> Operators {
        var nextIndex = Operators.comparison.firstIndex(of: anOperation)
        var `operator` = anOperation
//        print(nextIndex, Operators.comparison.endIndex, Operators.comparison.count)
        
        if nextIndex == Operators.comparison.endIndex - 1 {
            `operator` = Operators.comparison[0]
            return `operator`
        } else if nextIndex != nil {
            nextIndex! += 1
            `operator` = Operators.comparison[nextIndex!]
        }
        
        return `operator`
    }
    
    static func previousOperator(anOperation: Operators) -> Operators {
        var previousIndex = Operators.comparison.firstIndex(of: anOperation)
        var `operator` = anOperation
//        print(previousIndex, Operators.comparison.endIndex, Operators.comparison.count)
        
        if previousIndex == 0 {
            `operator` = Operators.comparison[Operators.comparison.endIndex - 1]
            return `operator`
        } else if previousIndex != nil {
            previousIndex! -= 1
            `operator` = Operators.comparison[previousIndex!]
        }
        
        return `operator`
    }
    
    //MARK: Logic
    static func flipValue(newValue:String) -> String{
            switch Int(newValue) {
                case 0:
                    return String(1)
                case 1:
                    return String(0)
                default:
                    return String(0)
                }
        }
}

infix operator === : ComparisonPrecedence
extension Conditional: Equatable {
    static func ==(lhs: Conditional, rhs: Conditional) -> Bool {
        (lhs.id == rhs.id) && (lhs.pin.id == rhs.pin.id)
    }
    
    static func ~= (lhs: Conditional, rhs: Conditional) -> Bool {
        (lhs.id == rhs.id) && (lhs.operation == rhs.operation) && (lhs.value == rhs.value)
    }
    
    static func === (lhs: Conditional, rhs: Conditional) -> Bool {
        (lhs.id == rhs.id) && (lhs.pin.id == rhs.pin.id) && (lhs.operation == rhs.operation) && (lhs.value == rhs.value)
    }
}
