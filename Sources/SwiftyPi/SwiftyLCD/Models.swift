//
//  SwiftyLCD.swift
//
//  Copyright (c) 2021 Dennis Hernandez. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.



import Foundation

public struct LCDData {
    public var rs: UInt8 = 0
    public var rw: UInt8 = 0
    public var e: UInt8 = 1
    public var led: UInt8 = 0
    public var data: UInt8 = 0xff
    
    public init() {
    }
    
    public init(rs: UInt8, rw: UInt8, e: UInt8, led: UInt8, data: UInt8) {
        self.rs = rs
        self.rw = rw
        self.e = e
        self.led = led
        self.data = data
    }
    
    func lowNibbles() -> UInt8 {
        var nibble: UInt8 = rs
        nibble |= rw << 1
        nibble |= e << 2
        nibble |= led << 3
        nibble |= (data & 0x0F) << 4
        
        return nibble
    }
    
    func highNibble() -> UInt8 {
        var nibble: UInt8 = rs
        nibble |= rw << 1
        nibble |= e << 2
        nibble |= led << 3
        nibble |= (data & 0xF0)
        
        return nibble
    }
    
    static func assembleData(lowNibble: UInt8, highNibble: UInt8) -> UInt8 {
        return (highNibble & 0xF0) | ((lowNibble & 0x0F) << 4)
    }
}
