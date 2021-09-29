
#if os(OSX) || os(iOS) || os(watchOS) || os(tvOS)
public enum ButtonPosition: Int {
    case left, center, right, top, bottom
}

public struct PinButtonState: Codable {
    var text = "8"
    var enabled:Bool = true
    var active:Bool = false
}


public struct PinState: DeviceState, Codable {
    public var name: String = ""
    public var pin: Int = 4
    public var value: Int = 0
    public var previousValue: Int = 1
    public init() {
    }
}
#endif
