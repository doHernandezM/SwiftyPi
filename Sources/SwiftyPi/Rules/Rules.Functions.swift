//
//  PinRulesState.swift
//  AR Maker
//
//  Created by Dennis Hernandez on 10/2/21.
//

import Foundation


public func == (lhs: Pin, rhs: PinRuleState) -> Bool {
    if lhs.int == rhs.value { return true}
    return false
}
public func < (lhs: Pin, rhs: PinRuleState) -> Bool {
    if lhs.int < rhs.value { return true}
    return false
}
public func <= (lhs: Pin, rhs: PinRuleState) -> Bool {
    if lhs.int <= rhs.value { return true}
    return false
}
public func > (lhs: Pin, rhs: PinRuleState) -> Bool {
    if lhs.int > rhs.value { return true}
    return false
}
public func >= (lhs: Pin, rhs: PinRuleState) -> Bool {
    if lhs.int >= rhs.value { return true}
    return false
}
