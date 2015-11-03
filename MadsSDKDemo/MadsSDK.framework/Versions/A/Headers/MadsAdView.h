//
//  MadsAdView.h
//  MadsSDK
//
//  Created by Alexander van Elsas on 2/24/12.
//  Copyright (c) 2012 Mads. All rights reserved.
//

#import "MadsAdViewDelegate.h"
#import <UIKit/UIKit.h>


/***
 * Set #define to enable location services code or #undef to disable to exclude location detection from SDK.
 */
#define INCLUDE_LOCATION_MANAGER
// #undef INCLUDE_LOCATION_MANAGER


#ifdef INCLUDE_LOCATION_MANAGER
# import <CoreLocation/CoreLocation.h>
#endif



typedef NS_ENUM(NSUInteger, AdLogMode) {
        AdLogModeNone,
        AdLogModeErrorsOnly,
        AdLogModeAll
};

typedef NS_ENUM(NSUInteger, MadsAdType) {
    MadsAdTypeInline,
    MadsAdTypeOverlay
};


/***
 * You can define the animation type used to let the ad appear and disappear :
 * MadsAdAnimationTypeAppear: Animate the ad appearing (alpha value from 0 to 1)
 * MadsAdAnimationTypeTop: Animate the ad sliding down from the top of the screen
 * MadsAdAnimationTypeBottom: Animate the ad sliding up from the bottom of the screen
 * MadsAdAnimationTypeLeft: Animate the ad sliding in from the left of the screen
 * MadsAdAnimationTypeRight: Animate the ad sliding in from the right of the screen
 * Default animation behavior is MadsAdAnimationTypeAppear
 */
typedef NS_ENUM(NSUInteger, MadsAdAnimationType) {
    MadsAdAnimationTypeAppear,
    MadsAdAnimationTypeTop, 
    MadsAdAnimationTypeBottom,
    MadsAdAnimationTypeLeft,
    MadsAdAnimationTypeRight
};


