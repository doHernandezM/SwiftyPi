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
public enum Operators: String, CaseIterable, Codable {
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
    
    func string() -> String {
        return self.rawValue
    }
    
    ///MultiplicationPrecedence
    ///Left associative
    case multOp = "*"
    case divOp = "/"
    case remainderOp = "%"
    
    ///AdditionPrecedence
    ///Left associative
    case addOp = "+"
    case subSignOp = "-" //Supports both subraction and number signing
    
    ///NilCoalescingPrecedence
    ///Right associative
    case nilCoalescingOp = "??"
    
    ///ComparisonPrecedence
    ///None
    case lessop = "<"
    case lessEqualop = "<="
    case greaterOp = ">"
    case greaterEqualOp = ">="
    case equalsOp = "=="
    case notOp = "!="
    
    ///LogicalConjunctionPrecedence
    ///Left associative
    case andOp = "&&"
    case orOp = "||"
    
    ///AssignmentPrecedence
    ///Right associative
    case assignOp = "="
    case multAssignOp = "*="
    case divAssignOp = "/="
    case remainderAssignOp = "%="
    case additionAssignOp = "+="
    case subAssignOp = "-="
    func isAssignOperator() -> Bool {
        switch self {
        case .assignOp, .multAssignOp, .divAssignOp, .remainderOp, .additionAssignOp, .subAssignOp:
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
