//
//  File.swift
//
//
//  Created by Dennis Hernandez on 10/3/21.
//

import Foundation


///Used for pin state
///
///Stolen from https://github.com/doHernandezM/Schwifty.git
enum Operators: String, CaseIterable, Codable, Equatable, Identifiable {
    static func == (lhs: Operators, rhs: Operators) -> Bool {
        lhs.rawValue == rhs.rawValue
    }
    
    var id: UUID { get{return UUID()} }
    
    case letOp = "let"
    case varOp = "var"
    func isCreateVariable() -> Bool {
        switch self {
        case .letOp, .varOp:
            return true
        default:
            return false
        }
    }
    
    ///Returns the string value.
    ///
    ///You could also use .rawValue, but don't assume `Operators` will always be strings.
    func string() -> String {
        return self.rawValue
    }
    
    ///MultiplicationPrecedence
    ///Left associative
    case mult = "*"
    case div = "/"
    case remainder = "%"
    
    ///AdditionPrecedence
    ///Left associative
    case add = "+"
    case subSign = "-" //Supports both subraction and number signing
    
    ///NilCoalescingPrecedence
    ///Right associative
    case nilCoalescing = "??"
    
    ///ComparisonPrecedence
    ///None
    case less = "<"
    case lessEquals = "<="
    case greater = ">"
    case greaterEquals = ">="
    case equals = "=="
    case not = "!="
    func isComparisonOperator() -> Bool {
        if Operators.comparison.contains(self) {
            return true
        }
        return false
    }
    
    ///Retuns all comparision precedence operators
    static var comparison:[Operators] {
        get{
            return[.less, .lessEquals, .greater, .greaterEquals, .equals, .not]
        }
    }
    
    ///LogicalConjunctionPrecedence
    ///Left associative
    case and = "&&"
    case or = "||"
    
    ///AssignmentPrecedence
    ///Right associative
    case assign = "="
    case multAssign = "*="
    case divAssign = "/="
    case remainderAssign = "%="
    case additionAssign = "+="
    case subAssign = "-="
    func isAssignOperator() -> Bool {
        switch self {
        case .assign, .multAssign, .divAssign, .remainder, .additionAssign, .subAssign:
            return true
        default:
            return false
        }
    }
    
    case leftCrotchet = "["
    case rightCrotchet = "]"
    
    case leftBracket = "{"
    case rightBracket = "}"
    
    case leftParentheses = "("
    case rightParentheses = ")"
    
    case ifOp = "if"
    func isIfBlock() -> Bool {
        switch self {
        case .ifOp:
            return true
        default:
            return false
        }
    }
}
