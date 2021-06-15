# lm-connect-sdk-ios
iOS SDK for discovering and connecting to FullSwing Kit devices over BLE.  This repository contains demonstration projects for integrating the SDK.  Both a Swift and an Objective C iOS project are provided here.

## Installation / Project Setup
The Releases section of this repository contains XCFramework builds to be used in external projects.  Fetch a tagged xcframework binary from the releases section and add this to the Frameworks and Libraries of your XCode project.  For the demo projects, this is referenced under the lib/ folder.

The SDK requires the use of AWSMobileClient SDK.  This is available through the aws-sdk-ios project linked below.  For the demo projects we include this using cocoapods.

https://github.com/aws-amplify/aws-sdk-ios

## Authentication
Once connected to an LM over BLE, you will need to provide authentication via an access token or app client credentials.  These can be obtained through Cognito either using the AWSMobileClient to obtain a token for an app login, or using a web interface to obtain a user token.  Both flows are shown in the demo code.

## Documentation
Please refer to the reference documentation for details on the SDK interfaces.  This documentation is auto generated from the Swift source of the internal SDK, but is exported to Objective C.  Some Objective C sample code is provided in the documentation, and of course the Objective C demo project provides usage for most of the SDK calls/callbacks.

https://github.com/FullSwingGolf/lm-connect-sdk-ios/tree/main/Documentation/Reference
