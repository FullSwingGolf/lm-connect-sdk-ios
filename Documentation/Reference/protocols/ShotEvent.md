**PROTOCOL**

# `ShotEvent`

```swift
public protocol ShotEvent
```

Data object sent in LMDeviceDelegate shotEvent callback

Contains all shot data received from LM during ball in flight.

SDK will provide a concrete type in callbacks.

## Properties
### `type`

```swift
var type: LMShotType
```

The shot type (LmShotType)[protocols/LmShotType.md]

### `shot`

```swift
var shot: LMShot?
```

The shot data (LmShot)[protocols/LmShot.md]
