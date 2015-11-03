//
//  InterstitialPageViewController.h
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InterstitialPageViewControllerDelegate.h"
#import <MadsSDK/MadsSDK.h>


@interface InterstitialPageViewController : UIViewController <MadsAdViewDelegate>
{
    id <InterstitialPageViewControllerDelegate> __weak _delegate;
    MadsAdView *_adView;
    UIButton *_closeButton;
}
@property(nonatomic, weak) id<InterstitialPageViewControllerDelegate> delegate;
@property(nonatomic, strong) MadsAdView *adView;
@property(nonatomic, strong) UIButton *closeButton;

- (void)requestInterstitialAdWithZone:(NSString *)zone;

@end
