# SwiftyPi

## OUT OF DATE 9/15/21

This package is heavily based on and would not be possible without [SwiftyGPIO](https://github.com/uraimo/SwiftyGPIO). This is not meant to be a replacement, more like an extra layer to make using Swift with rPi devices such as buttons, relays, LEDs, UART and LCDs easier. Support is currently  limited as this is a hobby. Since SwiftyPi is made to work in conjunction with [ApusRupus](https://github.com/doHernandezM/ApusRubus) I have decided against implementing a delegate. You will have to actively poll each device in a loop for state. I may change this to implement the timer better.

## Funtionality options:
I recommend visiting SwiftyGPIO and getting familiar with this API first. However, the goal to eventually be able to call many devices, so eventually SwiftyDevice is all you need to worry about. 

Do this:
```swift
.package(url: "https://github.com/doHernandezM/SwiftyPi.git", ._exactItem("0.1.30")),
```

### GPIO
* Use this to create a GPIO pin using the SwiftyGPIO pin naming convention, i.e. "P4" for pin 4.
```swift
public init(gpioPinName: String, theType: SwiftyPiType)
```

### Device actions
* Each device has an action that can be run at a certain time depending on type and protocol. This is a simple block that returns nothing, of the type:
```swift
public typealias CompletionHandler = () -> Void
```
* To set this action assign a block( () -> Void )  to a device's handler. This block will be called during the device's "action" event.
```swift
public var handler: CompletionHandler? = nil
```
* To set or get a device's state, or pin value, use:
```swift
public var bool: Bool
public var int: Int
public var mode: SwiftyPiMode
```
