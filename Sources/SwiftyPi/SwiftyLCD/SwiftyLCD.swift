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
//import SwiftyGPIO



//Bit 0: LCD_CLEAR
// Command to clear the display and set DDRAM address to 0
private let LCD_CLEAR:Int = 0

//Bit 1: LCD_HOME
// Command to set DDRAM address to 0 and return cursor to home position (upper-left corner of display)
private let LCD_HOME:Int = 1

//Bit 2: LCD_ENTRY_MODE
// Flag for setting the cursor move direction and the display shift
// LCD_ENTRY_INC: When writing to the display, increment the DDRAM address and shift the display to the right
private let LCD_ENTRY_MODE:Int = 2
private let LCD_ENTRY_INC:Int = 1

//Bit 3: LCD_DISPLAYMODE
// Flag for turning the display, cursor, and cursor blink on and off
// LCD_DISPLAYMODE_ON: Turn the display on
// LCD_DISPLAYCONTROL_CURSOR: Turn the cursor on
// LCD_DISPLAYCONTROL_BLINK: Turn the cursor blink on
private let LCD_DISPLAYMODE:Int = 3
private let LCD_DISPLAYMODE_ON:Int = 2
private let LCD_DISPLAYCONTROL_CURSOR:Int = 1
private let LCD_DISPLAYCONTROL_BLINK:Int = 0

//Bit 4: LCD_CURSORDISPLAY
// Flag for shifting the cursor and display
// LCD_CURSORDISPLAY_MODE: Set the direction of the cursor move and display shift
// LCD_CURSORDISPLAY_RL: Shift the display right and move the cursor right
private let LCD_CURSORDISPLAY:Int = 4
private let LCD_CURSORDISPLAY_MODE:Int = 3
private let LCD_CURSORDISPLAY_RL:Int = 2

//LED is connected to the PCFblankety blank.
private let LCD_Blink:Int = 3

//Bit 7: LCD_DDRAM
// Flag for setting the DDRAM address (used when writing data to the display RAM)
private let LCD_DDRAM:Int = 7


let i2c = SwiftyGPIO.hardwareI2Cs(for: .RaspberryPi3)![1]

public class HD44780 {
    public let width,height: Int
    private let maxColumn, maxRow: Int
    
    // Declares data variable with default value of an instance of LCDData
    public var data = LCDData()
    private var loop:UInt32? = nil
    
    private let BLANK_STRING_ARRAY_BUFFER: [[String]]
    public var displayedStrings: [[String]] = [[]]
    
    //Poller tank devices for status
    private var updateThread: Thread? = nil
    
    public var debug = true
    
    public var movements: [moveDirection] = []
    
    // Initialize the HD44780 with the specified width and height. If no data struct is provided, create a default one.
    public init(width: Int = 20, height: Int = 4, data: LCDData = LCDData(), loop:UInt32? = nil) {
        // Set the width and height of the display
        self.width = width
        self.height = height
        
        // Set the maximum column and row values for the display
        self.maxColumn = width
        self.maxRow = height
        
        // Set the data struct for the display
        self.data = data
        
        //
        self.loop = loop
        
        
        // Create an empty 2D array of strings with the specified width and height
        BLANK_STRING_ARRAY_BUFFER = [[String]](repeating: [String](repeating: " ", count: width), count: height)
        displayedStrings = resetStringBuffer()
        
        startDisplay()
    }
    public func startDisplay() {
        // Set the register select and read/write values to 0 and wait 15ms
        self.data.rs = 0
        self.data.rw = 0
        usleep(15000)
        
        // Send a 0x3 command to the display
        write(output: 0x3)
        usleep(4100)
        
        write(output: 0x3)
        usleep(150)
        
        write(output: 0x3)
        usleep(40)
        
        //4-bit mode
        write(output: 0x2)
        usleep(40)
        
        //Function set 001, BW, NumLines, Font, -, -
        // BW 0=8bit, 1=4bit
        // NumLines 0=1 line, 1= more than 1
        // Font 0=5x10, 1=5x8
        write(output: 0x28 )
        
        // Enable the display and turn it on
        write(output: (1<<LCD_DISPLAYMODE)|(1<<LCD_DISPLAYMODE_ON) )
        
        // Clear the display and set the cursor to the home position
        clear()
        
        // Set the entry mode to increment and turn on the display
        write(output: (1<<LCD_ENTRY_MODE)|(1<<LCD_ENTRY_INC) )
        
        home()
        
        if loop != nil {
            self.updateThread = Thread(){
//                self.print(x: 0, y: 1, string: "(Hello World)", usCharSet: true)
                sleep(2)
                
                self.updateDisplay()
            }
            
            self.updateThread?.qualityOfService = .background
            self.updateThread?.start()
        }
    }
    
