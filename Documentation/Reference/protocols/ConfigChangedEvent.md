**PROTOCOL**

# `ConfigChangedEvent`

```swift
public protocol ConfigChangedEvent
```

Data object sent in LMDeviceDelegate configurationChanged callback

Contains current Launch Monitor configuration data

SDK will provide a concrete type in callbacks.

## Properties
### `configId`

```swift
var configId: LMConfigurationId
```

The changed configuration

### `value`

```swift
var value: Data
```

The new value
