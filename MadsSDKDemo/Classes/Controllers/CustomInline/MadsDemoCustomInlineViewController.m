//
//  MadsDemoFirstViewController.m
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MadsDemoCustomInlineViewController.h"
#import "AdConfigView.h"
#import "ZoneConstants.h"
#import <MadsSDK/MadsSDK.h>
// private API
#import "MadsAdDescriptor.h"
#import "MadsNotificationCenter.h"

#define kAdSizeHeightiPhone 54.0
#define kAdSizeHeightiPad 90.0
#define kAdSizeHeightiPad2 250.0
#define kAdOffsetFromBottomPortrait 424 // bottom = 1024 - 424 + 250 // 850
#define kAdOffsetFromBottomLandScape 380 // bottom = 768 - 380 + 250 // 638

static float adY;

@interface MadsDemoCustomInlineViewController()

@property (strong, nonatomic) UIImageView *arrowImage;
@property (assign, nonatomic) BOOL isExpanded;

@end

@implementation MadsDemoCustomInlineViewController

@synthesize adView    = _adView,
            adView2   = _adView2,
            isResized = _isResized;


#pragma mark - View lifecycle

- (void)loadView {
    [super loadView];
    self.view = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UIDevice.currentDevice.systemVersion.floatValue >= 7.f) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    [self.adConfigView showAdSizeControls];
    
    UITapGestureRecognizer *tapEndEditing = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(endEditing)];
    [self.view addGestureRecognizer:tapEndEditing];
    [self.adConfigView addGestureRecognizer:tapEndEditing];
}

#pragma mark - Recognizer

- (void)endEditing {
    [self.view endEditing:YES];
}

- (void)setupAdPosition:(CGFloat)yPos
{
    if (self.adView) {
        return;
    }
    
    CGSize maxSize = self.adConfigView.maxSize;
    CGSize minSize = self.adConfigView.minSize;
    self.adView = [[MadsAdView alloc] initWithFrame:CGRectMake(0.f,
                                                               yPos,
                                                               maxSize.width,
                                                               maxSize.height)
                                               zone:self.currentZone
                                           delegate:self];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.adConfigView updateTitle:@"iPhone ad example : "];
    } else {
        [self.adConfigView updateTitle:@"iPad ad example : "];
    }
    [self.adConfigView updateTitle:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"iPhone ad example : "
                                  : @"iPad ad example : "];

    // show the zone in the adconfig view
    bool testServerMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"testservermode"] boolValue];
    self.adView.testMode           = testServerMode;
    [self.adConfigView updateTestServerModeLabel];
    
    [self.adConfigView updateZone:self.currentZone];
    self.view.autoresizesSubviews = YES;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;
    self.adView.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
    self.adView.updateTimeInterval = 0.0;
    self.adView.madsAdType         = MadsAdTypeInline;
    adY = yPos;
//    [self.view insertSubview:self.adView belowSubview:self.gridView];
    self.adView.minSize = minSize;
    [self.view addSubview:self.adView];
    //self.adView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    self.isResized = NO;
    [self.adConfigView spinnerOn];
}


#pragma mark - Arrow Image

- (void)addArrowImageView {
    [self.arrowImage removeFromSuperview];
    self.arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"doubleArrow"]];
    self.arrowImage.frame = CGRectMake(CGRectGetMidX(self.view.frame) - 50, CGRectGetMaxY(self.adConfigView.frame) + 20, 100, 100);
    [self.view addSubview:self.arrowImage];
}

- (void)removeArrowImageView {
    [self.arrowImage removeFromSuperview];
    self.arrowImage = nil;
}


#pragma mark - Private methods

- (CGFloat)getAdViewY:(UIInterfaceOrientation)toInterfaceOrientation {
    CGFloat adY = 0.f;
    switch (self.adConfigView.position) {
        case MadsAdPositionCenter:
            adY = self.adConfigView.frame.size.height;
            break;
        case MadsAdPositionBottom:
            if (UIApplication.sharedApplication.statusBarOrientation != toInterfaceOrientation) {
                adY = self.view.frame.size.width - self.adView.frame.size.height -
                self.tabBarController.tabBar.frame.size.height - 20.f; // ???: magic 20
            } else {
                adY = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.adView.frame);
            }
            break;
        case MadsAdPositionScrollingDown:
            adY = CGRectGetHeight(self.view.frame);//CGRectGetHeight(self.view.frame) * 1.5f - CGRectGetHeight(self.adView.frame);
            break;
        default:
            break;
    }
    return adY;
}

