**CLASS**

# `Authorization`

```swift
public class Authorization: NSObject
```

The SDK authorization. The caller can watch for authorizaton state changes by adding handlers
for property changed events

## Properties
### `authorized`

```swift
public var authorized: Bool
```

Tracks whether the SDK is currently authorized. This can change if a token expires or a bad
token or bad account id and key pair are given

### `claims`

```swift
public var claims: [String: NSObject]
```

The current claims the SDK is authorized for. Claims are key/value pairs such as:
```
"AllowDeviceAccess" : true
"AllowedCourses" : [ "WolfCreek" ]
"AllowedDevices" : [ "FSG112233445566", "FSG223344556677" ]
```
