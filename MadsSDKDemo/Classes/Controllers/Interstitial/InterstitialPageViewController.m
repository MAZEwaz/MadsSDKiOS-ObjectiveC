//
//  InterstitialPageViewController.m
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InterstitialPageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface InterstitialPageViewController()

@property (strong, nonatomic) UIButton *updateButton;

@end

@implementation InterstitialPageViewController
@synthesize //pageNumberLabel = _pageNumberLabel,
            adView = _adView,
            closeButton = _closeButton,
            delegate = _delegate;

-(void) dealloc
{
    self.delegate = nil;
    //[_pageNumberLabel release];
}

-(void) closeButtonPressed
{
    [self.adView loadBlankAdWebWiew];
    
    if([UIApplication sharedApplication].statusBarHidden)
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    // if the status bar is visible, makeit dissappear

}

- (void)didPressUpdateButton:(id)sender {
    [self.adView update];
}

-(CGFloat) getCurrentWidth
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGRect screenFrame = [UIApplication sharedApplication].keyWindow.frame;
    
    if(orientation == UIInterfaceOrientationPortrait ||
       orientation == UIInterfaceOrientationPortraitUpsideDown
       || (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1))
    {
        return screenFrame.size.width;
    }
    else
    {
        return screenFrame.size.height;
    }
}

-(CGFloat) getCurrentHeight
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGRect screenFrame = [UIApplication sharedApplication].keyWindow.frame;
    
    if(orientation == UIInterfaceOrientationPortrait ||
       orientation == UIInterfaceOrientationPortraitUpsideDown
       || (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1))
    {
        return screenFrame.size.height;
    }
    else
    {
        return screenFrame.size.width;
    }
}

-(void) setupCloseButton
{
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat maxWidth = [self getCurrentWidth];
    
    aButton.frame = CGRectMake(maxWidth - 10.0 - 60.0, 30.0, 60.0, 28.0);
    [aButton setTitle:NSLocalizedString(@"Close",) forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aButton setTitleColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0] forState:UIControlStateNormal];
//    [aButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    aButton.titleLabel.shadowOffset = CGSizeMake(0, 1);

    [[aButton layer] setCornerRadius:8.0f];
    [[aButton layer] setBackgroundColor:UIColor.blackColor.CGColor];
    [[aButton layer] setMasksToBounds:YES];
    [[aButton layer] setBorderWidth:1.0f];
    //[[aButton layer] setBackgroundColor:[UIColor lightGrayColor].CGColor];
    
    [aButton layer].borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    
//    gradient.frame = aButton.bounds;
//    gradient.colors = @[(id)[[UIColor colorWithRed:(1.0) green:(1.0) blue:(1.0) alpha:1.0] CGColor],
//                       (id)[[UIColor colorWithRed:(0.847058) green:(0.847058) blue:(0.847058) alpha:1.0] CGColor],
//                       (id)[[UIColor colorWithRed:(0.729411) green:(0.729411) blue:(0.729411) alpha:1.0] CGColor]];
//    [[aButton layer] insertSublayer:gradient atIndex:0];


[aButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:aButton];
    self.closeButton = aButton;
}

- (void)configureUpdateButton
{
    self.updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat maxWidth = [self getCurrentWidth];
    self.updateButton.frame = CGRectMake(maxWidth - 10.0 - 60.0, 30.0, 60.0, 28.0);
    self.updateButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    [self.updateButton setTitleColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0] forState:UIControlStateNormal];
    [[self.updateButton layer] setCornerRadius:8.0f];
    [[self.updateButton layer] setBackgroundColor:UIColor.blackColor.CGColor];
    [[self.updateButton layer] setMasksToBounds:YES];
    [[self.updateButton layer] setBorderWidth:1.0f];
    [self.updateButton layer].borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
    
    [self.updateButton setTitle:@"Update" forState:UIControlStateNormal];
    [self.updateButton addTarget:self action:@selector(didPressUpdateButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.updateButton];
    self.updateButton.frame = CGRectMake(CGRectGetMinX(self.closeButton.frame), CGRectGetMaxY(self.closeButton.frame) + 10, CGRectGetWidth(self.updateButton.bounds), CGRectGetHeight(self.updateButton.bounds));
    self.updateButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;
    // remove the status bar if needed
    //if([UIApplication sharedApplication].statusBarHidden == NO)
    //    [UIApplication sharedApplication].statusBarHidden = YES;
    //self.wantsFullScreenLayout = YES;
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = [UIColor greenColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

-(CGRect) getInterstitialAdFrame
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIInterfaceOrientationPortrait ||
       orientation == UIInterfaceOrientationPortraitUpsideDown
       || (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
       )
    {
        //NSLog(@"REQUEST AN AD WITH RECT =%@", NSStringFromCGRect([UIApplication sharedApplication].keyWindow.bounds));

        return [UIApplication sharedApplication].keyWindow.bounds;
    }
    else
    {
        //NSLog(@"REQUEST AN AD WITH RECT =%@", NSStringFromCGRect(CGRectMake(0.0, 0.0, [UIApplication sharedApplication].keyWindow.frame.size.height, [UIApplication sharedApplication].keyWindow.frame.size.width)));
        return CGRectMake(0.0, 0.0, [UIApplication sharedApplication].keyWindow.frame.size.height, [UIApplication sharedApplication].keyWindow.frame.size.width);
    }
}

- (void)requestInterstitialAdWithZone:(NSString *)zone
{
    CGRect frame = [self getInterstitialAdFrame];
    NSLog(@"interstitial frame = %@", NSStringFromCGRect(frame));
    MadsAdView *adView= [[MadsAdView alloc] initWithFrame:frame
                                                      zone:zone
                                                  delegate:self];
//    adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight; //| UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:adView];
     self.adView = adView;
    bool testServerMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"testservermode"] boolValue];
    self.adView.testMode           = testServerMode;

    //self.adView.updateTimeInterval = 5;
    
    // adjust the view to hold hte entire ad
    self.view.frame = frame;
    
//    self.view.backgroundColor = [UIColor redColor];
//    self.adView.backgroundColor = [UIColor greenColor];
    // make sure the close button is on top
    if(!self.closeButton) {
        [self setupCloseButton];
    }
    
    if (!self.updateButton) {
        [self configureUpdateButton];
    }
    
    [self.view bringSubviewToFront:self.closeButton];
}

// MadsAdViewDelegate
- (void)willReceiveAd:(id)sender
{
    
}

- (void)didReceiveAd:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didReceiveAd:)])
        [self.delegate didReceiveAd:self];
    //NSLog(@"RECEIVED AN AD WITH RECT =%@", NSStringFromCGRect(self.adView.frame));
    //NSLog(@"INTERSTITIAL AD VIEW CONTROLLER SIZE = %@", NSStringFromCGRect(self.view.frame));
}

- (void)didFailToReceiveAd:(id)sender withError:(NSError*)error
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didFailToReceiveAd:)])
        [self.delegate didFailToReceiveAd:self];
}

- (void)adWillStartFullScreen:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(adWillStartFullScreen:)])
        [self.delegate adWillStartFullScreen:self];
}

- (void)adDidEndFullScreen:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(adDidEndFullScreen:)])
        [self.delegate adDidEndFullScreen:self];    
}

@end
