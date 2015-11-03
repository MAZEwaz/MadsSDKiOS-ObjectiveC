//
//  MadsDemoAppDelegate.h
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MadsDemoAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIStoryboard *storyboard ;
@property (nonatomic, strong) UINavigationController *mainViewController;

@end
