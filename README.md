# lm-connect-sdk-ios
iOS SDK for discovering and connecting to FullSwing Kit devices over BLE.  This repository contains demonstration projects for integrating the SDK.  Both a Swift and an Objective C iOS project are provided here.
In order to connect you must first request an AccountId and AccountKey from Full Swing Golf.

The following data is provided per shot:
* Club Speed - mph 
* Ball Speed - mph 
* Smash Factor 
* Attack Angle - degrees 
* Club Path - degrees 
* Vertical Launch Angle - degrees 
* Horizontal Launch Angle - degrees (negative is left, positive is right) 
* Face Angle - degrees 
* Spin Rate - rpm 
* Spin Axis - degrees 
* Carry Distance - yards 
* Total Distance - yards 
* Side - yards (negative is left, positive is right) 
* Side Total - yards (negative is left, positive is right) 
* Apex - yards 

NOTES: If a value is null it means it could not be calculated.


## Installation / Project Setup
The Releases section of this repository contains XCFramework builds to be used in external projects.  Fetch a tagged xcframework binary from the releases section and add this to the Frameworks and Libraries of your XCode project.  For the demo projects, this is referenced under the lib/ folder.

The SDK requires the use of AWSMobileClient SDK (v2.28.0).  This is available through the aws-sdk-ios project linked below.  For the demo projects we include this using cocoapods.  The XCF framwork version does not make the necssary code public and may not compile.

https://github.com/aws-amplify/aws-sdk-ios

See installation instructions for:

Cocoapods: https://github.com/aws-amplify/aws-sdk-ios#cocoapods

Carthage: https://github.com/aws-amplify/aws-sdk-ios#carthage

Framework: https://github.com/aws-amplify/aws-sdk-ios#frameworks

### Background Modes for Bluetooth
By default, iOS and Android may close a Bluetooth connection while the app is in the background.  To prevent this, we must configure the app build to have background capabilities.

To enable background Bluetooth on iOS, you must first add the Background Modes capability and enable using Bluetooth LE accessories within that capability.  This will configure your app to request permissions to use Bluetooth in the background at runtime.  After adding the capability, you will also need to add two usage descriptions for iOS to use when prompting the user to allow Bluetooth access.

