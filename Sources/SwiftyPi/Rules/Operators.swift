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
