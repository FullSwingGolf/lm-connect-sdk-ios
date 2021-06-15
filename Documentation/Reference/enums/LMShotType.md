**ENUM**

# `LMShotType`

```swift
public enum LMShotType: Int, Codable
```

The type of shot data.

Launch data is available after impact and flight data is available after the full flight of the ball has completed.

## Cases
### `launch`

```swift
case launch = 0
```

The shot type is launch when only launch values are available

### `flight`

```swift
case flight
```

The shot type is flight when both launch and flight values are available
