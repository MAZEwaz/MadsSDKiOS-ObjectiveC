//
//  InterstitialPageViewControllerDelegate.h
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InterstitialPageViewControllerDelegate <NSObject>

@optional

-(void) didReceiveAd: (id) sender;
-(void) didFailToReceiveAd:(id) sender;
-(void) adWillStartFullScreen:(id) sender;
-(void) adDidEndFullScreen:(id) sender;

@end
