# MadsSDKiOS-ObjectiveC

[![Version](https://img.shields.io/cocoapods/v/MadsSDKiOS-ObjectiveC.svg?style=flat)](http://cocoapods.org/pods/MadsSDKiOS-ObjectiveC)
[![License](https://img.shields.io/cocoapods/l/MadsSDKiOS-ObjectiveC.svg?style=flat)](http://cocoapods.org/pods/MadsSDKiOS-ObjectiveC)
[![Platform](https://img.shields.io/cocoapods/p/MadsSDKiOS-ObjectiveC.svg?style=flat)](http://cocoapods.org/pods/MadsSDKiOS-ObjectiveC)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MADSSDKiOS-ObjectiveC is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'MadsSDKiOS-ObjectiveC'
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


ChangeLog
========================

##v.4.5.7 November 13 2015
- Fixed when mraid.getCurrentPosition() method returns incorrect value

##v.4.5.6 October 16 2015
- Added opening url in internal browser from JS code
- Added opportunity for loading adView without adding it to superview

##v.4.5.5 October 7 2015
- Fixed when after device rotation or method applicationWillEnterForeground: frame.origin of adView was (0, 0)

##v.4.5.4 September 28 2015
- Supporting iOS 9.
- Security improvements(don’t forget to add the NSAppTransportSecurity key in the Info.plist of your app) 
- Fixed expanded state when after devices rotation banner was shown in wrong size.

##v.4.5.3 September 8 2015
- Updated auto-closing after opening url in overlay zone when banner was closing after all urls.
- Updated flexible size when adView was initialised with CGRectZero frame.

##v.4.5.2 August 26 2015
- Add opportunities for ignoring requests in MadsAdWebView in whole application and for concrete adView.

##v.4.5.1 August 20 2015
- Fixed updateTimeInterval method when ad disappear after update.

##v.4.5.0 August 18 2015
- Remove optional parameter for size of adView in request.
- SDK adapted for working with mediation for third party network.
- Performance updates.
- Update request builder when IDFA was not sent.
- Fixed adView size after changing orientation.
- Using NSURLSession instead of NSURLConnection

##v.4.4.12 July 9 2015
- Fixed update function in interstitial mode when ad disappear after update.
- Fixed remove adView when observer for frame was removed incorrectly.
- Update request builder when idfa was not sent in situation when advertisingTrackingEnabled property was YES. 


##v.4.4.11 May 27 2015
- Fixed isViewable in inline mode when ad showing outside of window. 
- Fixed in inline mode when ad banner is showing with wrong height.
- Fixed adView when observers is not removed after deleting view.
- Performance updates.

##v.4.4.10 May 6 2015
- Fixed in overlay zone if user clicks on banner and this banner should be closed status bar is still hidden. 
- Add “closeAfterOpenUrl” property for control autoclose of banner after user clicks in overlay zone.

##v4.4.9, Mar 30 2015
- Fixed in overlay and interstitial zones if user clicks on banner Audio action zone and closes banner sound keeps playing.
- Inline mode: if resize ad width to screen width, then ad height should be proportionally resized too (in case flag UIViewAutoresizingFlexibleWidth of MadsAdView is set)
- Inline mode: set webView size before load HTML in it (fix possible problems with viewPort).

##v4.4.8, Feb 16 2015
- In ad request in key "model" now send “hw.machine” value (for example iPhone6,1) instead “hw.model” value (for example N51AP). See full list here http://en.wikipedia.org/wiki/List_of_iOS_devices (line “Hardware Strings”)

##v4.4.7, Nov 25 2014
- In MadsAdView moved adWebView adding from MadsAdView init to completion block after adWebView loadHTML

##v4.4.6, Nov 24 2014
- Fixed width of toolbar in internal browser

##v4.4.5, Nov 21 2014
- Fixed rotation to 180 degrees when ad view is expanded

##v4.4.4, Nov 19 2014
- Add a NSAssert when call MadsAdView with empty zone id
- Fixed in iOS 8 Inline and Overlay ads was not centered
- Fixed in iOS 8 Interstitial was not showing correctly in landscape
- Fixed in iOS 8 internal browser was not showing correctly in landscape
- Removed old lib OpenUDID (was deprecated since iOS 7) and all calls to it.

##v4.4.3, Nov 13 2014
- Added iPhone 6+ support (scale 3)
- Fixed screen size/orientation (UIScreen is interface oriented since iOS 8)
- Fixed location services
- Added support of geo locations in iOS 8 (don’t forget to add the NSLocationWhenInUseUsageDescription key in the Info.plist of your app)

##v4.4.2, Sept 4 2014
- Fix for update several ADs on same screen

##v4.4.1, Sept 2 2014
- Added AD tracking limit
- fixed over verbose logging

##v4.4.0, July 30 2014
- Essential stability improvements
- Switched to ARC, GCD and modern best practices
- Make more lightweight: cleanup and remove unnecessary code
- Fix potential linking problems with third-party libraries
- Latest iOS support
- Example App updated

##v4.3.10, May 20 2014
IDFA usage optimizations

##v4.3.9, April 29 2014
Performance improvement

##v4.3.8, April 18 2014
- added 64-bit support
- fixed GPS detection
- removed AdGoji
- improved performance

##v4.3.7, October 22th 2013
- Fix a useInternalBrowser issue that prevented the external browser from opening when needed.

##v4.3.6, October 16th 2013
- Fix incorrect scaling of web view in rotation on iOS7

##v4.3.5, October 16th 2013
- Handle the landscape case correctly for iOS 6 as well

##v4.3.4, October 16th 2013
- Handle the landscape case correctly: The internal browser toolbar now remains fixed at the bottom of the screen in iOS7

##v4.3.3, October 15th 2013
- Fixes several stability issues
- The internal browser toolbar now remains fixed at the bottom of the screen in iOS7

##v4.3.2, September 24th 2013
- Performance improvements

##v4.3.1, September 11th 2013
- iOS 7 support, compiled with final release of iOS 7

##v4.3.0, September 10th 2013
- iOS 7 support

##v4.2.9, August 8th 2013
- Make sure we register key value observers in main thread to prevent possible issues with removing the observers later

##v4.2.8, July 1st 2013
- Make sure we register key value observers in main thread to prevent possible issues with removing the observers later

##v4.2.7, June 28th 2013
- Fix issue where setLongitude and setLatitude had no effect on a custom ad request

##v4.2.6, June 21st 2013
- Extra safeguards against invalid ad server responses

##v4.2.5, June 18th 2013
- Performance improvement

##v4.2.4, June 15th 2013
- Fixes an issue where expanded ads in iPad sometimes did not take full screen

##v4.2.3, June 5th 2013
- Performance improvement

##v4.2.2, May 30th 2013
- Performance improvement

##v4.2.1, May 29th 2013
- Improve performance by adding extra logic to prevent the accelerometer to fire too often
- Add JS addition: windows.open = maid.open to ensure the same method is used in both cases

##v4.2.0, May 26th 2013
- Make sure MadsAdView delegate calls are done on the main thread so that they signal on time
- Added code to ensure the SDK works properly if an ad fails to load content

##v4.1.9, May 26th 2013
- Several performance improvements

##v4.1.8, May 6th 2013
- Fixes minor regression where a close button on overlay would not fire due to a pointInside method that forgot to call super

##v4.1.7, May 3rd 2013
- Several stability improvements

##v4.1.6, April 19th 2013
- massive speed improvement for click detection in complex adviews.

##v4.1.5, April 11th 2013
- Make sure the AdView takes the size the ad server returns when the ad is updated again.

##v4.1.4, April 4th 2013
- Fixes an issue where a key-value observer that is not removed correctly could cause an app crash

##v4.1.3, March 25th 2013
- Fix user agent issue
- Fixes bug that caused Expanded ads not to rotate according tot orientationProperties
- Rename advertiser id and vendor id fields to idea and idfv
- Replace asserts in code with NSAssert, allowing the developer to make sure assert failure in the SDK doesn't crash the app in release (make sure the NS_BLOCK_ASSERTIONS flag is set in your precompiler flags)

##v4.1.2, March 11th 2013
- Added support for MRAid 2 set and getOrientationProperties in addition to existing lockScreen method from MRaid 1.

##v4.1.1, March 5th 2013
- We have added a new withLocationPurpose parameter to the Mads Ad server initialisation call, to allow you to customise the CCLLocationManager alert that pops up if you request access to the location of the user

##v4.1.0, February 20th 2013
- PLEASE NOTE: The MadsSDK requires that the MadsAdServer needs to be initialised with a new call from this release on. The [MadsAdServer start] method has been replaced with a new call [MadsAdServer startWithLocationEnabled:(BOOL) enableLocation withAppTargetingEnabled:(BOOL) enableApptargeting];
- Note that the app will fail to run if you do not call this initialisation as explained in the documentation
- Fixes some minor issues for Mraid 2 compatibility

##v4.0.6, February 11th 2013
- Added new AdView delegate call-back methods to track the progress of MRaid resize
- Fix several rotation issues related to maid resize.
- Fixed issue where a resized ad couldn't be returned to its normal size because the resize button area was unresponsive

##v4.0.5, February 9th 2013
- Reinstate MRAID 1 methods for calendar events and phone. SDK is now fully backwards compatible with maid 1

##v4.0.4, February 8th 2013
- Reinstate external JSON lib as pre-iOS 5 devices cannot use the internal Apple JSON classes

##v4.0.3, February 7th 2013
- Both resize and expand now return to the default state correctly when closed
- when useCustomClose is set during an expand, the SDK will not display a close button, but instead have an invisible, transparent close area of 50x50 at the top-right of the creative

##v4.0.2, February 5th 2013
- Allow maid resize to be called more than once
- fix getPlacementType bug
- Allow mraid.expand to be called after maid.resize
- return to default state when mraid.resize or maid.expand closes
- if maid.storePicture has an invalid url, or the url points to a non-image, exit gracefully without crashing the app or sdk


##v4.0.1, February 1st 2013
- Allow maid resize to be called more than once
- gePlacementType now returns inline or overlay
- Simplify viewport parameters to match current MRAID standard
- If an ad is expanded, and the device is rotated before we close the expansion, the adview will resize correctly according to the device orientation after the expansion is closed
- expand URL removes the status bar completely
- The adview now tries to claim the device width correctly (even after rotation) if the developer has set an autoresizingmask

##v4.0.0, January 9th 2013
- Major upgrade, the SDK is now fully MRaid 2.0 compatible!
- New functions include:
- Resize, storePicture, calendar, video, and much more

##v3.1.6, December 5th 2012
- Replaced external JSON lib with internal NSJSONSerialization class
- Added UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionAllowAnimatedContent animations to the block animations that animate the MadsAdView in, this will improve performance

##v3.1.5, November 28 2012
- Moved the version nr into a public header file "MadsAdServer.h"

##v3.1.4, November 27 2012
- added 2 new MadsAdView delegate callbacks, willExpandAdFullScreen and didCloseExpandAdFullscreen
- added 2 new MadsAdView delegate callbacks, adWillOpenVideoFullScreen and adDidCloseVideoFullScreen
- added 2 new MadsAdView delegate callbacks, adWillOpenMessagUIFullScreen and adDidCloseMessageUIFullScreen

##v3.1.3, November 22 2012
- Added support for calendar events in different languages (e.g. cyrillic etc)
- Added a new property to MadsAdView that allows the developer to choose a slightly different way to open ad expands and internal browsers after a user clicks a banner. Instead of the parent view controller dealing with that event, the SDK now allows you to let the rootViewController of the app to deal with that. Useful if your UI partially blocks the expand or internal browser. Use only if needed.

##v3.1.2, November 19 2012
- Added support for calendar events in iOS 6. The SDK will ask iOS 6 users for permission to access their calendar.
- Calendar events are now created in the correct user time zone
- Increased the close button size used in Overlay ads for retina/non-retina displays

##v3.1.1, November 15 2012
- Hide the status bar when in an expandable ad the SMS interface is opened and then closed again.

##v3.1.0, November 14 2012
- Improved stability
- Fixed an error that could cause an ad view update to fail after the device has been rotated.
- Improved iOS 6 support

##v3.0.22, October 15 2012
- Adding the new Apple Advertiser ID
- Make sure to weak_link the new AdSupport framework

##v3.0.21, October 9 2012
- Rename QSUtilities class to prevent linking clashes

##v3.0.20, September 26 2012
- Fix issue where an ad returning from expanded state sometimes would be positioned at a wrong position

##v3.0.19, September 25 2012
- Reuse the original frame size for ad updates, while automatically dealing with device orientation changes
- Fixes a bug that would close the internal browser immediately in a unique scenario where a user installs an app, opens it, sees an overlay ad, and clicks on it.

##v3.0.18, September 24 2012
- Upgrade SDK to support iOS 6.0 and Xcode env to 4.5
- PLEASE NOTE 1: in Xcode 4.5 there is no more support for the armv6 architecture
- PLEASE NOTE 2: the lowest version of iOS that is now supported by Xcode 4.5 AND the Mads SDK v.3.0.18 and on is iOS 4.3
- Added a developer's guide to the SDK distribution


##v3.0.17, September 20 2012
- Update version nr
- Fix racing condition causing a crash when a user clicks on an overlay (opening the internal browser) and immediately tries to close the overlay ad, part 2
- Improved stability

##v3.0.16, September 18 2012
- Update version nr
- Fix racing condition causing a crash when a user clicks on an overlay (opening the internal browser) and immediately tries to close the overlay ad
- Fix for iPad interstitial ads (both non retina and retina)
- Improved stability

##v3.0.15, August 15 2012
- Update version nr
- Fix retina banner display on iPad and iPhone
- Overlay's are now positioned correctly
- Improved stability

##v3.0.14, July 12 2012
- Update to MadsAdView Documentation and header file with a warning to release a MadsAdView in dealloc if you retain it when you create the view.

##3.0.13, July 12 2012
- fixed: When in an expand, and then rotating the device, the internal browser gets its frame incorrect in landscape mode.

##v3.0.12, July 11 2012
- Custom close button in expand is sometimes placed out of sight

##v3.0.11, July 10 2012
- Fixed several issues related to incorrect processing of device rotations

##v3.0.10, June 15 2012
- The MadsAdView resizes to the default frame (the frame it was created with) when update is called.

##v3.0.9, 31 May 2012
- Set ability to set an ad size server size to YES. If you want a fixed size, then use the minSize/maxSize properties of the adview to change this behavior

##v3.0.8, 31 May 2012
- Expand of AdView in a UIScrollView sometimes failed. Fixed the issue by selecting the correct rootViewController to handle the expand with a presentModalViewController call

##v3.0.7, 31 May 2012
- Rename method to avoid name space clashes during linking

##v3.0.6, 25 May 2012
- Minor fixes wrt to the parameters of the ad request

##v3.0.5, 23 May 2012
- Fixes issue where releasing a MadsAdView could lead to a crash if the ad updater was not cleaned up correctly

##v3.0.2, 21 May 2012
- Fix issue where the internal browser would not open correctly when clicking an ad that was in expanded state already
- Fix minor user agent issue that caused some ad images not to load properly

##v3.0.2, 15 May 2012
- Fix concurrency issue causing the internal browser and safari to be reopened when the app is re-opened (e.g. coming back from iTunes)
- added a stopLoading method to MadsAdView to cancel all ad update requests
- When the ad server returns a MADSNOAD the SDK notifies the delegate of the adview correctly with a didFailToReceiveAd
- Fixed annoying typo in one of the public MadsAdView methods

##v3.0.1, 14 May 2012
- Fix user agent issue
- didReceiveAd callback now invoked from the main thread
- Added small code example and explanation for overlay ads
- Remove EventKitUI and use EventKit in combination with UIAlertView instead
- Always open the internal browser first if that's possible, unless the dev specifically asks to open the external browser
- Renamed some internal files to avoid linking clashes
- When a banner invokes a phone call, the user is asked permission to call first

##v3.0.0 May 1st 2012
- First release Mads MRAID SDK

## Author

MADS, support@mads.com

## License

MADSSDKiOS-ObjectiveC is available under the MIT license. See the LICENSE file for more info.