/** The MadsAdView class can be used to embed advertisement content in your application. Simply create a MadsAdView and ad it to a UIView. You can set properties to customize the ad and the way it displays and animates on screen. Use the initWithFrame:zone:secret:delegate method to initialize a MadsAdView object. By setting a delegate that implements the MadsAdViewDelegate protocol you can follow progress on the ad loading and displaying content.
 
 Make sure you obtain a zone id from Mads so that the server can authenticate ad requests from you.
 
 The MadsAdView object handles all rendering and interactions of any content. It renders simple banners and rich media, all MRAID compatible ads.
 
 There are 2 types of MadsAdView ads, inline and overlay. An inline ad is part of your view hierarchy and will display ads within that hierarchy. An overlay ad will display in the keyWindow, and will therefore cover (part of) your interface. Note that if you want to create an overlay you do not have to ad the view to the keyWindow yourself. See below for a code example.
 
 If you want the adView to scale a little bigger if your UI allows it you can specify a minimum and maximum size of the ad with the minSize and maxSize properties.
 
 The MadsAdView will load content shortly after creation. The time it takes to start loading content is available to you to set additional properties. If you want the ad to load immediately you can call the update method. To see if an ad is loading you can check the isLoading property. The MadsAdView object will load new content after a specific time period. You can alter this by setting the updateTimeInterval property.
 
 You can specify an animation type for the appearance, and disappearance of a MadsAdView object. The object will not be visible until advertisement content has been loaded. Use the animationType property to set a specific animation type.
 
 If you want to send additional targeting data along in your ad request you can add key-value pairs to the additionalParameters property. These values will be used to target the advertisement shown on the device.
  
 If you want to debug ad behavior you can set the testMode and logMode properties of the MadsAdView. 
 
 Example Code, create an ad in 2 lines :
     // Notice that you do not need to keep the adView hidden. It will not be visible until content is loaded
     MadsAdView *adView = [[[MadsAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0) 
                                                        zone:@"your_zone_id_here"
                                                    delegate:self] autorelease];
 
     [self.view addSubView:adView];
 
 
 Example Code, set some properties :
 
     adView.maxSize = CGSizeMake(320.0, 100.0); // this allows the adView to increase height to 100 if needed
     adView.gender = @"male"; // tell the adserver to target a male
     adView.madsAdType = MadsAdTypeOverlay; // request an overlay ad
     adView.animationType = MadsAdAnimationTypeTop; // animate the adview in from the top of the screen
     adView.updateTimeInterval = 120.0; // refresh the ad view with a new ad after 2 minutes
 
 Example code, create an overlay Ad :
 
     // Note that the Ad Server decides the size and position of the overlay ad, so
     // set the frame to CGRectZero
     MadsAdView *adView = [[[MadsAdView alloc] initWithFrame:CGRectZero 
                                                        zone:@"your_overlay_zone_id_here"
                                                    delegate:self] autorelease];

     adView.madsAdType = MadsAdTypeOverlay;
     // We add the AdView to our ViewController, and when the overlay ad is loaded
     // it will position itself in the [UIApplication sharedApplication].keyWindow
     [self.view addSubView:adView];
 
 @warning Some advice on using the MadsSDK:  
 
 For inline ads, do not visibly create space to fit the MadsAdView until the adview has actually loaded its content. Once the didReceiveAd delegate method fires, animate the MadsAdView into your current UI. The golden rule should be, if there is no ad content to display, do not show any trace of an ad space in your UI. The experience will be better when you animate the ad in when its ready. MadsAdView provides default animation options so that animtion becomes very easy to accomplish, see the property animationType.  
 
 Note that by default, the MadsAdView will be hidden until the ad content is loaded. No need to manage that yourself.  
 
 When to call update on a MadsAdView?  
 
 Call the update method whenever a user enters a context or UI that contains a MadsAdView. Remember that calling update is a relative expensive operation as content needs to be downloaded from the ad server. For example, if you add a MadsAdView to every page in a UIScrollView, you may end up calling update for every ad view when a user scrolles back and forth on pages (this can happen a lot). Instead, you may want to consider having one MadsAdView on top of the UIScrollView, so that refreshing only needs to be done once, when the user enters the view that contains the UIScrollView.
 
 If you retain a MadsAdview
 
 Be sure to release theMadsAdview in dealloc again. If you do not do this, then click behavior is not guaranteed anymore when the app goed in to the background and comes back to the foreground again (for example with ads that send the user to the app store or a web site).
 
 */


@interface MadsAdView : UIView

/** @name Initializing an MadsAdView Object */

/** Initializes and returns an MadsAdView object having the given frame, zone and delegate.
 
 @param frame A rectangle specifies the initial location and size of the ad view in its superview’s coordinates.
 @param zone A value that specifies the id of ad publisher's zone.
 @param delegate The delegate that is to receive all signalling regarding the creation and loading of an ad.
 
 @return Returns an initialized MadsAdView object or nil if the object could not be successfully initialized.
 */
- (instancetype)initWithFrame:(CGRect)frame
                         zone:(NSString *)zone
                     delegate:(id)delegate;

/** @name Configuring the MadsAdView */

/** zone of the publisher site.
 The default value is copied from parameter site of ad initialization method. 
 */
@property (nonatomic, copy)     NSString               *zone;

/** Ad type.
 
 typedef NS_ENUM(NSUInteger, MadsAdType) {
     MadsAdTypeInline,
     MadsAdTypeOverlay
 };

 Use this property to set the type of ad you want to display. An Inline ad is an ad you insert into your view at a fixed position. An Overlay ad is an ad that is added to your KeyWindow. Overlay ads are usually full screen, but do not have to be (partial overlay).
 
 The default value is MadsAdTypeInline.
 
 */
@property (nonatomic)           MadsAdType              madsAdType;

