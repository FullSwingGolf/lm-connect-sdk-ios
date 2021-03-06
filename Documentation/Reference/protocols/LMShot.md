**PROTOCOL**

# `LMShot`

```swift
public protocol LMShot
```

A golf shot and all calculated values.

SDK will provide a concrete type in callbacks.

## Properties
### `id`

```swift
var id: String
```

The unique shot identifier

### `deviceId`

```swift
var deviceId: String
```

The device identifier the shot originated from

### `timeStamp`

```swift
var timeStamp: Date?
```

The timestamp when the ball was hit

### `attackAngle`

```swift
var attackAngle: NSNumber?
```

The attack angle in degrees

Available at launch

### `ballSpeed`

```swift
var ballSpeed: NSNumber?
```

The ball speed in mph

Available at launch

### `clubPath`

```swift
var clubPath: NSNumber?
```

The club path in degrees

Available at launch

### `clubSpeed`

```swift
var clubSpeed: NSNumber?
```

 The club speed in mph

Available at launch

### `faceAngle`

```swift
var faceAngle: NSNumber?
```

The face angle in degrees

Available at launch

### `horizLaunchAngle`

```swift
var horizLaunchAngle: NSNumber?
```

The horizontal launch angle in degrees (negative is left, positive is right)

Available at launch

### `smashFactor`

```swift
var smashFactor: NSNumber?
```

The smash factor

Available at launch

### `spinAxis`

```swift
var spinAxis: NSNumber?
```

The spin axis in degrees

Available at launch

### `spinRate`

```swift
var spinRate: NSNumber?
```

The spin rate in rpm

Available at launch

### `vertlaunchAngle`

```swift
var vertlaunchAngle: NSNumber?
```

The vertical launch angle in degrees

Available at launch

### `apex`

```swift
var apex: NSNumber?
```

The apex in yards

Available after flight

### `carryDistance`

```swift
var carryDistance: NSNumber?
```

The carry distance in yards

Available after flight

### `totalDistance`

```swift
var totalDistance: NSNumber?
```

The total distance in yards

Available after flight

### `side`

```swift
var side: NSNumber?
```

The side in yards (negative is left, positive is right)

Available after flight

### `sideTotal`

```swift
var sideTotal: NSNumber?
```

The side total in yards (negative is left, positive is right)

Available after flight
