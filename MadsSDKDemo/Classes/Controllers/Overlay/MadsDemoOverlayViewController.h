//
//  MadsDemoSecondViewController.h
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import <MadsSDK/MadsSDK.h>


@class MadsAdView;


@interface MadsDemoOverlayViewController : BaseViewController  <AdConfigViewDelegate, MadsAdViewDelegate>

@property(nonatomic, strong) MadsAdView *adView;

@end
