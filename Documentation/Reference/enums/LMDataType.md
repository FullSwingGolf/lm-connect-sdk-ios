**ENUM**

# `LMDataType`

```swift
public enum LMDataType: Int, Codable, StringCase
```

The type of shot data.

Launch data is available after impact and flight data is available after the full flight of the ball has completed.

## Cases
### `carryDistance`

```swift
case carryDistance = 0
```

### `totalDistance`

```swift
case totalDistance
```

### `launchAngle`

```swift
case launchAngle
```

### `spinRate`

```swift
case spinRate
```

### `spinAxis`

```swift
case spinAxis
```

### `ballSpeed`

```swift
case ballSpeed
```

### `clubSpeed`

```swift
case clubSpeed
```

### `smashFactor`

```swift
case smashFactor
```

### `clubPath`

```swift
case clubPath
```

### `faceAngle`

```swift
case faceAngle
```

### `faceToPath`

```swift
case faceToPath
```

### `attackAngle`

```swift
case attackAngle
```

### `apex`

```swift
case apex
```

### `horizontalLaunchAngle`

```swift
case horizontalLaunchAngle
```

### `sideCarry`

```swift
case sideCarry
```

### `sideTotal`

```swift
case sideTotal
```

### `none`

```swift
case none
```

## Properties
### `description`

```swift
public var description: String
```
