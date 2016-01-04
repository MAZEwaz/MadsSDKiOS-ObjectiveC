//
//  MadsAdServer.h
//  MadsSDK
//
//  Created by Alexander van Elsas on 2/24/12.
//  Copyright (c) 2012 Mads. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString *const kMadsSDKVersion = @"v4.5.9";


@interface MadsAdServer : NSObject

/** Start the Mads AdServer
 *
 * The MadsAdServer needs to be initialized once by calling it's startWithLocationEnabled:(BOOL) enableLocation withLocationPurpose:(NSString *) purpose method during
 * didFinishLaunchingWithOptions and in applicationWillEnterForeground. This call ensures that the ad server is initialized properly.
 *
 * The Mads Ad Server has a global targeting method that can improve the effectiveness of the advertisement served. That is the use of location services to improve targeting. This initializer uses a default time interval of 5 mins for location updates. To specify a preferred time interval, use the initializer [startWithLocationEnabled:withLocationPurpose:withLocationUpdateTimeInterval:](#//api/name/startWithLocationEnabled:withLocationPurpose:withLocationUpdateTimeInterval:) instead.
 *
 * @param enableLocation turn location targeting on or off
 *
 * If YES location will be used in advertisement targeting, and the user may be promptedto allow access to location services.
 *
 * If NO location will not be used for advertisement targeting.
 * Note: be aware that if you turn location services on, the user will be prompted by iOS if the user has not given the app permission to access location. We would suggest you only enable location for advertisement if the app itself already uses location services.
 *
 * @param purpose Add a reason for asking permission to access location.
 * Customize the prompt requesting permission to access location by adding a specific purpose to the dialogue (e.g. NSLocalizedString(@"To provide local weather information", nil) )
 * Note: Deprecated in iOS 8. Need add to Info.plist file key NSLocationWhenInUseUsageDescription that takes a string which is a description of why you need location services. If the NSLocationWhenInUseUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support WhenInUse authorization.
 * Note: Cases of locations usage:
 *  - User has location services off, Publisher has not enabled MADS location services in app: no pop-ups in any case.
 *  - User has location services off, Publisher has enabled MADS location services: after app start system remind him to turn location services on in preferences. On first time usage of app, pop-up will ask for location permission and the user will not get another popup anymore.
 *  - User has location services on, Publishers has not enabled MADS location services in app: no pop-up in any case
 *  - User has location services on, Publisher has enabled MADS location services in app. On first time usage of app, pop-up will ask for location permission and the user will not get another popup anymore.
 * If locations services off in system and Publisher don't want see any popups before user turns on location services, use [MadsAdServer startWithLocationEnabled:[CLLocationManager locationServicesEnabled] withLocationPurpose:nil];
 *
 */
+ (void)startWithLocationEnabled:(BOOL)enableLocation
             withLocationPurpose:(NSString *)purpose;

/** Start the Mads AdServer
 *
 * The MadsAdServer needs to be initialized once by calling it's startWithLocationEnabled:(BOOL) enableLocation withLocationPurpose:(NSString *) purpose method during
 * didFinishLaunchingWithOptions and in applicationWillEnterForeground. This call ensures that the ad server is initialized properly.
 *
 * The Mads Ad Server has a global targeting method that can improve the effectiveness of the advertisement served. That is the use of location services to improve targeting.
 * @param enableLocation turn location targeting on or off
 *
 * If YES location will be used in advertisement targeting, and the user may be promptedto allow access to location services.
 *
 * If NO location will not be used for advertisement targeting.
 * Note: be aware that if you turn location services on, the user will be prompted by iOS if the user has not given the app permission to access location. We would suggest you only enable location for advertisement if the app itself already uses location services.
 *
 * @param purpose Add a reason for asking permission to access location. 
 * Customize the prompt requesting permission to access location by adding a specific purpose to the dialogue (e.g. NSLocalizedString(@"To provide local weather information", nil) )
 * Note: Deprecated in iOS 8. Need add to Info.plist file key NSLocationWhenInUseUsageDescription that takes a string which is a description of why you need location services. If the NSLocationWhenInUseUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support WhenInUse authorization.
 * Note: Cases of locations usage:
 *  - User has location services off, Publisher has not enabled MADS location services in app: no pop-ups in any case.
 *  - User has location services off, Publisher has enabled MADS location services: after app start system remind him to turn location services on in preferences. On first time usage of app, pop-up will ask for location permission and the user will not get another popup anymore.
 *  - User has location services on, Publishers has not enabled MADS location services in app: no pop-up in any case
 *  - User has location services on, Publisher has enabled MADS location services in app. On first time usage of app, pop-up will ask for location permission and the user will not get another popup anymore.
 * If locations services off in system and Publisher don't want see any popups before user turns on location services, use [MadsAdServer startWithLocationEnabled:[CLLocationManager locationServicesEnabled] withLocationPurpose:nil];
 *
 * @param locationUpdateTimeInterval Location update time interval, in seconds.
 *
 * The value of locationUpdateTimeInterval determines time interval between location updating. This interval is counted after finish detecting location, so the location will start updating only after detecting is finished and time interval is passed. Setting to 0 will continuously updates. All positive values enable updates. The default value is 300s.
 *
 */
+ (void)startWithLocationEnabled:(BOOL)enableLocation
             withLocationPurpose:(NSString *)purpose
  withLocationUpdateTimeInterval:(NSTimeInterval)locationUpdateTimeInterval;

/** Stop the Mads AdServer
 *
 * The MadsAdServer needs to be closed down to save as much memory as possible when the app
 * terminates or goes into the background. You can stop the MadsAdserver by calling it's stop 
 * method during applicationWillTerminate and in applicationWillEnterBackground
 *
 */
+ (void)stop;

/** see the current value of the useLocationServices property that is set during the ad server initialization
 *
 *
 * @warning Important: Be aware that of your app doesn't use location services for anything else, setting locaten services enabled in the ad server initialization will cause a popup to appear requesting the user's permission to use location services
 *
 */
+ (BOOL)locationServicesEnabled;

/** Identify requests that should be ignored by the MadsAdWebView in whole application
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
 * @param requests The requests to ignore
 */
+ (void)setRequestsToIgnore:(NSArray *)requests;

/** Returns the requests that are currently ignored
 * Items in this array are dictionaries formatted like this:
 *
 * "URLPrefix": "http://itunes.apple.com",
 * "NavigationTypes": [
 *		"LinkClicked",
 *		"Other"
 * ]
 */
+ (NSArray *)requestsToIgnore;

@end