- (void)resetAdWidth
{
    if (self.isResized) {
        return; // do not touch the ad width when in resized mode
    }
    NSLog(@"Adview frame before reset is now %@", NSStringFromCGRect(self.adView.frame));
    self.adView.frame = CGRectMake(0,
                                   CGRectGetMinY(self.adView.frame),
                                   CGRectGetWidth(UIApplication.sharedApplication.keyWindow.frame),
                                   CGRectGetHeight(self.adView.frame));
    NSLog(@"Adview frame reset is now %@", NSStringFromCGRect(self.adView.frame));
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGPoint center = self.adView.center;
//        center.x = CGRectGetMidX(UIApplication.sharedApplication.keyWindow.frame);
//        self.adView.center = center;
//    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // as the adviews are set up using the key window frame sizes we need to wait for
    // viewWillAppear to set them up. Otherwise the keywindow frame will be 0,0,0,0
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.currentZone   = kiPhoneInlineZone;
    } else {
        self.currentZone   = kiPadInlineZone; // just for testing
    }
    adY = 0.0;// default for top

    if (!self.adView) {
        [self setupAdPosition:0.f];
    }
//    [self.view bringSubviewToFront:self.adConfigView]; // ???: necessary?
 //   self.view.backgroundColor = UIColor.redColor;
    [self resetAdWidth];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    if (self.isResized) {
        return; // do not mess with ads in Resized mode
    }
    // we need to do 2 things
    // 1) set the correct y coordinate of the ad, so that it appears on the right vertical screen position
    // 2) reset the width of the ad to the width of the orientation
    adY = [self getAdViewY:UIApplication.sharedApplication.statusBarOrientation];
    NSLog(@"didRotateFromInterfaceOrientation: adY = %f", adY);
    // 1)
    self.adView.frame = CGRectMake(self.adView.frame.origin.x,
                                   adY,
                                   self.adView.frame.size.width,
                                   self.adView.frame.size.height);
    
    // 2)
    [self updateScrollContentSize];
    [self resetAdWidth];
    [self.adConfigView setupADSizeUI:UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)];
    if (!self.isExpanded) {
        [self updateAdAfterRotation];
    }
    [self updateScrollContentSize];
    [self resetAdWidth];
    
    if (self.adConfigView.position == MadsAdPositionBottom) {
        CGRect frame = self.adView.frame;
        frame.origin.y = CGRectGetMaxY(self.view.frame) - CGRectGetHeight(self.adView.frame);
        self.adView.frame = frame;
    }
}

- (void)updateAdAfterRotation {
    if (self.isResized) {
        return; // do not mess with ads in Resized mode
    }
    // we need to do 2 things
    // 1) set the correct y coordinate of the ad, so that it appears on the right vertical screen position
    // 2) reset the width of the ad to the width of the orientation
    adY = [self getAdViewY:UIApplication.sharedApplication.statusBarOrientation];
    
    NSLog(@"didRotateFromInterfaceOrientation: adY = %f", adY);
    // 1)
    self.adView.frame = CGRectMake(self.adView.frame.origin.x,
                                   adY,
                                   self.adView.frame.size.width,
                                   self.adView.frame.size.height);
    // 2)
    [self updateScrollContentSize];
    [self resetAdWidth];
}

- (void)updateAds
{
    NSLog(@"releasing an ad");
    self.adConfigView.statusLabel.text = NSLocalizedString(@"Loading ad...",);
    // we create a new adview for test purposes only
    [self.adView removeFromSuperview];
    self.adView = nil;
    [self setupAdPosition:[self getAdViewY:UIApplication.sharedApplication.statusBarOrientation]];
    [self.adConfigView spinnerOn];
}

