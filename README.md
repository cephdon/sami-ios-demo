SAMI Objective-C/iOS demo
========================

This sample iOS app was created to demonstrate how to use the SAMI iOS SDK. The app illustrates how to manage SAMI's authentication (based on OAuth2), send and receive messages with SAMI's REST APIs.

Prerequisites
-------------

 * Xcode 6
 * AFNetworking
 * CocoaPods http://guides.cocoapods.org/using/getting-started.html 

The SDK uses AFNetworking library. The demo app uses CocoaPods to manage the dependency of the SDK on this library.

Setup and Installation
----------------------

1. Create an Application in devportal.samsungsami.io:
  * The Redirect URI is set to 'ios-app://redirect'.
  * Choose "Client credentials, auth code, implicit" for OAuth 2.0 flow.
2. Install CocoaPods. See [this page](http://guides.cocoapods.org/using/getting-started.html) for instructions. From a terminal window, locate the SAMIClient directory, and run `pod install`. This installs all the prerequisites like AFNetworking and SocketRocket.
3. Import the SAMI SDK into the Xcode project. 
  * Download [SAMI iOS SDK](https://github.com/samsungsamiio/sami-ios)
  * Open Xcode project and drag the `client` folder of SAMI iOS SDK from the Finder window into `SAMIClient` group in Xcode.
4. Copy the Application Client ID into SamiConstants.h, to replace <YOUR CLIENT APP ID>
     #define SAMI_CLIENT_ID @"<YOUR CLIENT APP ID>"
5. Build and Run the Application in XCode.

The sample application was written for and tested in iOS 8. These instructions are for a Mac that is running Xcode v6.1 and above.

More about SAMI
---------------

If you are not familiar with SAMI we have extensive documentation at http://developer.samsungsami.io

The full SAMI API specification with examples can be found at http://developer.samsungsami.io/sami/api-spec.html

To create and manage your services and devices on SAMI visit developer portal at http://devportal.samsungsami.io

Licence and Copyright
---------------------

Licensed under the Apache License. See LICENCE.

Copyright (c) 2014 Samsung Electronics Co., Ltd.
