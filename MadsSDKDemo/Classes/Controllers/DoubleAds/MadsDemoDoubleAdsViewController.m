//
//  MadsDemoDoubleAdsViewController.m
//  MadsSDKDemo
//
//  Created by VimSolution on 7/3/15.
//
//

#import "MadsDemoDoubleAdsViewController.h"
#import "ZoneConstants.h"
#import <MadsSDK/MadsSDK.h>
#import "MadsAdCell.h"

@interface MadsDemoDoubleAdsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MadsAdView *overlayView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *updateInlineButton;
@property (weak, nonatomic) IBOutlet UIButton *updateOverlayButton;

@property (strong, nonatomic) NSMutableArray *inlineBanners;

@property (assign, nonatomic) BOOL updating;
@property (assign, nonatomic) BOOL isExpanded;

- (IBAction)updateInline:(id)sender;
- (IBAction)updateOverlay:(id)sender;

@end

@implementation MadsDemoDoubleAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inlineBanners = [[NSMutableArray alloc] init];
    [self.tableView registerClass:[MadsAdCell class] forCellReuseIdentifier:@"adCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
    [self setupOverlay];
}

- (void)setupOverlay {
    NSString *overlayZone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? kiPadOverlayZone : kiPhoneOverlayZone;
    self.overlayView = [[MadsAdView alloc] initWithFrame:CGRectZero zone:overlayZone delegate:self];
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.overlayView.madsAdType       = MadsAdTypeOverlay;
    [self.view addSubview:self.overlayView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0, 60, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 110);
    self.updateInlineButton.layer.masksToBounds = YES;
    self.updateOverlayButton.layer.masksToBounds = YES;
    self.updateInlineButton.layer.borderColor = self.updateInlineButton.titleLabel.textColor.CGColor;
    self.updateOverlayButton.layer.borderColor = self.updateOverlayButton.titleLabel.textColor.CGColor;
    self.updateInlineButton.layer.borderWidth = 1.0;
    self.updateOverlayButton.layer.borderWidth = 1.0;
    self.updateInlineButton.layer.cornerRadius = CGRectGetHeight(self.updateInlineButton.frame)/4;
    self.updateOverlayButton.layer.cornerRadius = CGRectGetHeight(self.updateOverlayButton.frame)/4;
    self.updateInlineButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.updateOverlayButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self updateInlineBanners];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)updateInline:(id)sender {
    // [self.inlineView update];
//    [self removeAdViewFromView:self.view];
    if (!_updating) {
        self.updating = YES;
        for (MadsAdView *adView in self.inlineBanners) {
            [adView removeFromSuperview];
        }
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [self.inlineBanners removeAllObjects];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            self.updating = NO;
        });
    }
}

- (IBAction)updateOverlay:(id)sender {
    [self setupOverlay];
    
}

- (void)removeAdViewFromView:(UIView *)view {
    for(UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[MadsAdView class]]) {
            [subview removeFromSuperview];
        } else {
            [self removeAdViewFromView:subview];
        }
    }
}

#pragma mark - table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%5 == 1) {
        MadsAdView *adView = self.inlineBanners.count > indexPath.row/5 ? (MadsAdView *)[self.inlineBanners objectAtIndex:indexPath.row/5] : nil;
        return (!adView || adView.hidden) ? 0 : CGRectGetHeight(adView.frame);
    } else {
        return 51;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 51;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row%5 == 1) {
        cell = [self adCellForIndexPath:indexPath];
    } else {
        cell = [self textCellForIndexPath:indexPath];
    }
    return cell;
}

- (UITableViewCell *)textCellForIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"textCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"textCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Text line - %ld", (long)indexPath.row];
    return cell;
}

- (UITableViewCell *)adCellForIndexPath:(NSIndexPath *)indexPath {
    MadsAdCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"adCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[MadsAdCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"adCell"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (self.inlineBanners.count > indexPath.row/5) {
        cell.adView = [self.inlineBanners objectAtIndex:indexPath.row/5];
        CGRect rect = cell.adView.frame;
        rect.size.width = CGRectGetWidth(self.tableView.frame);
        cell.adView.frame = rect;
        if (cell.adView.hidden || CGRectGetHeight(cell.adView.frame) <= 0) {
            NSString *inlineZone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? kiPadInlineZone : kiPhoneInlineZone;
            cell.adView = [[MadsAdView alloc] initWithFrame:CGRectZero zone:inlineZone delegate:self];
            cell.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            self.inlineBanners[indexPath.row/5] = cell.adView;
            cell.adView.hidden = YES;
        }
        
    } else {
        NSString *inlineZone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? kiPadInlineZone : kiPhoneInlineZone;
        cell.adView = [[MadsAdView alloc] initWithFrame:CGRectZero zone:inlineZone delegate:self];
        cell.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.inlineBanners addObject:cell.adView];
        cell.adView.hidden = YES;
    }
    
    [cell.contentView addSubview:cell.adView];
    cell.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    return cell;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if ([[UIApplication sharedApplication] keyWindow] == self.view.window && !self.isExpanded) {
        [self updateInlineBanners];
    }
}

- (void)updateInlineBanners {
    for (MadsAdView *adView in self.inlineBanners) {
        CGRect rect = adView.frame;
        rect.size.width = CGRectGetWidth(self.tableView.frame);
        adView.frame = rect;
    }
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void)didReceiveAd:(id)sender {
    MadsAdView *adView = (MadsAdView *)sender;
    adView.hidden = NO;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

- (void)adWillExpandFullScreen:(id)sender {
    NSLog(@"adWillExpandFullScreen now");
    self.isExpanded = YES;
}

- (void)adDidCloseExpandFullScreen:(id)sender {
    [self updateInlineBanners];
}


@end
