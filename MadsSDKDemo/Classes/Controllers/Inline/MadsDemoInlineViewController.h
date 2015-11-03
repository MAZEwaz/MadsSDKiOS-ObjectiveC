//
//  MadsDemoFirstViewController.h
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import <MadsSDK/MadsSDK.h>

@class MadsAdView;

@interface MadsDemoInlineViewController : BaseViewController <AdConfigViewDelegate, MadsAdViewDelegate>

@property(nonatomic, strong) MadsAdView *adView;
@property(nonatomic, strong) MadsAdView *adView2;
@property(nonatomic, assign) BOOL        isResized;

@end
