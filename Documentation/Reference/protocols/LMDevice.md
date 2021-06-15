**PROTOCOL**

# `LMDevice`

```swift
public protocol LMDevice
```

The interface to a Launch Monitor

## Properties
### `id`

```swift
var id: String
```

### `name`

```swift
var name: String
```

### `state`

```swift
var state: LMState
```

### `delegate`

```swift
weak var delegate: LMDeviceDelegate?
```

## Methods
### `connect(completion:)`

```swift
func connect(completion: @escaping(Bool, Error?) -> Void)
```

Connect to device

- Parameter completion: Callback delegate containing connection status and any error.

#### Parameters

| Name | Description |
| ---- | ----------- |
| completion | Callback delegate containing connection status and any error. |

### `disconnect(completion:)`

```swift
func disconnect(completion: @escaping(Bool, Error?) -> Void)
```

Disconnect from device

- Parameter completion: Callback delegate containing connection status and any error.

#### Parameters

| Name | Description |
| ---- | ----------- |
| completion | Callback delegate containing connection status and any error. |

### `arm(completion:)`

```swift
func arm(completion: @escaping(Bool, Error?) -> Void)
```

Arm connected device

- Parameter completion: Callback delegate containing arm status and any error.

#### Parameters

| Name | Description |
| ---- | ----------- |
| completion | Callback delegate containing arm status and any error. |

### `setConfiguration(id:value:completion:)`

```swift
func setConfiguration(id: LMConfigurationId, value: Data, completion: @escaping(Bool, Error?) -> Void)
```

Set Configuration

- Parameter id: LMConfigurationId determing what configuration to set
- Parameter value: Value to set configuration Id
- Parameter completion: Callback delegate containing update status and any error.

#### Parameters

| Name | Description |
| ---- | ----------- |
| id | LMConfigurationId determing what configuration to set |
| value | Value to set configuration Id |
| completion | Callback delegate containing update status and any error. |

### `getConfiguration(id:completion:)`

```swift
func getConfiguration(id: LMConfigurationId, completion: @escaping(Data, Error?) -> Void)
```

Get Configuration Value

- Parameter id: LMConfigurationId determing what configuration to retrieve
- Parameter completion: Callback delegate containing value and any error.

#### Parameters

| Name | Description |
| ---- | ----------- |
| id | LMConfigurationId determing what configuration to retrieve |
| completion | Callback delegate containing value and any error. |