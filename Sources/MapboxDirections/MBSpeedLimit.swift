import Foundation

/**
 A localized limit for measuring speed limits.
 */
@objc(MBSpeedLimit)
public class SpeedLimit: NSObject, NSSecureCoding {
    
    /**
     Represents an unknown speed limit for a segment.
     */
    @objc public static let invalid = SpeedLimit(value: -1, speedUnits: .kilometersPerHour)
    
    /**
     A unitless measure of speed which is dependent on the `MaximumSpeedLimit.speedUnits`.
     
     By default, the speed will be unknown and equal to `SpeedLimit.invalid` which is -1.
     
     If the speed is none, the value will be equal to `Double.greatestFiniteMagnitude`.
     */
    @objc public var value: Double = -1
    
    /**
     Units for `MaximumSpeedLimit.speed`.
     */
    @objc public var unit: SpeedUnit = .kilometersPerHour
    
    /**
     Initialize a new `SpeedLimit` object.
     */
    public init(value: Double, speedUnits: SpeedUnit) {
        self.value = value
        self.unit = speedUnits
    }

    /**
     Initialize a new `SpeedLimit` object from a JSON dictionary.
     */
    @objc public convenience init(json: [String: Any]) {
        var speed = json["speed"] as? Double ?? SpeedLimit.invalid.value
        if let speedUnknown = json["unknown"] as? Bool, speedUnknown {
            speed = SpeedLimit.invalid.value
        }
        if let speedNone = json["none"] as? Bool, speedNone {
            speed = .greatestFiniteMagnitude
        }
        
        let speedUnit: SpeedUnit
        if let speedUnitString = json["unit"] as? String {
            speedUnit = SpeedUnit(description: speedUnitString) ?? .kilometersPerHour
        } else {
            speedUnit = .kilometersPerHour
        }
        
        self.init(value: speed, speedUnits: speedUnit)
    }
    
    public static var supportsSecureCoding = true
    
    public required init?(coder decoder: NSCoder) {
        value = decoder.decodeDouble(forKey: "value")
        
        guard let speedUnitString = decoder.decodeObject(of: NSString.self, forKey: "unit") as String?, let speedUnit = SpeedUnit(description: speedUnitString) else {
                return nil
        }
        self.unit = speedUnit
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(value, forKey: "value")
        coder.encode(unit, forKey: "unit")
    }
}

/**
 Unit of measurement for `SpeedLimit`.
 */
@objc(MBSpeedUnits)
public enum SpeedUnit: Int, CustomStringConvertible {
    
    /**
     Indicates the road segment uses miles per hour for measuring speed limits.
     */
    case milesPerHour
    
    /**
     Indicates the road segment uses kilometers per hour for measuring speed limits.
     */
    case kilometersPerHour
    
    public init?(description: String) {
        let unit: SpeedUnit
        switch description {
        case "mph":
            unit = .milesPerHour
        case "km/h":
            unit = .kilometersPerHour
        default:
            unit = .kilometersPerHour
        }
        self.init(rawValue: unit.rawValue)
    }
    
    public var description: String {
        switch self {
        case .milesPerHour:
            return "mph"
        case .kilometersPerHour:
            return "km/h"
        }
    }
}