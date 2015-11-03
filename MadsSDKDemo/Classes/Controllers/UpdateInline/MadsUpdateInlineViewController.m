//
//  MadsUpdateInlineViewController.m
//  MadsSDKDemo
//
//  Created by Yevhen Herasymenko on 8/27/15.
//
//

#import "MadsUpdateInlineViewController.h"
#import <MadsSDK/MadsSDK.h>

@interface MadsUpdateInlineViewController ()

@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *updateTimeButton;
@property (weak, nonatomic) IBOutlet UIView *settingsView;
@property (weak, nonatomic) IBOutlet UIView *adViewBackground;
@property (weak, nonatomic) IBOutlet UITextField *timeIntervalField;

@property (strong, nonatomic) MadsAdView *adView;

- (IBAction)update:(id)sender;
- (IBAction)updateTimeInterval:(id)sender;

@end

@implementation MadsUpdateInlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adView = [[MadsAdView alloc] initWithFrame:CGRectZero
                                               zone:[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"3327876051" : @"3336754051"
                                           delegate:self];
    [self.adViewBackground addSubview:self.adView];
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self setupInterface];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEditing)];
    [self.adViewBackground addGestureRecognizer:tap];
}

- (void)setupInterface {
    self.updateButton.layer.masksToBounds = YES;
    self.updateButton.layer.cornerRadius = 5;
    self.updateButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.updateButton.layer.borderWidth = 1;
    
    self.updateTimeButton.layer.masksToBounds = YES;
    self.updateTimeButton.layer.cornerRadius = 5;
    self.updateTimeButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.updateTimeButton.layer.borderWidth = 1;
    
    self.adViewBackground.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.settingsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //self.updateButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.updateTimeButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    self.timeIntervalField.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
}

- (void)endEditing {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)update:(id)sender {
    [self.adView update];
}

- (IBAction)updateTimeInterval:(id)sender {
    NSInteger time = [self.timeIntervalField.text integerValue];
    self.adView.updateTimeInterval = time;
}

- (void)adDidCloseExpandFullScreen:(id)sender
{
    CGRect frame = self.adViewBackground.frame;
    frame.size.width = self.view.frame.size.width;
    self.adViewBackground.frame = frame;
}

@end
