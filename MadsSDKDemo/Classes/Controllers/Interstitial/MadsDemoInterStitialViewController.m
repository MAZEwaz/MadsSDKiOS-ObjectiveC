//
//  MadsDemoFirstViewController.m
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MadsDemoInterstitialViewController.h"
#import "AdConfigView.h"
#import "ZoneConstants.h"
#import "InterstitialPageViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation MadsDemoInterstitialViewController

@synthesize startButton = _startButton;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    self.hideGrid = true;
    [super viewDidLoad];
}

- (void)startButtonPressed
{
    InterstitialPageViewController *aController = InterstitialPageViewController.new;
    if (![UIApplication sharedApplication].statusBarHidden) {
        UIApplication.sharedApplication.statusBarHidden = YES;
    }
// Deprecated in 7_0    aController.wantsFullScreenLayout = YES;
    [self presentViewController:aController
                       animated:YES
                     completion:nil];
    [aController requestInterstitialAdWithZone:self.currentZone];
    [self.adConfigView updateZone:self.currentZone];
}

- (void)setupStartButton
{
    if (self.startButton) {
        return;
    }
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(self.view.frame.size.width / 2 - 40.f,
                               self.adConfigView.frame.origin.y
                               + self.adConfigView.frame.size.height - 32.f + 20.f,
                               80.f,
                               28.f);
    [aButton setTitle:NSLocalizedString(@"Start demo",)
             forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                              size:12.f];
    aButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aButton setTitleColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0]
                  forState:UIControlStateNormal];
//    [aButton setTitleShadowColor:UIColor.whiteColor
//                        forState:UIControlStateNormal];
//    aButton.titleLabel.shadowOffset = CGSizeMake(0, 1);

    aButton.layer.cornerRadius  = 8.f;
    aButton.layer.masksToBounds = YES;
    aButton.layer.borderWidth   = 1.f;

    aButton.layer.borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = aButton.bounds;
//    gradient.colors = @[(id)[UIColor colorWithRed:1.f
//                                            green:1.f
//                                             blue:1.f
//                                            alpha:1.f].CGColor,
//                        (id)[UIColor colorWithRed:0.847058f
//                                            green:0.847058f
//                                             blue:0.847058f
//                                            alpha:1.f].CGColor,
//                        (id)[UIColor colorWithRed:0.729411f
//                                            green:0.729411f
//                                             blue:0.729411f
//                                            alpha:1.f].CGColor];
//    [[aButton layer] insertSublayer:gradient atIndex:0];

    [aButton addTarget:self
                action:@selector(startButtonPressed)
      forControlEvents:UIControlEventTouchUpInside];
    aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin
                             | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:aButton];
    self.startButton = aButton;
}

- (void)setupZone
{
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.adConfigView updateZone:kiPhoneInterstitialZone];
        self.currentZone   = kiPhoneInterstitialZone;
    } else {
        [self.adConfigView updateZone:kiPadInterstitialZone];
        self.currentZone   = kiPadInterstitialZone;
    }
}

- (void)removeAdPositionSegmentController
{
    [self.adConfigView hideAdPositionControls:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.adConfigView updateTitle:
     [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"iPhone ad example : "
                                                                                : @"iPad ad example : "];
    [self.adConfigView updateTestServerModeLabel];
    [self setupStartButton];
    [self setupZone];
    [self removeAdPositionSegmentController];
}

- (void)zoneChanged:(id) sender
{
    [self updateZone:[self.adConfigView currentZone]];
}

#pragma mark - IBActions

- (void)refreshButtonPressed:(id)sender
{
    /* currently none */
}

#pragma mark - AdConfigViewDelegate

- (void)resetButtonPressed:(id)sender
{
    self.adConfigView.statusLabel.text = NSLocalizedString(@"Zone reset..",);

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.currentZone   = kiPhoneInterstitialZone;
    } else {
        self.currentZone   = kiPadInterstitialZone;
    }
    [self.adConfigView updateZone:self.currentZone];
}

@end
