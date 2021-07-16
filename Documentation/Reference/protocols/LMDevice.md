**PROTOCOL**

# `LMDevice`

```swift
public protocol LMDevice
```

The interface to a Launch Monitor

SDK will provide a concrete type in callbacks.

## Properties
### `id`

```swift
var id: String
```

Unique ID for the Device.

Currently using the CBPeripheral UUID from iOS

### `name`

```swift
var name: String
```

Human friendly name for the Launch Monitor

Uses the BLE advertised name

### `batterylevel`

```swift
var batterylevel: UInt8
```

Current Battery Level  for the Launch Monitor

Range from 0-100

### `state`

```swift
var state: LMState
```

Current state of the LM

### `delegate`

```swift
weak var delegate: LMDeviceDelegate?
```

Delegate object for state and shot data events

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

```objc
    LMClubType clubType = LMClubTypeDriver;
    unsigned char bytes[] = {clubType};
    NSData *data = [NSData dataWithBytes:bytes length:1];
    [device setConfigurationWithId:LMConfigurationIdClub value:data completion:^(BOOL, NSError * _Nullable) {
        NSLog(@"Club Updated");
    }];
```

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