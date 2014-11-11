SAMIIO Objective-C/iOS SDK
==========================

This sample iOS app was created to demonstrate how to use the SAMI iOS SDK. The app was created to showcase how to manage SAMI's authentication (based on OAuth2), send and receive messages with SAMI's REST APIs.

Prerequisites
-------------

 * Xcode 6
 * Cocoapods http://guides.cocoapods.org/using/getting-started.html 

Setup and Installation
----------------------

1. Create an Application in devportal.samsungsami.io
2. Ensure that the Redirect URI is set to 'ios-app://redirect'
3. Copy the Application Client ID into SamiConstants.h, to replace <YOUR CLIENT APP ID>
     #define SAMI_CLIENT_ID @"<YOUR CLIENT APP ID>"
4. Build and Run the Application in XCode.


More about SAMI
---------------

If you are not familiar with SAMI we have extensive documentation at http://developer.samsungsami.io

The full SAMI API specification with examples can be found at http://developer.samsungsami.io/sami/api-spec.html

To create and manage your services and devices on SAMI visit developer portal at http://devportal.samsungsami.io

Licence and Copyright
---------------------

Licensed under the Apache License. See LICENCE.

Copyright (c) 2014 Samsung Electronics Co., Ltd.