    public typealias CompletionHandler = () -> Void
    
    private func updateDisplay() {
        
        while true {
            
            for movement in movements {
                self.moveDisplayString(movement)
            }
            
            if debug {Swift.print("\n")}
            if debug {Swift.print(" -------------------- ")}
            for (i, displayedStringRow) in self.displayedStrings.enumerated() {
                var rowString = ""
                for string in displayedStringRow {
                    rowString += string
                }
                if debug {Swift.print("|\(rowString)|")}
                self.print(y: i, string: rowString)
                usleep(10)
            }
            if debug {Swift.print(" -------------------- ")}
            sleep(self.loop!)
            
        }
    }
    
    //resetStringBuffer() - resets the buffer of strings on the display to blank spaces.
    private func resetStringBuffer() -> [[String]] {
        return [[String]](repeating: [String](repeating: " ", count: width), count: height)
        //[
        //            ["1","2","3","4","5","6","7","8","9","0","1","2","3","4","5","6","7","8","9","0"],
        //                ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T"],
        //                ["0","9","8","7","6","5","4","3","2","1","0","9","8","7","6","5","4","3","2","1"],
        //                ["t","s","r","q","p","o","n","m","l","k","j","i","h","g","f","e","d","c","b","a"]
        //        ]
        
    }
    
    public enum moveDirection {
        case up, down, left, right
    }
    
    public func moveDisplayString(_ direction:moveDirection = .left, amount:Int = 1) {
        var rowBuffer: [String] = []
        var columnBuffer: String = ""
        
        switch direction {
        case .up:
            rowBuffer = displayedStrings.removeFirst()
            displayedStrings.append(rowBuffer)
        case .down:
            rowBuffer = displayedStrings.removeLast()
            displayedStrings = [rowBuffer] + displayedStrings
        case .left:
            for (i, _) in displayedStrings.enumerated() {
                columnBuffer = displayedStrings[i].removeFirst()
                displayedStrings[i].append(columnBuffer)
            }
        case .right:
            for (i, _) in displayedStrings.enumerated() {
                columnBuffer = displayedStrings[i].removeLast()
                displayedStrings[i] = [columnBuffer] + displayedStrings[i]
            }
        }
        
        
    }
    
    //backlight(_:) - sets the backlight of the HD44780 display on or off, depending on the value of the isOn parameter.
    public func backlight(_ isOn: Bool = true) {
        data.rs = 0
        data.rw = 0
        
        data.led = isOn ? 1 : 0
        write(output: data.led << LCD_Blink) // Led pin is independent from LCD data and control lines.
        
        usleep(1600)
    }
    
    //clear() - clears the display and sets all characters on the screen to blank spaces.
    public func clear() {
        data.rs = 0
        data.rw = 0
        
        write(output: 1 << LCD_CLEAR)
        usleep(1600)
        
        displayedStrings = resetStringBuffer()
    }
    
    //home() - moves the cursor to the home position (upper left corner of the screen).
    public func home() {
        data.rs = 0
        data.rw = 0
        
        write(output: 1 << LCD_HOME)
        usleep(1600)
    }
    
    //displayMode(displayOn:cursor:blink:) - sets the display mode of the HD44780 display, including whether the display is on or off, whether the cursor is visible, and whether the cursor is blinking.
    public func displayMode(displayOn: Bool = true, cursor: Bool = true, blink: Bool = true) {
        data.rs = 0
        data.rw = 0
        
        write(output: (1<<LCD_DISPLAYMODE)|((displayOn ? 1 : 0)<<LCD_DISPLAYMODE_ON)|((cursor ? 1 : 0)<<LCD_DISPLAYCONTROL_CURSOR)|((blink ? 1 : 0)<<LCD_DISPLAYCONTROL_BLINK) )
        
        usleep(1600)
    }
    