#pragma mark - ScrollView

- (void)updateScrollContentSize {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    if (CGRectGetMaxY(self.adConfigView.frame) > CGRectGetMaxY(self.view.frame))  {
        [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame), CGRectGetMaxY(self.adConfigView.frame))];
    } else if (CGRectGetMaxY(self.adView.frame) > CGRectGetMaxY(self.view.frame)) {
        if (self.adConfigView.position == MadsAdPositionScrollingDown) {
            [self addArrowImageView];
        }
        [scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.frame), CGRectGetMaxY(self.adView.frame))];
    } else {
        [self removeArrowImageView];
        [scrollView setContentSize:self.view.frame.size];
    }
}

#pragma mark - AdConfigViewDelegate

- (void)resetButtonPressed:(id)sender {
    self.adConfigView.statusLabel.text = NSLocalizedString(@"Zone reset...",);

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.currentZone   = kiPhoneInlineZone;
        self.adView.zone   = kiPhoneInlineZone;
    } else {
        self.currentZone   = kiPadInlineZone2;
        self.adView.zone   = kiPadInlineZone2;
    }
    [self.adConfigView updateZone:self.currentZone];
}

- (void)refreshButtonPressed:(id)sender {
    [self removeArrowImageView];
    [self placeConfigWindowBelowFrame:CGRectZero callbackBlock:^{
        [self updateAds];
    }];
//    [self placeConfigWindowBelowFrame:CGRectZero];// animate the adconfig view back up
//    [self performSelector:@selector(updateAds)
//               withObject:nil
//               afterDelay:0.3]; // !!!: Config view animation delay? Replace with block
}

- (void)htmlEntered:(id)sender {
    // we need to load the html instead of loading html from the server
    // recipe
    // 1. convert to NSData
    // 2. use AdDescriptor class (private)
    // 3. post notification
    AdConfigView *configView = (AdConfigView *)sender;
    NSData *data = [[configView getHTML] dataUsingEncoding:NSUTF8StringEncoding];
    __weak MadsAdDescriptor* adDescriptor = [MadsAdDescriptor descriptorFromContent:data
                                                                           frameSize:self.adView.frame.size];
    __block typeof(self) this = self;
     dispatch_async(dispatch_get_main_queue(), ^{
        [MadsNotificationCenter.sharedInstance postNotificationName:@"Start Ad Display"
                                                             object:[@{ @"adView"     : this.adView,
                                                                         @"descriptor" : adDescriptor }
                                                                      mutableCopy]
                                                           userInfo:nil];
    });
}

- (void)bannerPositionPressed:(id)sender
{
    UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
    adY = [self getAdViewY:orientation];
    NSLog(@"bannerPositionPressed: adY = %f", adY);
    // the safest thing to do now is remove the current banner
    // and set up a new one with the correct frame
    [self.adView removeFromSuperview];
    self.adView = nil;
    [self setupAdPosition:adY];
    [self.adConfigView spinnerOn];
    self.adConfigView.statusLabel.text = NSLocalizedString(@"Loading ad...",);
    
    if (self.adConfigView.position == MadsAdPositionTop) {
        [self placeConfigWindowBelowFrame:self.adView.frame];
    } else {
        [self placeConfigWindowAboveFrame:self.adView.frame];
    }
    [self updateScrollContentSize];
}

- (void)animationSelected:(id)sender
{
    self.adView.animationType = ((AdConfigView *)sender).animationType;
    [self.adView update];
}

#pragma mark - MadsAdViewDelegate

- (void)willReceiveAd:(id)sender
{
    self.adConfigView.statusLabel.text = @"Loading ad...";
}

