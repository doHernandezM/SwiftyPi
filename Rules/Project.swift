//
//  Rule.swift
//  PiMaker
//
//  Created by Dennis Hernandez on 10/18/21.
//

import Foundation
//import SwiftUI

struct Project: Identifiable, Codable {
    var id = UUID()
    var rules: [Rule]
    var name: String = "Untitled Project"
    var address: String = "0.0.0.0"

    var isShowingSettings = false
    var isShowingShare = false
    
    var pipassword: String = ""
    var usePCA9685: Bool = false
    var useMCP3008: Bool = false
    
    var useAPI: Bool = false
    var apiPassword: String = ""
    var apiPort: String = "83002"

    init(rules: [Rule]) {
        self.rules = rules
    }
    
}

//// Define some operations.
extension Project {
    mutating func addRule(rule: Rule) {
        rules.append(rule)
    }
}