/** The animation type for appearance/disappearance of the ad
 
 The value of this property determines the animation used when an ad appears on or disappears from the screen. 
 
 typedef NS_ENUM(NSUInteger, MadsAdAnimationType) {
     MadsAdAnimationTypeAppear,
     MadsAdAnimationTypeTop,
     MadsAdAnimationTypeBottom,
     MadsAdAnimationTypeLeft,
     MadsAdAnimationTypeRight
 };

 The default value is MadsAnimationTypeAppear.
 */
@property (nonatomic)           MadsAdAnimationType     animationType;

/** Size of the ad content that is displaying.
 
 Use this property to get the actual size of the ad content being displayed. Property value is set after ad content has been downloaded.
 
 @warning *Note:* If the ad as not been loaded yet the property returns CGRectZero.
 */
@property (nonatomic, readonly) CGSize                  contentSize;

/** Image for unloaded ad state.
 
 In the unloaded state of an ad the MadsAdView will be invisible. You van choose to display a default image in the meantime unitl the ad is loaded. The image will also be visible if there is no internet connection and ad content cannot be downloaded.
 
 The default value is nil.
 */
@property (nonatomic, strong)   UIImage                *defaultImage;

/** A Boolean value that determines whether to hide ad in case an error occurs
 
 Use this property to hide ad in case of error.
 
 The default value is YES.*/
@property (nonatomic)           BOOL                    autoCollapse;

/** A Boolean value that determines whether to show previous ad in case an error occurs
 
 Use this property to show previous ad in case of error.
 
 The default value is YES.*/
@property (nonatomic)           BOOL                    showPreviousAdOnError;

/** A Boolean value that determines whether to close ad after open link on tap in overlay mode
 
 Use this property to close ad after open browser or app`s url in overlay mode.
 
 The default value us YES */

@property (assign, nonatomic)   BOOL                    closeAfterOpenUrl;

/** Close button.
 
 Set this value to customize the close button appearance and behaviour.
 
 By default the SDK provides a close button with its hidden property set to YES.
 
 @warning *Note:* If you set a custom UIButton then you need implement its close logic too.
 
 @warning *Note:* If you simply want to enable the default close button, set the hidden property of the close button to NO.
 
 @warning this is normally used for Overlay ads only
 */
@property (nonatomic, strong)   UIButton               *closeButton;

/** Show a close button after a delay time interval, in seconds.
 
 Setting this property to -1 will show the close button immediately.
 
 The default value is -1.

 @warning this is normally used for Overlay ads only
*/
@property (nonatomic)           NSTimeInterval          showCloseButtonTime;

/** Auto close an interstitial ad with specified time interval, in seconds.
 
 Setting to -1 will disable auto closing of the interstitial ad.
 
 The default value is -1.
 */
@property (nonatomic)           NSTimeInterval          autocloseInterstitialTime;

/** Update time interval, in seconds.
 
 The value of this property determines time interval between ads updating. This interval is counted after finish loading content, so the ad will start updating only after loading is finished and time interval is passed.
 
 Setting value in range from 0 to 5 will apply 5 seconds to prevent too fast ad updates.
 
 Setting to 0 will stop updates. All positive values enable updates.
 
 The default value is 120.
 */
@property (nonatomic)           NSTimeInterval          updateTimeInterval;

/** Ad server url.
 
 The URL handling the ad requests.
 
 The default value is https://eu2.madsone.com
 */
@property (nonatomic, copy)     NSString               *adServerUrl;

/** Maximum server response time.
 
 Specify timeout of ad call. This tells the ad server the maximum time you are willing to wait for an ad response.
 
 The default value is 1000ms (milleseconds).
 
 The max value is 3000ms (milleseconds).
 */
@property (nonatomic)           NSInteger               adCallTimeout;

/** A Boolean value that determines whether content alignment is centered vertically and horizontally.
 
 If you set the value of this property to YES, the ad server will auto wrap server response content in an HTML table with alignment.
 The default value is NO.
 */
@property (nonatomic)           BOOL                    contentAlignment;