To add Bluetooth background capability:
* Select the project in the left navigation pane
* Open the "Signing and Capabilities" tab
* Click the "+ Capability" to add "Background Modes" 
* Select "Uses Bluetooth LE Accessories".  
![](https://www.dropbox.com/s/v9v4oyknmz0zg79/screenshot_ble_background_mode_xcode_13.png?raw=1)

To add usage descriptions:
* Open the "Info" tab of your project.
* If not already present, hover over any entry in the property list to click a + button to add a new entry.
* Enter "NSBluetoothPeripheralUsageDescription" 
* Double click the value for your new property and enter a message to show to the user when the app first requests bluetooth.
* Repeat for adding a property for "NSBluetoothAlwaysUsageDescription"
![](https://www.dropbox.com/s/n44ztnlknd90eqk/screenshot_ble_usage_descriptions_xcode_13.png?raw=1)


### Gotchas

* If using cocoapods, be sure to set "Build Libraries for Distribution" to "Yes" for the AWSMobileClient target of the pods project.  Otherwise you may experience an EXC_BAD_ACCESS error when retrieving JWT tokens.

* Add the awsconfiguration.json file to your application project.  It should be included in the Copy Bundle Resources Build Phase of your application target as well.  Without this, the AWS SDK will not be able to connect to the correct AWS resources.  

## Authentication
Once connected to an LM over BLE, you will need to provide authentication via an access token or app client credentials.  These can be obtained through Cognito either using the AWSMobileClient to obtain a token for an app login, or using a web interface to obtain a user token.  Both flows are shown in the demo code.

## API Documentation
Please refer to the reference documentation for details on the SDK interfaces.  This documentation is auto generated from the Swift source of the internal SDK, but is exported to Objective C.  Some Objective C sample code is provided in the documentation, and of course the Objective C demo project provides usage for most of the SDK calls/callbacks.

https://github.com/FullSwingGolf/lm-connect-sdk-ios/tree/main/Documentation/Reference

### SDK API Flow

The general interaction flow is charted below.  This shows how a final application will interact with the SDK to communicate with a FullSwing Kit device.  Once connected, the application will recieve state transitions and shot data as it is available.  This state flow is detailed in the following table.

| State | Description |
| --- | --- |
| disconnected | Not connected to device |
| notReady | Device connected, no ball detected. |
| waitingForArm | Device connected, waiting for manual arm (not currently used) |
| readyBallFound | Device connected, ball detected.  Waiting for swing. | 
| tracking | Currently tracking ball in flight.  Will be sent twice, first for immediate launch data, then soon after with flight data computed by radar. Will be accompanied by a shot event.  The shot events will have the Shot Type set accordingly. | 

![](https://www.dropbox.com/s/zq8c92ftgb08s98/LMKit_iOS_SDK.png?raw=1)

### Quick Start
The core classes of the SDK are the FSGConnect and the LMDevice classes.  You will use a single instance of FSGConnect to initialize the SDK, and discover devices.  From there, you will use an instance of LMDevice to connect and send/recieve data from a Kit device.

To begin, you will need to declare your basic objects and initialize them.

```Objc
// Declaration of SDK objects (done in class implementation, or wherever)
FSGConnect* _connect;
id<LMDevice> _device;

// You can initialize your connect object to the shared instance.
_connect = FSGConnect.shared;
```

Now you can choose how to perform authentication with the SDK.  If you have a client id and key pair, you can use the following.
```Objc
// Use the following to authorize with an app key and start scanning for nearby devices
NSError __autoreleasing *error = nil;
[_connect initializeWithAcountId:@"ACCOUNT_ID_HERE" accountKey:@"ACCOUNT_KEY_HERE" error:&error];
```

Otherwise, you will need to fetch a valid JSON Web Token using a user's credentials.  In the demo projects, there is an example of using ASWebAuthenticationSession to provide a user with a web login and retrieving their token for use in the SDK.  
```Objc
// Initialize with user token and scan for devices
[_connect initializeWithAccessToken:@"JWT_TOKEN"];
```

Now you can perform discovery when appropriate in your application flow.  This will kick off a BLE scan on the phone, which will last for 15 seconds.  The callback will be called for each device found during that time.  Because of this, you may not want to perform operations on the devices within this callback as it may get hit multiple times.  It is safe to grab references from this callback.
```objc
[_connect findDevicesAsyncAndReturnError:&error completion:^(NSArray<id<LMDevice>> * devices, NSError * error) {
    // Perform operations on device list / store list
    // Demo projects store device list in shared data and popuplate a UITableView with device names
    
    // For demonstration, grab first item in list
    _device = [devices objectAtIndex:0];
}];
```

When connecting to a device, you should immediately set your delegate to receive state change and shot events as they come in.  You will also need to arm the device to prepare for collecting shot data.  See the LMDeviceDelegate example below for handling events.
```objc
[_device connectWithCompletion:^(BOOL connected, NSError * error) {
    NSLog(@"Connected: %@", self->_appData.device.name);
    // Set LMDevice delegate to self and begin arm process
    [_device setDelegate:self];
    [_device armWithCompletion:^(BOOL armed, NSError * error) {
    }];
}];
```

```objc
#pragma mark - LMDeviceDelegate

- (void)shotEvent:(id<ShotEvent>)event
{
    // A shot was received by the LM, the ShotEvent parameter will contain launch data or the full flight data in the LMShot member (event.shot)
    NSLog(@"shot");
    
    // Fetch shot data by checking if each property is null.
    // Invalid or data not yet available will be null.
    if (event.shot.carryDistance != nil) {
        NSLog(@"Carry: %@", event.shot.carryDistance);
    }else{
        NSLog(@"Carry: ---");
    }
}

- (void)stateChangedEvent:(id<StateChangedEvent>)event
{
    switch (event.state) {
        case LMStateDisconnected:
            // LM Disconnected
            break;
        case LMStateNotReady:
            // LM Not ready
            break;
        case LMStateWaitingForArm:
            // LM is in Idle state
            break;
        case LMStateReadyBallFound:
            // LM is Armed and ready to detect swings
            break;
        case LMStateTracking:
            // LM is tracking a ball.  ShotEvent will be emitted during this state for launch and flight data.
            break;
        default:
            break;
    }
}
```


Currently the only configuration values supported for writing to the LM Kit device are club type and Elevation.  
Below is an example of setting the club type to Driver.  
```objc
LMClubType clubType = LMClubTypeDriver;
unsigned char bytes[] = {clubType};
NSData *data = [NSData dataWithBytes:bytes length:1];
[_device setConfigurationWithId:LMConfigurationIdClub value:data completion:^(BOOL, NSError * _Nullable) {
    NSLog(@"Club Updated");
}];
```
  
Below is an example of setting the Elevation.  
```objc
Float elevation = 466.0;

NSMutableData * data = [NSMutableData dataWithCapacity:0];
[data appendBytes:&elevation length:sizeof(float)];

[_device setConfigurationWithId:LMConfigurationIdElevation value:data completion:^(BOOL, NSError * _Nullable) {
    NSLog(@"Elevation Updated");
}];
```
