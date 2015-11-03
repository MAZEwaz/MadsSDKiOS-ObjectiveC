//
//  MadsIgnoreLinkViewController.m
//  MadsSDKDemo
//
//  Created by Yevhen Herasymenko on 8/27/15.
//
//

#import "MadsIgnoreLinkViewController.h"
#import <MadsSDK/MadsSDK.h>

@interface MadsIgnoreLinkViewController ()

@property (weak, nonatomic) IBOutlet UIButton *blockButton;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UIView *adViewBackground;

@property (assign, nonatomic) BOOL isIgnoreLink;

@property (strong, nonatomic) MadsAdView *adView;

- (IBAction)block:(id)sender;
- (IBAction)update:(id)sender;

@end

@implementation MadsIgnoreLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adView = [[MadsAdView alloc] initWithFrame:CGRectMake(0.f,
                                                               0,
                                                               CGRectGetWidth(UIApplication.sharedApplication.keyWindow.frame),
                                                               CGRectGetHeight(UIApplication.sharedApplication.keyWindow.frame))
                                               zone:@"2490392373"
                                           delegate:self];
    [self.adViewBackground addSubview:self.adView];
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    [self setupInterface];
}

- (void)setupInterface {
    self.blockButton.layer.masksToBounds = YES;
    self.blockButton.layer.cornerRadius = 5;
    self.blockButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.blockButton.layer.borderWidth = 1;
    
    self.updateButton.layer.masksToBounds = YES;
    self.updateButton.layer.cornerRadius = 5;
    self.updateButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.updateButton.layer.borderWidth = 1;
    
    self.adViewBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.settingsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.blockButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.updateButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)block:(id)sender {
    self.isIgnoreLink = !self.isIgnoreLink;
    NSString *title = self.isIgnoreLink ? @"Unblock redirection" : @"Block redirection";
    [self.blockButton setTitle:title forState:UIControlStateNormal];
}

- (IBAction)update:(id)sender {
    [self.adView update];
}

- (NSArray *)adRequestsToIgnore {
    if (self.isIgnoreLink) {
        return @[ @{ @"URLPrefix": @"itms-apps://itunes", @"NavigationTypes": @[ @"Other" ] },
                  @{ @"URLPrefix": @"https://itunes.apple.com", @"NavigationTypes": @[ @"Other" ] },
                  @{ @"URLPrefix": @"http://itunes.apple.com", @"NavigationTypes": @[ @"Other" ] },
                  @{ @"URLPrefix": @"https://itunes.com", @"NavigationTypes": @[ @"Other" ] },
                  @{ @"URLPrefix": @"http://itunes.com", @"NavigationTypes": @[ @"Other" ] },
                  @{ @"URLPrefix": @"https://www.itunes.com", @"NavigationTypes": @[ @"Other" ] },
                  @{ @"URLPrefix": @"http://www.itunes.com", @"NavigationTypes": @[ @"Other" ] },
                  @{ @"URLPrefix": @"itms-appss://", @"NavigationTypes": @[ @"Other" ] }];
    } else {
        return nil;
    }
}



@end
