//
//  MadsAdModalViewController.m
//  MadsSDKDemo
//
//  Created by VimSolution on 7/9/15.
//
//

#import "MadsAdModalViewController.h"
#import <MadsSDK/MadsAdView.h>
//#import <MadsAdMobAdapter/MadsAdMobAdapter.h>

@interface MadsAdModalViewController ()

@property (nonatomic, strong) MadsAdView *adView;

@end

@implementation MadsAdModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    [super loadView];
 //   [MADSAdMobConfigurator test];
    
    CGFloat maxX = CGRectGetWidth(self.view.bounds);
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    closeButton.frame = CGRectMake(maxX - 100 - 10, 150, 100, 44);
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(buttonCloseTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.adView = [[MadsAdView alloc] initWithFrame:CGRectMake(0, 0, 320, 320) zone:@"3336754051" delegate:self];
    self.adView.updateTimeInterval = 1;
    [self.view addSubview:self.adView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonCloseTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
