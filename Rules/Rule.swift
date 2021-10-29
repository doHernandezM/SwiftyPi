//
//  Rule.swift
//  PiMaker
//
//  Created by Dennis Hernandez on 10/18/21.
//

import Foundation

struct Rule: Identifiable, Codable {
    var id = UUID()
    var isChecked = false
    var title: String
    var pin: Pin
    var inputs: [Conditional] = []
    var outputs: [Conditional]
    
    init(pin:Pin) {
        title = "Untitled Rule"
        inputs = []
        outputs = []
        self.pin = pin
        
        inputs.append(Conditional(pin: pin))
    }
    
    
}

extension Rule: Equatable {
    static func ==(lhs: Rule, rhs: Rule) -> Bool {
        lhs.id == rhs.id
    }
    mutating func addInput(item: Conditional) {
        inputs.append(item)
    }
    mutating func addOutput(item: Conditional) {
        outputs.append(item)
    }
    
    //    mutating func addItem(title: String) {
    //        addItem(item: Conditional(pin: <#Pin#>))
    //    }
}
