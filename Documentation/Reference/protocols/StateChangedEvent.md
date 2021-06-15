**PROTOCOL**

# `StateChangedEvent`

```swift
public protocol StateChangedEvent
```

Data object sent in LMDeviceDelegate stateChangeEvent callback

Contains current Launch Monitor state

SDK will provide a concrete type in callbacks.

## Properties
### `state`

```swift
var state: LMState
```

The new device state