/** Minimum size of the ad content that will be displayed.
 
 Use this property to set the minimum size of the ad content. The ad server response will be close to this size. 
 If you set this property the AdServer will not  deliver an ad that is smaller than your minSize.
 
 The default mimimum ad size is bounded by : 1 >= width <= AdView frame width, 1 >= height <= Adview frame height.
 */
@property (nonatomic)           CGSize                  minSize;

/** Maximum size of the ad content that will be displayed.
 
 Use this property to set the maximum size of the ad content. The ad server response will be close to this size.  If you set this property the AdServer will try to deliver an ad with a size close to your maxSize.
 
 The default maximum ad size is bounded by : 1 >= width <= AdView frame width, 1 >= height <= Adview frame height.

 */
@property (nonatomic)           CGSize                  maxSize;

/** A Boolean value that determines whether ad track is enabled.
 
 If set to YES, the ad server will send a client side impression tracking pixel with each ad, regardless of if the campaign has this property set or not. Impressions will not be counting if this pixel does not render on the device.
 
 The default value is NO.
 */
@property (nonatomic)           BOOL                    track;

/** A Boolean value that determines whether an ad internal browser is enabled.
 
 Set the value of this property to NO disables internal browser, so after clicking on a banner with an external link, the ad publisher site will be opened in Safari and the user will leave your app.
 
 To handle opening/closing internal browser use MadsAdView delegate or viewWillAppear/viewWillDisappear methods of UIViewController.
 
 The default value is YES.
 */
@property (nonatomic)           BOOL                    useInternalBrowser;


/** A Boolean value that determines which ViewController is in charge of handling ad expands and opening of the Internal browser.
 
 Set the value of this property to YES to let the rootViewController of your AppDelegate handle this.
 
 If set to NO, the parent view controller of the MadsAdView will handle this logic. Leave this parameter to NO unless ad expansion or opening the internal browser leads to display issues (e.g. either the ad expand or the internal browser is (partially) covered by some UI).
 
 
 The default value is NO.
 */
@property (nonatomic)           BOOL                    useRootViewControllerForExpandAndInternalBrowser;

/** Set the color of ad text links.
 
 The default value is nil.
 
 @warning *Note:* Alpha value ignored.
 */
@property (nonatomic, strong)   UIColor                *textColor;

/** @name Loading state of the MadsAdView Content */

/** A Boolean value that determines whether the ad is in the process of loading. */
@property (nonatomic, readonly) BOOL                    isLoading;

/** Starts to update the ad content immediately.
 
 Call this method if you want to request an immediate update of the ad content (for example, after setting site and zone or changing adServerUrl). If ad is already in the process of loading it will be interrupted and a new request will be send.
 */
- (void)update;

/** Stop adview updates in progress
 
 Use this method, if you want to stop any update requests to the ad view. If the internal browser was opened, it will be closed. If the adview was in expanded state it will return to a normal state.
 */
- (void)stopLoading;


/** Stop adview updates and clean up
 
 Use this method, if you want to stop any updates to the ad view and clear all resources associated with it. If the internal browser was opened, it will be closed. If the adview was in expanded state it will return to a normal state. The ad itself will be cleaned up. If you merely want to stop the adView from loading something, use stopLoading instead
 */
- (void)stopEverythingAndNotifyDelegateOnCleanup;

/** Load blank adWebView
 
 Use this method, in order to stop plaing audio or video after closeing overlay or interstitial
 */
- (void)loadBlankAdWebWiew;

/** @name Filtering the MadsAdView Content*/

/** Additional parameters.
 
 Use this property to add additional custom parameters to your ad request. For example, you can provide the ad server with extra targeting data to improve the quality of the ads shown. [NSDictionary dictionaryWithObject:@"male" forKey:@"gender"]
 
 The default value is nil.
 
 @warning *Note:* All keys and objects must be of type NSString Class. For example:
    [NSDictionary dictionaryWithObject:@"value" forKey:@"key"]
 */
@property (nonatomic, copy)     NSDictionary           *additionalParameters;

