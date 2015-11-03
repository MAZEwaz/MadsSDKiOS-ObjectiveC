//
//  MadsTabBarController.m
//  MadsDemo
//
//  Created by Vim Solution on 7/10/14.
//
//

#import "MadsTabBarController.h"
#import "MadsDemoCustomInlineViewController.h"

@interface MadsTabBarController ()<UITabBarControllerDelegate>

@end

@implementation MadsTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (UIDevice.currentDevice.systemVersion.floatValue >= 7.f) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    self.customizableViewControllers = nil;

    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToTab:) name:@"goToTab" object:nil];

//    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
//    {
//        NSMutableArray *newItems = [[NSMutableArray alloc] init];
//        for(int i=0; i<[NSMutableArray arrayWithArray:self.viewControllers].count; i++)
//        {
//            UIViewController *vc = [[NSMutableArray arrayWithArray:self.viewControllers] objectAtIndex:i];
//            if(![vc isMemberOfClass:[MadsDemoCustomInlineViewController class]])
//            {
//                [newItems addObject:vc];
//            }
//        }
//        self.viewControllers = newItems;
//    }
//    self.view.backgroundColor = UIColor.blueColor;
//    if([self canPerformAction:@selector(setEdgesForExtendedLayout:) withSender:self]) {
//        [self setEdgesForExtendedLayout:UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight];
//    }

    //    return;
//    if (UIDevice.currentDevice.systemVersion.floatValue >= 7.f) {
//        CGRect viewFrame = self.view.frame;
//        CGFloat topBarOffset = UIApplication.sharedApplication.statusBarFrame.size.height;
//        viewFrame.origin.y = topBarOffset;
//        viewFrame.size.height = UIScreen.mainScreen.bounds.size.height - topBarOffset;
//        self.view.frame = viewFrame;
//    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self updateFrame];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [self updateFrame];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
//    [self updateFrame];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

#pragma mark - Private methods

- (void)updateFrame
{
    if (UIDevice.currentDevice.systemVersion.floatValue >= 7.f) {

        CGRect windowFrame = [UIScreen mainScreen].bounds;

//        if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
//            size = CGSizeMake(size.height, size.width);
//        }

        if (UIApplication.sharedApplication.statusBarHidden == NO) {
            CGFloat statusBarHeight = MIN(UIApplication.sharedApplication.statusBarFrame.size.width,
                                          UIApplication.sharedApplication.statusBarFrame.size.height);
            if (UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation)) {
                windowFrame.size.width -= statusBarHeight;
                windowFrame.origin.x = statusBarHeight;
            } else {
                windowFrame.size.height -= statusBarHeight;
                windowFrame.origin.y = statusBarHeight;
            }
        }

        UIWindow *window = [[[UIApplication sharedApplication] windows]
                            lastObject];
        window.clipsToBounds = YES;
        window.frame = windowFrame;
        self.view.frame = window.bounds;
    }
}

- (void) goToTab:(NSNotification*)notification
{
    NSDictionary *info    = [notification object];
    NSString   *tabName  =  info[@"tab"];
    int tabIdx = -1;
    
    if([tabName isEqualToString:@"inline"])
        tabIdx = 0;
    else if([tabName isEqualToString:@"overlay"])
        tabIdx = 1;
    else if([tabName isEqualToString:@"interstitial"])
        tabIdx = 2;
    else if([tabName isEqualToString:@"settings"])
        tabIdx = 7;
    
    if(tabIdx > -1)
        [self setSelectedIndex:tabIdx];
}

@end