    //shift(cursor:left:) - shifts the display or cursor left or right.
    public func shift(cursor: Bool = true, left: Bool = true) {
        data.rs = 0
        data.rw = 0
        
        write(output: (1<<LCD_CURSORDISPLAY)|((cursor ? 0 : 1)<<LCD_CURSORDISPLAY_MODE)|((left ? 0 : 1)<<LCD_CURSORDISPLAY_RL) )
        
        usleep(1600)
    }
    
    //createChar(location:charmap:) - creates a custom character at the specified location using the provided character map.
    private func createChar(location: UInt8, charmap: [UInt8]) {
        var theLocation = location
        data.rs = 0
        data.rw = 0
        
        theLocation %= 8
        
        write(output: 0b01000000 | (location << 3))
        usleep(37)
        
        cursor(col: 0, row: 0) // Set the address pointer back to the DDRAM
    }
    
    //cursor(col:row:) - moves the cursor to the specified column and row on the display.
    public func cursor(col: UInt8, row: UInt8) {
        var pos = 0
        let offsets = [0x0, 0x40, 0x14, 0x54]
        
        if ( (col >= 0) && (col <= self.width) && (row >= 0) && (row <= self.height) ) {
            pos = Int(col) + offsets[Int(row)]
        }
        
        write(output:UInt8((1 << LCD_DDRAM)+pos))
        
    }
    
//write(output:) - writes the specified output to the display.
    private func write(output: UInt8) {
        data.data = output
        
        data.e = 1
        i2c.writeByte(0x27, value: data.highNibble())
        usleep(1)
        
        data.e = 0
        i2c.writeByte(0x27, value: data.highNibble())
        usleep(37)
        
        data.e = 1
        i2c.writeByte(0x27, value: data.lowNibbles())
        usleep(1)
        
        data.e = 0
        i2c.writeByte(0x27, value: data.lowNibbles())
        usleep(37)
    }
    
    //writeScaler(_:usCharSet:) - writes the specified Unicode scalar to the display, using the US character set if the usCharSet parameter is true.
    private func writeScaler(_ scalar: UnicodeScalar, usCharSet:Bool = true) {
        let charId:UInt32 = usCharSet ? 0 : 160
        let data = (scalar.value+charId)
        
        guard (data>31)&&(data<255) else {
            return
        }
        write(output: UInt8(data))
    }
    
    //printToPrint() - prints the current buffer of strings to the display.
    private func printToPrint(){
        for (_, row) in displayedStrings.enumerated() {
            var rowString = ""
            for (_, string) in row.enumerated() {
                rowString = rowString + string
            }
        }
    }
    
    //print(x:y:string:usCharSet:) - prints the specified string to the display at the specified column and row, using the US character set if the usCharSet parameter is true.
    public func print(x:Int = 0, y:Int = 0, string: String, usCharSet:Bool = true) {
        home()
        if x < 0 || y < 0 {return}
        
        var safedString = string
        
        if string.count + Int(x) > maxColumn {
            safedString = String(string.prefix((maxColumn - x)))
        }
        
        cursor(col: UInt8(x), row: UInt8(y))
        usleep(41)
        
        data.rs = 1
        data.rw = 0
        
        for (i, scalar) in safedString.unicodeScalars.enumerated() {
            //            Swift.print(scalar.value)
            displayedStrings[Int(y)][i + Int(x)] = String(scalar)
            
            writeScaler(scalar)
        }
        
        usleep(41)
        
        printToPrint()
        
        return
    }
    
    private func readd(output: UInt8) {
        data.data = output
        
        data.e = 1
        i2c.writeByte(0x27, value: data.highNibble())
        usleep(1)
        
        data.e = 0
        i2c.writeByte(0x27, value: data.highNibble())
        usleep(37)
        
        data.e = 1
        i2c.writeByte(0x27, value: data.lowNibbles())
        usleep(1)
        
        data.e = 0
        i2c.writeByte(0x27, value: data.lowNibbles())
        usleep(37)
    }
    
    
}
