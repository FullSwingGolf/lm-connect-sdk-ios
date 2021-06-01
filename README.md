# lm-connect-sdk-ios
iOS SDK for discovering and connecting to FullSwing Kit devices over BLE.  This repository contains demonstration projects for integrating the SDK.  Both a Swift and an Objective C iOS project are provided here.

## Installation
Fetch a tagged xcframework binary from the releases section and store in your project.  For the demo projects, this will be under the lib/ folder.

The SDK requires the use of AWSMobileClient SDK.  This is available through the aws-sdk-ios project linked below.  For the demo projects we include this using cocoapods.
https://github.com/aws-amplify/aws-sdk-ios

## Project Setup


## Token Authentication
Once connected to an LM over BLE, you will need to provide an access token.  These can be obtained through Cognito either using the AWSMobileClient to obtain a token for an app login, or using a web interface to obtain a user token.  Both flows are shown in the demo code.
