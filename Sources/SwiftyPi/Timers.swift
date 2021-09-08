//
//  File.swift
//
// A change
//  Created by Dennis Hernandez on 8/24/21.
//

import Foundation
import Dispatch

public typealias CompletionHandler = () -> Void
public typealias CounterTuple = (maxLoops:Int?,currentLoop:Int)

public class SwiftyPiTimer {
    private let timeInterval: TimeInterval
    var timer: DispatchSourceTimer?
    var counter: CounterTuple = (nil,0)
    
    public init(timeInterval: TimeInterval, loops: Int?) {
        if loops != nil {
            counter = (maxLoops:loops,currentLoop:0)
        }
        self.timeInterval = timeInterval
    }
    
    public var handler: CompletionHandler?

    
    public func interval() {
        let queue = DispatchQueue(label: "net.doHernandez.SwiftyPi.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer?.schedule(deadline: .now() + timeInterval, repeating: timeInterval, leeway: .seconds(0))
        timer?.setEventHandler { [weak self] in
            self?.action()
        }
        timer?.resume()
    }
    
    public func action() {
        counter.currentLoop += 1
        handler?()
        stop(force: false)
    }

    public func stop(force: Bool) {
        if force == true {counter.currentLoop = counter.maxLoops!}
        
        if (counter.maxLoops == nil) {
            counter.currentLoop = 0
            handler = nil
            
            timer?.cancel()
            timer = nil
            return
        }
        
        if (counter.maxLoops! < counter.currentLoop) {
            counter.currentLoop += 1
        } else if(counter.maxLoops! == counter.currentLoop ){
            timer?.cancel()
            counter.currentLoop = 0
        }
    }
    
    deinit {
        stop(force: true)
    }
}
