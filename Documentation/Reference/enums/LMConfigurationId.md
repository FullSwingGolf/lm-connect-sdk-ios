**ENUM**

# `LMConfigurationId`

```swift
public enum LMConfigurationId: Int, Codable
```

Configuration IDs

## Cases
### `autoArm`

```swift
case autoArm = 0
```

- Auto Arm is not currently implemented on the LM

### `club`

```swift
case club
```

- LMClubType - Club current in use by golfer

### `elevation`

```swift
case elevation
```

- Float - Elevation is in feet above sea level.  This is not currently implemented on the LM

### `distanceToPin`

```swift
case distanceToPin
```

- Float - Distance to pin is in yards

### `autoShortShotEnabled`

```swift
case autoShortShotEnabled
```

- Bool - Yards to the pin

### `shortShot`

```swift
case shortShot
```

- Bool - Whether or not short shot mode is currently active
