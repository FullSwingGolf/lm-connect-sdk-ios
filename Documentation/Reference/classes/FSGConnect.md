**CLASS**

# `FSGConnect`

```swift
public class FSGConnect: NSObject
```

This class provides a means to find Launch Monitors and connect to them to receive shot data

## Properties
### `shared`

```swift
static public var shared: FSGConnect = FSGConnect()
```

Shared instance

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

### `stopScan()`

```swift
public func stopScan()
```

Stop any running scans for devices.

### `findDevicesAsync(completion:)`

```swift
public func findDevicesAsync(completion: @escaping((_ devices: [LMDevice]?, _ error: Error?) -> Void)) throws -> Void
```

Find all devices that are accessible by the SDK.

```objc
    [_connect findDevicesAsyncAndReturnError:&error completion:^(NSArray<id<LMDevice>> * devices, NSError * error) {
        [self findDevicesComplete:devices error:error];
    }];
```

- note: This operation will run for 15 seconds.  Callback will be called each time a new device is found.

- Parameter completion: Callback delegate containing a list of all found devices or an error.
- Parameter devices: List of devices found
- Parameter error: Any error that occurred during scan

#### Parameters

| Name | Description |
| ---- | ----------- |
| completion | Callback delegate containing a list of all found devices or an error. |
| devices | List of devices found |
| error | Any error that occurred during scan |

### `findDevicesAsync(options:completion:)`

```swift
public func findDevicesAsync(options: [String:Any], completion: @escaping((_ devices: [LMDevice]?, _ error: Error?) -> Void)) throws -> Void
```

Find all devices that are accessible by the SDK.

```swift
    _connect.findDevicesAsync(options: ['scanDuration': 15.0], 
                              completion: self.findDevicesComplete(devices:error:))
```

- note: This operation will run for 15 seconds by default.  Callback will be called each time a new device is found.

- Parameter options: Dictionary containing optional options.  'scanDuration' take a Float of scan duration in seconds.
- Parameter completion: Callback delegate containing a list of all found devices or an error.
- Parameter devices: List of devices found
- Parameter error: Any error that occurred during scan

#### Parameters

| Name | Description |
| ---- | ----------- |
| options | Dictionary containing optional options.  ‘scanDuration’ take a Float of scan duration in seconds. |
| completion | Callback delegate containing a list of all found devices or an error. |
| devices | List of devices found |
| error | Any error that occurred during scan |

### `findDeviceAsync(identifier:completion:)`

```swift
public func findDeviceAsync(identifier: String, completion: @escaping((_ devices: [LMDevice]?, _ error: Error?) -> Void)) throws -> Void
```

Finds a device based on Launch Monitor ID.

- Parameter identifier: String LM identifier.
- Parameter completion: Callback delegate containing a list of all found devices or an error.
- Parameter devices: List of devices found
- Parameter error: Any error that occurred during scan

#### Parameters

| Name | Description |
| ---- | ----------- |
| identifier | String LM identifier. |
| completion | Callback delegate containing a list of all found devices or an error. |
| devices | List of devices found |
| error | Any error that occurred during scan |

### `findDeviceAsync(identifier:options:completion:)`

```swift
public func findDeviceAsync(identifier: String, options: [String:Any], completion: @escaping((_ devices: [LMDevice]?, _ error: Error?) -> Void)) throws -> Void
```

Finds a device based on Launch Monitor ID.

```swift
    _connect.findDeviceAsync(identifier: 'fsgabcdefghijkl', 
                             options: ['scanDuration': 15.0], 
                             completion: self.findDevicesComplete(devices:error:))
```

- note: This operation will run for 15 seconds by default.  Callback will be called each time a new device is found.

- Parameter identifier: String LM identifier.
- Parameter options: Dictionary containing optional options.  'scanDuration' take a Float of scan duration in seconds.
- Parameter completion: Callback delegate containing a list of all found devices or an error.
- Parameter devices: List of devices found
- Parameter error: Any error that occurred during scan

#### Parameters

| Name | Description |
| ---- | ----------- |
| identifier | String LM identifier. |
| options | Dictionary containing optional options.  ‘scanDuration’ take a Float of scan duration in seconds. |
| completion | Callback delegate containing a list of all found devices or an error. |
| devices | List of devices found |
| error | Any error that occurred during scan |