- (void)didReceiveAd:(id)sender
{
    self.adConfigView.statusLabel.text = @"Ad loaded";
    [self.adConfigView spinnerOff];
    MadsAdView *adView = (MadsAdView *)sender;
    
//    NSLog(@"didReceiveAd: adY = %f", adY);
//    NSLog(@"didReceiveAd: ad frame  = %@", NSStringFromCGRect(self.adView.frame));
    
    if (adView == self.adView) {
        if (self.adConfigView.position == MadsAdPositionTop) {
            [self placeConfigWindowBelowFrame:self.adView.frame];
        } else {
            [self placeConfigWindowAboveFrame:self.adView.frame];
        }
       // self.view.backgroundColor = [UIColor redColor];
    }
    
    if (self.adConfigView.position == MadsAdPositionBottom) {
        CGRect frame = self.adView.frame;
        frame.origin.y = CGRectGetMaxY(self.view.frame) - CGRectGetHeight(self.adView.frame);
        self.adView.frame = frame;
    }
    
    [self updateScrollContentSize];
}

- (void)didFailToReceiveAd:(id)sender
                 withError:(NSError *)error
{
    self.adConfigView.statusLabel.text = @"No ad available";
    [self.adConfigView spinnerOff];    
}

- (void)zoneChanged:(id)sender
{
    NSLog(@"ZONE CHANGED: %@", [self.adConfigView currentZone]);
    [self updateZone:[self.adConfigView currentZone]];
}

- (void)adWillStartFullScreen:(id)sender // appstor | site | video
{
    NSLog(@"adWillStartFullScreen now");
}

- (void)adDidEndFullScreen:(id)sender
{
    NSLog(@"adDidEndFullScreen now");
}

- (void)adWillExpandFullScreen:(id)sender
{
    NSLog(@"adWillExpandFullScreen now");
    self.isExpanded = YES;
}

- (void)adDidCloseExpandFullScreen:(id)sender
{
    NSLog(@"adDidCloseExpandFullScreen now");
    
    self.isExpanded = NO;
    if (self.adConfigView.position == MadsAdPositionTop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect frame = self.adConfigView.frame;
            frame.origin.y = CGRectGetMaxY(self.adView.frame);
            self.adConfigView.frame = frame;
            [self updateScrollContentSize];
           // [self resetAdWidth];
        });
        
    }
    
    [self updateScrollContentSize];
    [self resetAdWidth];
}

- (void)adWillOpenVideoFullScreen:(id)sender
{
    NSLog(@"adWillOpenVideoFullScreen now");
}

- (void)adDidCloseVideoFullScreen:(id)sender
{
    NSLog(@"adDidCloseVideoFullScreen now");
}

- (void)adWillOpenMessageUIFullScreen:(id)sender
{
    NSLog(@"adWillOpenMessageUIFullScreen now");
}

- (void)adDidCloseMessageUIFullScreen:(id)sender
{
    NSLog(@"adDidCloseMessageUIFullScreen now");
}

- (void)adWillResize:(id)sender
{
    NSLog(@"The ad will be resized shortly, frame = %@", NSStringFromCGRect(((MadsAdView *)sender).frame));
}

- (void)adDidResize:(id)sender
{
    MadsAdView *adView = sender;
    NSLog(@"The ad did resize, frame = %@", NSStringFromCGRect(adView.frame));
    self.isResized = YES;
    if (self.adConfigView.position == MadsAdPositionTop) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CGRect frame = self.adConfigView.frame;
            frame.origin.y = CGRectGetMaxY(self.adView.frame);
            self.adConfigView.frame = frame;
            [self updateScrollContentSize];
            

        });
        
    }
    
    if (self.adConfigView.position == MadsAdPositionBottom) {
        CGRect frame = self.adView.frame;
        frame.origin.y = CGRectGetMaxY(self.view.frame) - CGRectGetHeight(self.adView.frame);
        self.adView.frame = frame;
    }
    // [self resetAdWidth];
}

- (void)adDidUnresizeAd:(id)sender
{
    MadsAdView *adView = sender;
    self.isResized = NO;
//    adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    if (self.adConfigView.position == MadsAdPositionTop) {
        [self placeConfigWindowBelowFrame:adView.frame];
    } else {
        [self placeConfigWindowAboveFrame:adView.frame];
    }
}

//- (BOOL)adShouldOpen:(id)sender withUrl:(NSURL *)url
//{
//    NSLog(@"~~~~> url %@", [url absoluteString]);
//    return YES;
//}

@end
