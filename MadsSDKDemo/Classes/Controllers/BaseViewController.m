//
//  BaseViewController.m
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import "AdConfigView.h"
#import "CreativeViewController.h"


static const NSTimeInterval kAnimationDuration = 0.3;

@implementation MadsDemoGridView

// -------------------------------------------------------------------------------
// Used for drawing the grids ontop of the view port
// -------------------------------------------------------------------------------
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, self.color.CGColor);
    
    // ---------------------------
    // Drawing column lines
    // ---------------------------
    
    // calculate column width
    CGFloat columnWidth = self.cellSize;
    int numberOfColumns = self.frame.size.width / columnWidth;
    
    for(int i = 1; i <= numberOfColumns; i++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = columnWidth * i;
        startPoint.y = 0.0f;
        
        endPoint.x = startPoint.x;
        endPoint.y = self.frame.size.height;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
    
    // ---------------------------
    // Drawing row lines
    // ---------------------------
    
    // calclulate row height
    CGFloat rowHeight = self.cellSize;
    int numberOfRows = self.frame.size.height / rowHeight;
    
    for(int j = 1; j <= numberOfRows; j++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = 0.0f;
        startPoint.y = rowHeight * j;
        
        endPoint.x = self.frame.size.width;
        endPoint.y = startPoint.y;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
}

@end


@implementation BaseViewController

@synthesize adConfigView = _adConfigView,
            currentZone  = _currentZone;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        self->_showJSON = NO;
        self->_hideGrid = false;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        self->_showJSON = NO;
        self->_hideGrid = false;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  We set it to a default width and height,
    //    but the view itself is smarter and
    //    takes full width for iPhone and iPad.
    
    self.gridView = [[MadsDemoGridView alloc] init];
    self.gridView.backgroundColor = [UIColor clearColor];
    float maxSize = UIApplication.sharedApplication.keyWindow.frame.size.height > UIApplication.sharedApplication.keyWindow.frame.size.width ?
    UIApplication.sharedApplication.keyWindow.frame.size.height : UIApplication.sharedApplication.keyWindow.frame.size.width;
    self.gridView.frame = CGRectMake(0, 0,
                                maxSize,
                                maxSize);
    self.gridView.cellSize = 10;
    self.gridView.color = [UIColor clearColor];
    [self.view addSubview:self.gridView];
    [self.gridView setNeedsDisplay];
    
    self.gridView2 = [[MadsDemoGridView alloc] init];
    self.gridView2.backgroundColor = [UIColor clearColor];
    self.gridView2.frame = CGRectMake(0, 0,
                                 maxSize,
                                 maxSize);
    self.gridView2.cellSize = 50;
    self.gridView2.color = [UIColor clearColor];
    [self.view addSubview:self.gridView2];
    [self.gridView2 setNeedsDisplay];
    
    self.adConfigView = [[AdConfigView alloc] initWithFrame:CGRectMake(0.f, 0.f, [self getCurrentWidth], 100.f)
                                                    delegate:self
                                                        zone:@"myzone"];
    self.adConfigView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.adConfigView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.adConfigView]; // ???
    bool drawGrid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"drawgrid"] boolValue];
    if (drawGrid && !self.hideGrid)
    {
        self.gridView.color = [UIColor greenColor];
        self.gridView2.color = [UIColor whiteColor];
    }
    else
    {
        self.gridView.color = [UIColor clearColor];
        self.gridView2.color = [UIColor clearColor];
    }
    
    [self.gridView setNeedsDisplay];
    [self.gridView2 setNeedsDisplay];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIViewController attemptRotationToDeviceOrientation];
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

- (CGFloat)getCurrentWidth
{
    return self.view.bounds.size.width;
}

- (NSString *)splitString:(NSString *)string
{
    NSRange range = [string rangeOfString:@" show_json "];
    if (range.location != NSNotFound) {
        return [string substringToIndex:range.location];
    }
    return nil;
}

#pragma mark - IBActions

- (void)resetButtonPressed:(id)sender
{
    self->_showJSON = NO;
}

#pragma mark - Public methods

- (void)placeConfigWindowAboveFrame:(CGRect)frame 
{
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.adConfigView.frame = CGRectMake(0.f,
                                                              0.f,
                                                              self.adConfigView.frame.size.width,
                                                              self.adConfigView.frame.size.height);

                     }
                     completion:^(BOOL finished){
                         [self.view bringSubviewToFront:self.adConfigView];
                     }];
}

- (void)placeConfigWindowBelowFrame:(CGRect)frame
{
//    NSLog(@"adconfig frame before is %@", NSStringFromCGRect(self.adConfigView.frame));
    [self placeConfigWindowBelowFrame:frame callbackBlock:^{}];
}


- (void)placeConfigWindowBelowFrame:(CGRect)frame callbackBlock:(void(^)(void))callbackBlock
{
    //    NSLog(@"adconfig frame before is %@", NSStringFromCGRect(self.adConfigView.frame));
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.adConfigView.frame = CGRectMake(self.adConfigView.frame.origin.x,
                                                              frame.origin.y + frame.size.height,
                                                              self.adConfigView.frame.size.width,
                                                              self.adConfigView.frame.size.height);
                         
                     }
                     completion:^(BOOL finished) {
                         [self.view bringSubviewToFront:self.adConfigView];
                         callbackBlock();
                         //                         NSLog(@"adconfig frame after is %@", NSStringFromCGRect(self.adConfigView.frame));
                     }];
}

- (void)updateZone:(NSString *)zone
{
    self.currentZone = zone;
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CreativeControllerSegue"]) {
        CreativeViewController *vc = [segue destinationViewController];
        vc.adConfigView            = self.adConfigView;
    }
}

#pragma mark - AdConfigViewDelegate

- (void)showCreativeController
{
    [self.tabBarController performSegueWithIdentifier:@"CreativeControllerSegue"
                                               sender:self];
}

#pragma mark - Abstract methods

- (void)refreshButtonPressed:(id) sender
{
    NSAssert(NO, @"override in super class");
}

- (void)bannerPositionPressed:(id)sender
{
    NSAssert(NO, @"override in super class");
}

- (void) animationSelected:(id) sender
{
    NSAssert(NO, @"override in super class");
}

@end
