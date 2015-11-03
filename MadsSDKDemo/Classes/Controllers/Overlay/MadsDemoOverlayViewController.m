//
//  MadsDemoSecondViewController.m
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MadsDemoOverlayViewController.h"
#import "AdConfigView.h"
#import "ZoneConstants.h"


@implementation MadsDemoOverlayViewController

@synthesize adView = _adView;


#pragma mark - Private methods

- (void)setupAdPosition
{
    if (self.adView) {
        self.adView = nil;
    }
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.adView = [[MadsAdView alloc] initWithFrame:CGRectZero
                                              zone:self.currentZone
                                          delegate:self];
        [self.adConfigView updateTitle:
         @"iPhone ad example : "];
    } else {
        self.adView = [[MadsAdView alloc] initWithFrame:CGRectZero//CGRectMake(0.f, 0.f, 300.f, 300.f)
                                                    zone:self.currentZone
                                                delegate:self];
        [self.adConfigView updateTitle:
         @"iPad ad example : "];
    }
    
    bool testServerMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"testservermode"] boolValue];
    self.adView.testMode           = testServerMode;
    [self.adConfigView updateTestServerModeLabel];

    self.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.adView.madsAdType       = MadsAdTypeOverlay;
    [self.adConfigView updateZone:self.currentZone];
    self.adView.closeAfterOpenUrl = self.adConfigView.isAutoCloseAfterClick;
    [self.view addSubview:self.adView];
    [self.adView addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    [self.adConfigView setDescriptionForFrame:self.adView.frame];
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        [self.adConfigView setDescriptionForFrame:self.adView.frame];
    }
}

- (void)setupZone
{
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.adConfigView updateZone:kiPhoneOverlayZone];
        self.currentZone   = kiPhoneOverlayZone;
    } else {
        [self.adConfigView updateZone:kiPadOverlayZone];
        self.currentZone   = kiPadOverlayZone;
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupZone];
    [self.adConfigView hideAdPositionControls:YES];
    [self.adConfigView spinnerOn];
    [self setupAdPosition];
    [self.adConfigView setupOverlayAutoCloseButton];
}

#pragma mark - IBActions

- (void)resetButtonPressed:(id)sender
{
    self.adConfigView.statusLabel.text = @"Zone reset...";

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.currentZone   = kiPhoneOverlayZone;
    } else {
        self.currentZone   = kiPadOverlayZone;
    }
    [self.adConfigView updateZone:self.currentZone];
}

- (void)refreshButtonPressed:(id)sender
{
    self.adConfigView.statusLabel.text = @"Loading ad...";

    if (!self.adView) {
        [self setupAdPosition];
    }
    else
    {
        [self.adView update];
    }
    
    bool testServerMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"testservermode"] boolValue];
    self.adView.testMode           = testServerMode;
    [self.adConfigView updateTestServerModeLabel];
    
//    [self.adView update];
    [self.adConfigView spinnerOn];
}

- (void)zoneChanged:(id)sender
{
    [self updateZone:[self.adConfigView currentZone]];
}

- (void)autoCloseChanged:(id)sender {
    self.adView.closeAfterOpenUrl = ((AdConfigView *)sender).isAutoCloseAfterClick;
}

#pragma mark- MadsAdViewDelegate

- (void)willReceiveAd:(id)sender
{
    self.adConfigView.statusLabel.text = @"Loading ad...";
}

- (void)didReceiveAd:(id)sender
{
    self.adConfigView.statusLabel.text = @"Ad loaded";
    [self.adConfigView spinnerOff];
}

- (void)didFailToReceiveAd:(id)sender
                 withError:(NSError *)error
{
    self.adConfigView.statusLabel.text = @"No ad available";
    [self.adConfigView spinnerOff];    
}

- (void)didClosedAd:(id)sender
  usageTimeInterval:(NSTimeInterval)usageTimeInterval
{
    [self.adView removeFromSuperview];
    self.adView = nil;
}

@end
