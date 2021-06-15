**CLASS**

# `FSGConnect`

```swift
public class FSGConnect: NSObject
```

This class provides a means find Launch Monitors and connect to them to receive
shot data

## Properties
### `authorization`

```swift
public var authorization: Authorization
```

The current SDK authorization. This will be available after initialize is called

## Methods
### `init()`

```swift
public override init()
```

### `deinit`

```swift
deinit
```

### `initialize(accessToken:)`

```swift
public func initialize(accessToken: String)
```

This function must be called prior to utilizing anything else in the SDK. This
implementation is called when a token has be acquired prior to initializing the SDK

- Parameter accesToken: The access token

#### Parameters

| Name | Description |
| ---- | ----------- |
| accesToken | The access token |

### `initialize(acountId:accountKey:)`

```swift
public func initialize(acountId: String, accountKey: String) throws -> Void
```

This function must be called prior to utilizing anything else in the SDK. This
implementation is called when an Account ID and Account Key are used to access
the SDK. These can be stored in the application or passed in by the user

- Parameter acountId: The callers account ID
- Parameter accountKey: The callers account key

#### Parameters

| Name | Description |
| ---- | ----------- |
| acountId | The callers account ID |
| accountKey | The callers account key |

### `shutdown()`

```swift
public func shutdown()
```

This function should be called when the SDK is not longer in use to clean up resources.

### `findDevicesAsync(completion:)`

```swift
public func findDevicesAsync(completion: @escaping(([LMDevice]?, Error?) -> Void)) throws -> Void
```

Find all devices that are accessible by the SDK.

- Parameter completion: Callback delegate containing a list of all found devices or an error.

#### Parameters

| Name | Description |
| ---- | ----------- |
| completion | Callback delegate containing a list of all found devices or an error. |

### `findDeviceAsync(identifier:completion:)`

```swift
public func findDeviceAsync(identifier: String, completion: @escaping(([LMDevice]?, Error?) -> Void)) throws -> Void
```

Finds a known device.

- Parameter identifier: String LM identifier.
- Parameter completion: Callback delegate containing a list of all found devices or an error.

#### Parameters

| Name | Description |
| ---- | ----------- |
| identifier | String LM identifier. |
| completion | Callback delegate containing a list of all found devices or an error. |