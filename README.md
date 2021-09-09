# SwiftyPi

This package is heavily based on and would not be possible without SwiftyGPIO. This is not meant to be a replacement, more like an extra layer to make using Swift with rPi devices such as buttons, relays, LEDs, UART and LCDs. Support is currently support limited as this is a hobby.

## Funtionality options:
I recommend visiting SwiftyGPIO and getting familiar with this API first. However, the goal to eventually be able to call many devices, so eventually SwiftyDevice is all you need to worry about. 

### GPIO
* Use this to create a GPIO pin using the SwiftyGPIO pin naming convention, i.e. "P4" for pin 4.
```swift
public init(gpioPinName: String, theType: SwiftyPiType) {
    self.gpio = SwiftyGPIO.GPIOs(for:board)[GPIOName(rawValue: gpioPinName)!]!
    
    self.type = theType
    self.deviceProtocol = .GPIO
    
    self.setupGPIO()
}
```

### Device actions
* Each device has an action that can be run at a certain time depending on type and protocol. This is a simple block that returns nothing, of the type:
```swift
public typealias CompletionHandler = () -> Void
```
* Each device has an action that can be run at a certain time depending on type and protocol. This is a simple block that returns nothing, of the type:
```swift
public typealias CompletionHandler = () -> Void
```
* To set this action assign a block to a devices. This block will be called during the device's "action" event.
```
public var handler: CompletionHandler? = nil
```
* To set a device's state, or pin value, use:
```
public var bool: Bool
public var int: Int
public var mode: SwiftyPiMode
```