/** The country of visitor. Setting this property will override automatic country detection via IP. Country codes need to be specified with the ISO 3166 standard. see for example http://en.wikipedia.org/wiki/ISO_3166 for more details
 
 The default value is nil.
 */

@property (nonatomic, copy)     NSString               *country;

/** Region of visitor. ISO 3166-2 is used for United States and Canada. See for example: http://en.wikipedia.org/wiki/ISO_3166-2
 
 FIBS 10-4 is used for other countries. See for example: http://en.wikipedia.org/wiki/List_of_FIPS_region_codes
 
 The default value is nil.
 */

@property (nonatomic, copy)     NSString               *region;

/** City of the device user.
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *city;

/** Area code of a user.
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *area;

/** Metro code of a user. For US only.
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *metro;

/** User location latitude value.
 
 Use this property to set latitude. The value @“” will stop coordinates of auto-detection and coordinates will not be sent to the server. Any other values also will stop the coordinates of auto-detection but coordinates will be sent to the server.
 
 The default value is auto-detected by the locationManager and sent to server. 
 */

@property (nonatomic, copy)     NSString               *latitude;

/** User location longitude value.
 
 Use this property to set longitude. The value @“” will stop the coordinates of the auto-detection and these coordinates will not be sent to the server. Any other values also will stop the coordinates of auto-detection but these coordinates will be sent to server.
 
 The default value is auto-detected by the locationManager and sent to server.
 */

@property (nonatomic, copy)     NSString               *longitude;


/** User location location accurary.
 
 Use this property to set horizontalAccuracy. The value @“” will stop the coordinates of the auto-detection and these coordinates will not be sent to the server. Any other values also will stop the coordinates of auto-detection but these coordinates will be sent to server.
 
 The default value is auto-detected by the locationManager and sent to server.
 */

@property (nonatomic, copy)     NSString               *horizontalAccuracy;

/** Zip/Postal code of user
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *zip;

/** User carrier.
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *carrier;

/** User Income.
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *income;

/** User Gender. You can set it to male or female
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *gender;

/** User age.
 
 The default value is -1 (which is ignored).
 */
@property (nonatomic)           NSInteger               age;

/** idX. An additional unique identifier that can be set
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *idx;

/** idX2. An additional unique identifier that can be set
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *idx2;

/** Cookie. A cookie value that can be set
 
 The default value is nil.
 */
@property (nonatomic, copy)     NSString               *cookie;


/** @name Debug the MadsAdView */


/** A Boolean value that determines whether ads test mode is enabled.
 Setting the value of this property to YES enables ads test mode and setting it to NO disables ads test mode.
 
 The default value is NO.*/
@property (nonatomic)           BOOL                    testMode;

/** AdLogMode value that determines log level.
 
  typedef NS_ENUM(NSUInteger, AdLogMode) {
         AdLogModeNone,
         AdLogModeErrorsOnly,
         AdLogModeAll
 };

 Setting the value of this property to AdLogModeNone disables ads logging. AdLogModeErrorsOnly - enables logging errors only. AdLogModeAll - enables logging errors and info.
 
 The default value is AdLogModeErrorsOnly. */
@property (nonatomic)           AdLogMode               logMode;

/** @name Setting the Delegate */


/** The receiver's delegate.
 
 The MadsAdView is sent messages when content is processing. The delegate must adopt the MadsAdViewDelegate protocol.
 The delegate is not retained.
 
 @warning *Important:* Before releasing an instance of MadsAdView for which you have set a delegate, you must first set its delegate property to nil. This can be done, for example, in your dealloc method.
 
 @see MadsAdViewDelegate Protocol Reference for the optional methods this delegate may implement.
 */
@property (nonatomic, weak)     id <MadsAdViewDelegate> delegate;

/** The mediator delegate
 
 When MadsAdView works with third party ad networks it use mediatorDelegate for getting specific parameters from application. 
 
 Set this delegate when You work with third party ad networks.
 */

@end
