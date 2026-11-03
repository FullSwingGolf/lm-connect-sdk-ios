**ENUM**

# `LMDistanceToScreen`

```swift
public enum LMDistanceToScreen: Int, Codable, StringCase
```

Distance from the hitting area to the screen. The Launch Monitor only
supports a fixed set of installed screen distances.

## Cases
### `eightFeet`

```swift
case eightFeet = 0
```

### `tenFeet`

```swift
case tenFeet
```

## Properties
### `description`

```swift
public var description: String
```

### `feet`

```swift
public var feet: Float
```

Distance value in feet sent to the Launch Monitor over BLE.
