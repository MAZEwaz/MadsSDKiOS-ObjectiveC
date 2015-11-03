# MyLibrary

[![CI Status](http://img.shields.io/travis/LilushFess/MyLibrary.svg?style=flat)](https://travis-ci.org/MADSNL/MadsSDKiOS-ObjectiveC)
[![Version](https://img.shields.io/cocoapods/v/MyLibrary.svg?style=flat)](http://cocoapods.org/pods/MadsSDKiOS-ObjectiveC)
[![License](https://img.shields.io/cocoapods/l/MyLibrary.svg?style=flat)](http://cocoapods.org/pods/MadsSDKiOS-ObjectiveC)
[![Platform](https://img.shields.io/cocoapods/p/MyLibrary.svg?style=flat)](http://cocoapods.org/pods/MadsSDKiOS-ObjectiveC)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MADSSDKiOS-ObjectiveC is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MADSSDKiOS-ObjectiveC"
```

## IMPORTANT: Application Transport Security in iOS 9

Please note that the Application Transport Security has blocked a cleartext HTTP resource load since it is insecure. Adding the following to your Info.plist will disable ATS:

```ruby
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```

## Set up the MADS Ad Server

In order to create and display a banner you need to initiate the MADS AdServer once.

As a handy tip, whenever you are adding Mads SDK calls to a source file, import the MadsSDK main header file into that source code by adding the following line of code:

```ruby
#import <MadsSDK/MadsSDK.h>
```
Add to didFinishLaunchingWithOptions and applicationWillEnterForeGround method code:

```ruby
[MadsAdServer startWithLocationEnabled:YES withLocationPurpose:@”Your location purpose”];
```
or:
```ruby
[MadsAdServer startWithLocationEnabled:YES withLocationPurpose:@”Your location purpose” withLocationUpdateTimeInterval:YOUR_PREFERRED_TIME_INTERVAL];

```
And add to applicationWillTerminate andapplicationWillEnterBackground methods code:
```ruby
[MadsAdServer stop];
```

## Set up the AdView

Now the MADS SDK is integrated, let’s move to the process of setting up the AdView.

Create the MadsAdView:

```ruby
MadsAdView *adView = [[MadsAdView alloc] initWithFrame:adFrame
zone:placementId
delegate:self];
```

## Documentation

[MADS wiki](http://wiki.mads.com/developers/)


## Author

MADS, support@mads.com

## License

MADSSDKiOS-ObjectiveC is available under the MADS license. See the LICENSE file for more info.
