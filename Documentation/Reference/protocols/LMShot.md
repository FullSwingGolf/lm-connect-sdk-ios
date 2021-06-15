**PROTOCOL**

# `LMShot`

```swift
public protocol LMShot
```

A golf shot and all calculated values.

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

The device identifier the shot origintated from

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

### `ballSpeed`

```swift
var ballSpeed: NSNumber?
```

The ball speed in mph

### `clubPath`

```swift
var clubPath: NSNumber?
```

The club path in degrees

### `clubSpeed`

```swift
var clubSpeed: NSNumber?
```

The club speed in mph

### `faceAngle`

```swift
var faceAngle: NSNumber?
```

The face angle in degrees

### `horizLaunchAngle`

```swift
var horizLaunchAngle: NSNumber?
```

The horizontal launch angle in degrees (negative is left, positive is right)

### `smashFactor`

```swift
var smashFactor: NSNumber?
```

The smash factor

### `spinAxis`

```swift
var spinAxis: NSNumber?
```

The spin axis in degrees

### `spinRate`

```swift
var spinRate: NSNumber?
```

The spin rate in rpm

### `vertlaunchAngle`

```swift
var vertlaunchAngle: NSNumber?
```

The vertical launch angle in degrees

### `apex`

```swift
var apex: NSNumber?
```

The apex in yards

### `carryDistance`

```swift
var carryDistance: NSNumber?
```

The carry distance in yards

### `totalDistance`

```swift
var totalDistance: NSNumber?
```

The total distance in yards

### `side`

```swift
var side: NSNumber?
```

The side in yards (negative is left, positive is right)

### `sideTotal`

```swift
var sideTotal: NSNumber?
```

The side total in yards (negative is left, positive is right)
