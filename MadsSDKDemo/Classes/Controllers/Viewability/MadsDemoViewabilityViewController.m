//
//  MadsDemoViewabilityViewController.m
//  MadsSDKDemo
//
//  Created by Yevhen Herasymenko on 11/30/15.
//
//

#import "MadsDemoViewabilityViewController.h"
#import <MadsSDK/MadsSDK.h>

@interface MadsDemoViewabilityViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) MadsAdView *adView;

@end

@implementation MadsDemoViewabilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.adView = [[MadsAdView alloc] initWithFrame:CGRectZero zone:@"3327876051" delegate:self];
    bool testServerMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"testservermode"] boolValue];
    self.adView.testMode = testServerMode;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo:) name:@"Viewability change" object:nil];
    self.view.autoresizesSubviews = YES;
    self.view.translatesAutoresizingMaskIntoConstraints = YES;

    CGRect frame = self.tableView.frame;
    frame.size.width = self.view.frame.size.width;
    frame.size.height = self.view.frame.size.height - CGRectGetMaxY(self.infoLabel.frame);
    self.tableView.frame = frame;
  //  self.tableView.autoresizingMask   = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)updateInfo:(NSNotification *)notification {
    NSDictionary *info   = [notification object];
    self.infoLabel.text = [info[@"key"] description];
}

#pragma mark - Action

- (IBAction)close:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 10) {
        [cell addSubview:self.adView];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 10) {
        return CGRectGetHeight(self.adView.frame);
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 10) {
        self.infoLabel.text = @"0";
        [self.adView removeFromSuperview];
    }
}

#pragma mark - Ad View

- (void)didReceiveAd:(id)sender {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void)dealloc {
    NSLog(@"Controller dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
