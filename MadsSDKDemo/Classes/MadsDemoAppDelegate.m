//
//  MadsDemoAppDelegate.m
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MadsDemoAppDelegate.h"

#import "MadsDemoInlineViewController.h"
#import "MadsDemoOverlayViewController.h"
#import "MadsDemoInterStitialViewController.h"
#import "MadsDemoSettingsViewController.h"
#import "MadsTabBarController.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface MadsDemoAppDelegate ()
@property (strong, nonatomic) UIViewController *initialViewController;
@end


@implementation MadsDemoAppDelegate

@synthesize storyboard = _storyboard;
@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MadsAdServer startWithLocationEnabled:YES withLocationPurpose:nil withLocationUpdateTimeInterval:1.0];
  /*  [MadsAdServer setRequestsToIgnore:@[ @{ @"URLPrefix": @"itms-apps://itunes", @"NavigationTypes": @[ @"Other" ] },
  @{ @"URLPrefix": @"https://itunes.apple.com", @"NavigationTypes": @[ @"Other" ] },
  @{ @"URLPrefix": @"http://itunes.apple.com", @"NavigationTypes": @[ @"Other" ] },
  @{ @"URLPrefix": @"https://itunes.com", @"NavigationTypes": @[ @"Other" ] },
  @{ @"URLPrefix": @"http://itunes.com", @"NavigationTypes": @[ @"Other" ] },
  @{ @"URLPrefix": @"https://www.itunes.com", @"NavigationTypes": @[ @"Other" ] },
  @{ @"URLPrefix": @"http://www.itunes.com", @"NavigationTypes": @[ @"Other" ] },
  @{ @"URLPrefix": @"itms-appss://", @"NavigationTypes": @[ @"Other" ] }]];*/
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];

    self.mainViewController = [storyboard instantiateInitialViewController];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.mainViewController;

    if (UIDevice.currentDevice.systemVersion.floatValue >= 7.f) {
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0]];
        [[UITabBar appearance] setBarTintColor:UIColor.blackColor];
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    }

    [self.window makeKeyAndVisible];
    
    [Fabric with:@[CrashlyticsKit]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"starttime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskAll;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [MadsAdServer stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
    [MadsAdServer startWithLocationEnabled:YES withLocationPurpose:nil withLocationUpdateTimeInterval:1.0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    [MadsAdServer stop];

}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString* urlStr = [url absoluteString];
    
    NSLog(@"~~~~> handleOpenURL url %@", urlStr);
    
    NSArray* stringComponents = [urlStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":/"]];
    
    if([[stringComponents firstObject] isEqualToString:@"mads"])
    {
        
        NSMutableDictionary* sendInfo = [[NSMutableDictionary alloc] init];
        
        NSString* tab = [stringComponents lastObject];
        [sendInfo setObject:tab forKey:@"tab"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goToTab"
                                                            object:sendInfo];
    }
    else
    {
        UIAlertView *alertView;
        NSString *text = [url absoluteString];// [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        alertView = [[UIAlertView alloc] initWithTitle:@"MADS"
                                               message:text
                                              delegate:nil
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:nil];
        [alertView show];
    }
    
    return YES;
}

@end
