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

### `dataDisplay`

```swift
case dataDisplay
```

- LMDataDisplay - The display method for data tiles on the LM.

### `screenLayout`

```swift
case screenLayout
```

- [LMDataPoint] - Data tiles shown and in what order on LM UI.

### `distanceUnits`

```swift
case distanceUnits
```

- LMDistanceUnits - Units used for distance on LM UI.

### `apexUnits`

```swift
case apexUnits
```

- LMApexUnits - Units used for Apex on LM UI.

### `speedUnits`

```swift
case speedUnits
```

- LMSpeedUnits - Units used for Speed on LM UI.

### `elevationUnits`

```swift
case elevationUnits
```

- LMApexUnit - Units used for Apex on LM UI.

### `temperatureUnits`

```swift
case temperatureUnits
```

- LMTemperatureUnits - Units used for Apex on LM UI.

### `location`

```swift
case location
```

- LMLocation - Type of location the session is held at.

### `elevation`

```swift
case elevation
```

- Float - Elevation is in feet above sea level.  Used for normalized data calculations.

### `temperature`

```swift
case temperature
```

- Float - Temperature used for normalized data calculations.

### `normalizedEnabled`

```swift
case normalizedEnabled
```

- Bool - Whether LM displays normalized data.

### `normalizedElevation`

```swift
case normalizedElevation
```

- Float - Normalized elevation.  Used for normalized data calculations.

### `normalizedTemperature`

```swift
case normalizedTemperature
```

- Float - Normalized temperature.  Used for normalized data calculations.

### `normalizedIndoorBallType`

```swift
case normalizedIndoorBallType
```

- LMBallType - Normalized indoor ball type elevation.  Used for normalized data calculations.

### `normalizedOutdoorBallType`

```swift
case normalizedOutdoorBallType
```

- LMBallType - Normalized indoor ball type elevation.  Used for normalized data calculations.

### `videoRecordingEnabled`

```swift
case videoRecordingEnabled
```

- Bool - Whether LM records shot video.

### `distanceToPin`

```swift
case distanceToPin
```

- Float - Distance to pin is in yards

### `autoShortShotEnabled`

```swift
case autoShortShotEnabled
```

- Bool - Automatically set short shot based on distance to pin

### `shortShot`

```swift
case shortShot
```

- Bool - Whether or not short shot mode is currently active

### `firmwareVersion`

```swift
case firmwareVersion
```

- String - System Firmware Version

### `radarVersion`

```swift
case radarVersion
```

- String - Radar Firmware Version
