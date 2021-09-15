//
//  File.swift
//  
//
//  Created by Dennis Hernandez on 9/13/21.
//

import Foundation
import SwiftyGPIO

///Optional controller for SwiftyPi devices.
///
///You can access youur devices and their values directly or have the controller do it for you.
open class DeviceController {
    public typealias Devices = [String:SwiftyPiDevice]
    private var devices:Devices = [:]
    private var timer:Timer
    private var timeInterval:TimeInterval = 0.1
    private var loops:Int = 0

    ///Init the controller with the default time interval and loop
    public init(devices: [SwiftyPiDevice]) {
        timer = Timer(timeInterval: self.timeInterval, loops: self.loops)
        
        self.add(devices: devices)
        
        timer.handler = { [self] in
           action()
        }
    }
    
    ///Init the controller with custom time interval and loop
    public init(timeInterval: TimeInterval, loops: Int, devices: [SwiftyPiDevice]) {
        timer = Timer(timeInterval: self.timeInterval, loops: self.loops)
        
        self.add(devices: devices)
        
        timer.handler = { [self] in
            action()
        }
    }
    
    ///Set off action for all of the devices.
    func action() {
        self.devices.forEach { _,device in
            device.action()
        }
    }
    
    ///Add device to controller's device dictionary.
    open func add(devices:[SwiftyPiDevice]) {
        devices.forEach { device in
            self.devices[device.state.name] = device
        }
    }
    
}
