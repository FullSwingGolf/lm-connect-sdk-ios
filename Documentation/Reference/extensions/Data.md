**EXTENSION**

# `Data`
```swift
public extension Data
```

## Methods
### `index(of:fromOffset:)`

```swift
func index(of: UInt8, fromOffset offset: Int = 0) -> Index?
```

Converts the required number of bytes, starting from `offset`
to the value of return type.

- parameter offset: The offset from where the bytes are to be read.
- returns: The value of type of the return type.

#### Parameters

| Name | Description |
| ---- | ----------- |
| offset | The offset from where the bytes are to be read. |

### `hexEncodedString(options:)`

```swift
func hexEncodedString(options: HexEncodingOptions = []) -> String
```
