//
//  MadsAdViewDelegate.h
//  MadsSDK
//
//  Created by Alexander van Elsas on 2/24/12.
//  Copyright (c) 2012 Mads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** The MadsAdViewDelegate protocol defines methods that a delegate of a MadsAdView object can optionally implement to receive notifications during the process of loading and displaying an ad. 
 * If you set this delegate you can follow the ad creation and display process. */


@protocol MadsAdViewDelegate <NSObject>

@optional

/** Sent before an ad view will begin loading ad content.
 *
 * As soon as this method is called the adview will start downloading content from the ad server
 *
 * @param sender The ad view that is about to load ad content.
 */
- (void)willReceiveAd:(id)sender;

/** Sent after an ad view finished loading ad content.
 *
 * the ad will display immediately after this signal.
 *
 * @param sender The ad view has finished loading.
 */
- (void)didReceiveAd:(id)sender;

/** Sent if an ad view failed to load ad content.
 
 This method is called if an ad failed to load or if the server does not have an ad available at this time. The ad will not be visible on screen.
 
 @param sender The ad view that failed to load ad content.
 @param error The error that occurred during loading.
 */
- (void)didFailToReceiveAd:(id)sender
                 withError:(NSError *)error;

/** Sent before an ad view will start to display in the internal browser.
 
 @warning *Important:* This method called after adShouldOpen:withUrl: returns YES or not implemented.
 
 @warning *Important:* This method is not called on opening ads in Safari (useInternalBrowser set to NO). To handle this behaviour implement the corresponding UIApplicationDelegate protocol
 
 @param sender The ad view that is about to display an internal browser.
 */
- (void)adWillStartFullScreen:(id)sender;

/** Sent after an ad view finished displaying in the internal browser.
 
 @param sender The ad view has finished displaying in the internal browser.
 */
- (void)adDidEndFullScreen:(id)sender;

/** Sent before an ad view will expand to full screen.
 
 @param sender The ad view that is about to expand to full screen.
 */
- (void)adWillExpandFullScreen:(id)sender;

/** Sent After an ad expand is closed again.
 
 @param sender The ad view that closed the expanded state.
 */
- (void)adDidCloseExpandFullScreen:(id)sender;

/** Sent before an ad view will resize to a new size.
 
 @param sender The ad view that is about to resize to a new size.
 */
- (void)adWillResize:(id)sender;

/** Sent after an ad view has been resized to a new size.
 
 @param sender The ad view that just resized.
 */
- (void)adDidResize:(id)sender;

/** Sent After an ad expand is unresized again
 
 @param sender The ad view that unresized.
 */
- (void)adDidUnresizeAd:(id)sender;

/** Sent before an ad view will display a full screen video.
 
 @param sender The ad view that is about to display a full screen video.
 */
- (void)adWillOpenVideoFullScreen:(id)sender;

/** Sent After an ad full screen video is closed again.
 
 @param sender The ad view that closed the full screen video.
 */
- (void)adDidCloseVideoFullScreen:(id)sender;

/** Sent before an ad view will show an sms or email UI in full screen.
 
 @param sender The ad view that is about to display the UI.
 */
- (void)adWillOpenMessageUIFullScreen:(id)sender;

/** Sent After an ad message UI is closed again.
 
 @param sender The ad view that closed the message UI.
 */
- (void)adDidCloseMessageUIFullScreen:(id)sender;

/** Sent before an ad view will open a URL.
 
 Implement this method with return NO value if you want to control opening ads by your self.
 
 This method is optional. If you do not implement this method, the SDK accepts YES as return value.
  
 @param sender The ad view that is about to open the ad URL.
 @param url The URL that should be opened in either the internal or external browser.
 @return Return YES to allow SDK open the URL otherwise returns NO.
 */
- (BOOL)adShouldOpen:(id)sender
             withUrl:(NSURL *)url;

/** Sent after a full screen ad view closed and tracks the usage time of the ad full screen view.
 
 @param sender The ad view was closed.
 @param usageTimeInterval The usage time interval of the ad view.
 */
- (void)didClosedAd:(id)sender
  usageTimeInterval:(NSTimeInterval)usageTimeInterval;

/** Sent after an ad process MRAID command.
 
 @warning *Important:* Implement this method only if you want add additional logic for an MRAID event. By default the SDK is already compliant with all MRAID commands. Your code might conflict with the SDK
 
 @param sender The ad view that is about to process the MRAID event.
 @param event The string with name of the event.
 @param parameters The dictionary with parameters from the event.
 */
- (void)mraidProcess:(id)sender
               event:(NSString *)event
          parameters:(NSDictionary *)parameters;

/** Identify requests that should be ignored by concrete MadsAdWebView
* MadsAdWebView checks these requests to determine whether it should start load in:
* - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
* Items in this array should be dictionaries formatted like this:
*
* "URLPrefix": "http://itunes.apple.com",
* "NavigationTypes": [
                      *		"LinkClicked",
                      *		"Other"
                      * ]
*
* @return requests which will be ignore
*/
- (NSArray *)adRequestsToIgnore;

@end
