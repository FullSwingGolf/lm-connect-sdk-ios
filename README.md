# lm-connect-sdk-ios
iOS SDK for discovering and connecting to FullSwing Kit devices over BLE.  This repository contains demonstration projects for integrating the SDK.  Both a Swift and an Objective C iOS project are provided here.

## Installation / Project Setup
The Releases section of this repository contains XCFramework builds to be used in external projects.  Fetch a tagged xcframework binary from the releases section and add this to the Frameworks and Libraries of your XCode project.  For the demo projects, this is referenced under the lib/ folder.

The SDK requires the use of AWSMobileClient SDK.  This is available through the aws-sdk-ios project linked below.  For the demo projects we include this using cocoapods.

https://github.com/aws-amplify/aws-sdk-ios

See installation instructions for:

Cocoapods: https://github.com/aws-amplify/aws-sdk-ios#cocoapods

Carthage: https://github.com/aws-amplify/aws-sdk-ios#carthage

Framework: https://github.com/aws-amplify/aws-sdk-ios#frameworks

## Authentication
Once connected to an LM over BLE, you will need to provide authentication via an access token or app client credentials.  These can be obtained through Cognito either using the AWSMobileClient to obtain a token for an app login, or using a web interface to obtain a user token.  Both flows are shown in the demo code.

## Documentation
Please refer to the reference documentation for details on the SDK interfaces.  This documentation is auto generated from the Swift source of the internal SDK, but is exported to Objective C.  Some Objective C sample code is provided in the documentation, and of course the Objective C demo project provides usage for most of the SDK calls/callbacks.

https://github.com/FullSwingGolf/lm-connect-sdk-ios/tree/main/Documentation/Reference

### SDK API Flow

![](https://api.media.atlassian.com/file/cd63a690-f95c-481d-939b-6dcdb1a51e2b/binary?token=eyJhbGciOiJIUzI1NiJ9.eyJpc3MiOiIwMDE4NTMyNy1mMDg4LTRlZDQtYWUxMy02ODIwODc4NzJiNzUiLCJhY2Nlc3MiOnsidXJuOmZpbGVzdG9yZTpmaWxlOmNkNjNhNjkwLWY5NWMtNDgxZC05MzliLTZkY2RiMWE1MWUyYiI6WyJyZWFkIl19LCJleHAiOjE2MjU2ODkyODUsIm5iZiI6MTYyNTYwNjMwNX0.oBUUnXNrBb9JWwF1wyT2-ku66aypnNFjQn6OxqGmaS8&client=00185327-f088-4ed4-ae13-682087872b75&name=LMKit_iOS_SDK.png)

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

Currently the only configuration supported for writing to the LM Kit device is club type.  Below is an example of setting the club type to Driver.  
```objc
LMClubType clubType = LMClubTypeDriver;
unsigned char bytes[] = {clubType};
NSData *data = [NSData dataWithBytes:bytes length:1];
[_device setConfigurationWithId:LMConfigurationIdClub value:data completion:^(BOOL, NSError * _Nullable) {
    NSLog(@"Club Updated");
}];
```
