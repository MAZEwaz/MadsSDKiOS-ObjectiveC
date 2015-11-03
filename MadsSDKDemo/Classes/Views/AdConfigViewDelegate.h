//
//  AdConfigViewDelegate.h
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AdConfigViewDelegate <NSObject>

@optional

- (void)showCreativeController;

- (void)resetButtonPressed:(id)sender;
- (void)refreshButtonPressed:(id)sender;
- (void)modalButtonPressed:(id)sender;
- (void)zoneChanged:(id)sender;

- (void)htmlEntered:(id)sender;
- (void)bannerPositionPressed:(id)sender;
- (void)animationSelected:(id)sender;
- (void)autoCloseChanged:(id)sender;

@end
