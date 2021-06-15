**PROTOCOL**

# `LMDeviceDelegate`

```swift
public protocol LMDeviceDelegate
```

Delegate protocol for connected LMDevice

Set your delegate object after connecting to the device to recieve state and shot events.

## Methods
### `shotEvent(_:)`

```swift
func shotEvent(_ event: ShotEvent)
```

Called when new shot data has been received from LM

### `stateChangedEvent(_:)`

```swift
func stateChangedEvent(_ event: StateChangedEvent)
```

Called when a state change occurs for the LM or our connection to it
