//
//  MadsDemoSettingsViewController.m
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MadsDemoSettingsViewController.h"
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <QuartzCore/QuartzCore.h>
#import <AdSupport/AdSupport.h>
#import <MadsSDK/MadsSDK.h>
#include <sys/socket.h> // Per msqr
#import "asl.h"


@implementation MadsDemoSettingsViewController

UITextView* textViewLog;
NSString* logStr;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Settings", @"Settings");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (CGFloat)getCurrentWidth
{
//    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone ? 320.0: 768.0;
    return UIApplication.sharedApplication.keyWindow.frame.size.width;
}

- (CGFloat)getCurrentHeight
{
    //    return UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone ? 320.0: 768.0;
    return UIApplication.sharedApplication.keyWindow.frame.size.height;
}

- (void)emailButtonPressed
{
    if (![MFMailComposeViewController canSendMail])
    {
        NSLog(@"Can not send email - no mail accounts on this device!");
        return;
    }
    
    logStr = [self getSystemLog];

    MFMailComposeViewController *controller = MFMailComposeViewController.new;
    controller.mailComposeDelegate = self;
    
    NSString* idfa = @"";
    if (NSClassFromString(@"ASIdentifierManager") &&
         ASIdentifierManager.sharedManager.advertisingTrackingEnabled
        )
    {
        idfa = [ASIdentifierManager.sharedManager.advertisingIdentifier UUIDString];
    }
    
    NSString* idfv = @"";
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        idfv = [UIDevice.currentDevice.identifierForVendor UUIDString];
    }
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [info objectForKey:@"CFBundleVersion"];

    [controller setSubject:NSLocalizedString(@"Mads SDK Demo App",
                                             @"Mads")];
    [controller setMessageBody:
     [NSString stringWithFormat:
      NSLocalizedString(@"Mads SDK version: %@\n\nMads SDK build: %@\n\nIDFA:%@\n\n\nIDFV:%@\n\n\nLOG:\n%@\n\n\nSent from the Mads SDK demo app",
                        @"Mads SDK version: %@\n\nMads SDK build: %@\n\nIDFA:%@\n\n\nIDFV:%@\n\n\nLOG:\n%@\n\n\nSent from the Mads SDK demo app"),
      kMadsSDKVersion,
      build,
      idfa,
      idfv,
      logStr
      ] isHTML:NO];
    
    [self presentViewController:controller
                      animated:YES
                     completion:nil];
//    [self presentModalViewController:controller
//                            animated:YES]; // App crash in this line. // ORLY?
}

- (void)refreshLogButtonPressed
{
    textViewLog.text = @"";

    logStr = [self getSystemLog];
    
    textViewLog.text = logStr;
    [textViewLog scrollRangeToVisible:NSMakeRange(logStr.length, 0)];
}


-(NSString*)getSystemLog
{
    NSLog(@"getSystemLog");

    NSString* res = @"";
    aslmsg q, m;
    int i;
    const char *key, *val;
    
    q = asl_new(ASL_TYPE_QUERY);
    
    asl_set_query(q, ASL_KEY_SENDER, "MadsSDKDemo", ASL_QUERY_OP_EQUAL);
    // 3 is error messages
    asl_set_query(q, ASL_KEY_LEVEL, "4", ASL_QUERY_OP_LESS_EQUAL | ASL_QUERY_OP_NUMERIC);
    
    NSDate *startTime = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"starttime"];
    NSString *theDate = [NSString stringWithFormat:@"%d", (int)[startTime timeIntervalSince1970]];
    
//    NSDate *lastminute = [NSDate dateWithTimeIntervalSinceNow: -(60.0f)];
//    NSString *theDate = [NSString stringWithFormat:@"%d", (int)[lastminute timeIntervalSince1970]];
    if(!([theDate length] > 0))
    {
        NSDate *lastminute = [NSDate dateWithTimeIntervalSinceNow: -(60.0f)];
        theDate = [NSString stringWithFormat:@"%d", (int)[lastminute timeIntervalSince1970]];
    }

    asl_set_query(q, ASL_KEY_TIME, [theDate cStringUsingEncoding:NSASCIIStringEncoding], ASL_QUERY_OP_GREATER_EQUAL | ASL_QUERY_OP_NUMERIC);
    
    
    aslresponse r = asl_search(NULL, q);
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        while (NULL != (m = asl_next(r)))
        {
            NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
            
            for (i = 0; (NULL != (key = asl_key(m, i))); i++)
            {
                NSString *keyString = [NSString stringWithUTF8String:(char *)key];
                
                val = asl_get(m, key);
                
                NSString *string = val?[NSString stringWithUTF8String:val]:@"";
                [tmpDict setObject:string forKey:keyString];
            }
            
            NSString* logStr = [NSString stringWithFormat:@"%@: %@\n", [tmpDict objectForKey:@"CFLog Local Time"], [tmpDict objectForKey:@"Message"]];
            res = [res stringByAppendingString:logStr];
        }
    } else {
        while (NULL != (m = asl_next(r))) {
            NSMutableDictionary *tmpDict = [NSMutableDictionary dictionary];
            
            for (i = 0; (NULL != (key = asl_key(m, i))); i++)
            {
                NSString *keyString = [NSString stringWithUTF8String:(char *)key];
                
                val = asl_get(m, key);
                
                NSString *string = val?[NSString stringWithUTF8String:val]:@"";
                [tmpDict setObject:string forKey:keyString];
            }
            
            NSString* logStr = [NSString stringWithFormat:@"%@: %@\n", [tmpDict objectForKey:@"CFLog Local Time"], [tmpDict objectForKey:@"Message"]];
            res = [res stringByAppendingString:logStr];
        }
    }

//    while (NULL != (m = asl_next(r)))  //available not in iOS 7.1 but in iOS 8.0
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
        asl_free(r);
    } else {
       asl_release(r);
    }
    
    return res;
    
}

#pragma mark -

- (void)setupIDFA
{
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 65.0, 100.0, 15.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.textAlignment = NSTextAlignmentLeft;

    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    aLabel.text = NSLocalizedString(@"IDFA:", @"IDFA");
    [self.view addSubview:aLabel];

    aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 80.0, 300.0, 15.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.textAlignment = NSTextAlignmentLeft;

    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

    if ( NSClassFromString(@"ASIdentifierManager")
        && ASIdentifierManager.sharedManager.advertisingTrackingEnabled
        ) {
        aLabel.text = [ASIdentifierManager.sharedManager.advertisingIdentifier UUIDString];
    }
    [self.view addSubview:aLabel];
}

- (void)setupIDFV
{
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 110.0, 100.0, 15.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.textAlignment = NSTextAlignmentLeft;

    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    aLabel.text = NSLocalizedString(@"IDFV:", @"IDFV");
    [self.view addSubview:aLabel];

    aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 125.0, 300.0, 15.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.textAlignment = NSTextAlignmentLeft;

    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        aLabel.text = [UIDevice.currentDevice.identifierForVendor UUIDString];
    }
    [self.view addSubview:aLabel];
}

- (void)setupSDKVersionNumber
{
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 150.0, 150.0, 15.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.textAlignment = NSTextAlignmentLeft;
    
    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    aLabel.text = NSLocalizedString(@"Mads SDK version:", @"Mads SDK version:");
    [self.view addSubview:aLabel];
    
    aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 165.0, 150.0, 15.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.textAlignment = NSTextAlignmentLeft;
    
    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    aLabel.text = kMadsSDKVersion;
    [self.view addSubview:aLabel];
}

- (void)setupSDKBuildNumber
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *build = [info objectForKey:@"CFBundleVersion"];

    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 150.0, 150.0, 15.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.textAlignment = NSTextAlignmentLeft;
    
    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    aLabel.text = NSLocalizedString(@"Mads SDK build:", @"Mads SDK build:");
    [self.view addSubview:aLabel];
    
    aLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 165.0, 150.0, 15.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor whiteColor];
    aLabel.textAlignment = NSTextAlignmentLeft;
    
    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    aLabel.text = build;
    [self.view addSubview:aLabel];
}

- (void)setupLog
{
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 185.0, 150.0, 15.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.textAlignment = NSTextAlignmentLeft;
    
    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    aLabel.text = NSLocalizedString(@"LOG", @"LOG");
    [self.view addSubview:aLabel];
    
    textViewLog = [[UITextView alloc] initWithFrame:CGRectMake(0.0, 205.0, [self getCurrentWidth], [self getCurrentHeight] - 210.0 - 44.0)];
    textViewLog.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textViewLog.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [textViewLog setBackgroundColor:[UIColor blackColor]];
    [textViewLog setFont:[UIFont fontWithName:@"Menlo-Bold" size:12.0]];
    [textViewLog setTextColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0]];
    [textViewLog setEditable:NO];
    
    // For the border and rounded corners
    [[textViewLog layer] setBorderColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor];
    [[textViewLog layer] setBorderWidth:1.0];
    [[textViewLog layer] setCornerRadius:8.0];
    [textViewLog setClipsToBounds: YES];
    
    [self.view addSubview:textViewLog];
}

- (void)setupEmailButton
{
    CGFloat maxWidth = [self getCurrentWidth];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(maxWidth -60.0 - 10.0, 20.0, 60.0, 28.0);
    [aButton setTitle:NSLocalizedString(@"email",)
             forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                              size:(12.0)];
    aButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aButton setTitleColor:[UIColor colorWithRed:0.964705
                                           green:0.556862
                                            blue:0.117647
                                           alpha:1.0]
                  forState:UIControlStateNormal];
    [[aButton layer] setCornerRadius:8.0f];
    [[aButton layer] setMasksToBounds:YES];
    [[aButton layer] setBorderWidth:1.0f];
    [aButton layer].borderColor = [UIColor colorWithRed:0.964705
                                                  green:0.556862
                                                   blue:0.117647
                                                  alpha:1.0].CGColor;
    [aButton addTarget:self
                action:@selector(emailButtonPressed)
      forControlEvents:UIControlEventTouchUpInside];
    aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [self.view addSubview:aButton];
}

- (void)setupRefreshLogButton
{
    CGFloat maxWidth = [self getCurrentWidth];
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(maxWidth -60.0, 205.0, 60.0, 28.0);
    [aButton setTitle:NSLocalizedString(@"Refresh",)
             forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                              size:(12.0)];
    aButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aButton setTitleColor:[UIColor blackColor]
                  forState:UIControlStateNormal];
    [aButton setBackgroundColor:[UIColor colorWithRed:0.964705
                                               green:0.556862
                                                blue:0.117647
                                                alpha:1.0]];
    [[aButton layer] setCornerRadius:8.0f];
    [[aButton layer] setMasksToBounds:YES];
    [[aButton layer] setBorderWidth:1.0f];
    [aButton layer].borderColor = [UIColor colorWithRed:0.964705
                                                  green:0.556862
                                                   blue:0.117647
                                                  alpha:1.0].CGColor;
    [aButton addTarget:self
                action:@selector(refreshLogButtonPressed)
      forControlEvents:UIControlEventTouchUpInside];
    aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    
    [self.view addSubview:aButton];
}

- (void)setupTestSwitch
{
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 20.0, 55.0, 30.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.textAlignment = NSTextAlignmentLeft;
    
    aLabel.numberOfLines = 2;
    aLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    aLabel.text = NSLocalizedString(@"STAGING SERVER", @"STAGING SERVER");
    [self.view addSubview:aLabel];

    UISwitch *aSwitch = [[UISwitch alloc] init];
    aSwitch.frame = CGRectMake(65.0, 20.0, aSwitch.frame.size.width, aSwitch.frame.size.height);

    
    [aSwitch setOnTintColor: [UIColor colorWithRed:0.964705
                                             green:0.556862
                                              blue:0.117647
                                             alpha:0.65]];
    
    [aSwitch setTintColor: [UIColor colorWithRed:0.964705
                                           green:0.556862
                                            blue:0.117647
                                           alpha:0.35]];
    
    [aSwitch setThumbTintColor:[UIColor colorWithRed:0.964705
                                               green:0.556862
                                                blue:0.117647
                                               alpha:1.0]];
    
    
    bool testServerMode = [[[NSUserDefaults standardUserDefaults] objectForKey:@"testservermode"] boolValue];
    
    [aSwitch setOn:testServerMode];

    [aSwitch addTarget:self
                action:@selector(changeTestSwitchValue:)
      forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:aSwitch];
}

- (void)setupGridSwitch
{
    
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.0, 20.0, 35.0, 30.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.textAlignment = NSTextAlignmentLeft;
    
    aLabel.numberOfLines = 2;
    aLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    aLabel.text = NSLocalizedString(@"GRID", @"GRID");
    [self.view addSubview:aLabel];
    
    UISwitch *aSwitch = [[UISwitch alloc] init];
    aSwitch.frame = CGRectMake(165.0, 20.0, aSwitch.frame.size.width, aSwitch.frame.size.height);
    
    
    [aSwitch setOnTintColor: [UIColor colorWithRed:0.964705
                                             green:0.556862
                                              blue:0.117647
                                             alpha:0.65]];
    
    [aSwitch setTintColor: [UIColor colorWithRed:0.964705
                                           green:0.556862
                                            blue:0.117647
                                           alpha:0.35]];
    
    [aSwitch setThumbTintColor:[UIColor colorWithRed:0.964705
                                               green:0.556862
                                                blue:0.117647
                                               alpha:1.0]];
    
    
    bool drawGrid = [[[NSUserDefaults standardUserDefaults] objectForKey:@"drawgrid"] boolValue];
    
    [aSwitch setOn:drawGrid];
    
    [aSwitch addTarget:self
                action:@selector(changeGridSwitchValue:)
      forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:aSwitch];
}

- (void) changeTestSwitchValue:(UISwitch*) sender
{
//    NSLog(@"USE TEST SERVER %@", [sender isOn]?@"ON":@"OFF");
    
    [[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:@"testservermode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) changeGridSwitchValue:(UISwitch*) sender
{
//    NSLog(@"DRAW GRID %@", [sender isOn]?@"ON":@"OFF");
    
    [[NSUserDefaults standardUserDefaults] setBool:[sender isOn] forKey:@"drawgrid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupEmailButton];
    [self setupTestSwitch];
    [self setupGridSwitch];

    [self setupIDFA];
    [self setupIDFV];

    [self setupSDKVersionNumber];
    
    [self setupSDKBuildNumber];
    
    [self setupLog];
    [self setupRefreshLogButton];
    
//    [self refreshLogButtonPressed];
    [self performSelector:@selector(refreshLogButtonPressed) withObject:self afterDelay:1.0];

    // add the text below in the new design:
    /*
     MADS delivers the technology powering the mobile advertising business of leading publishers, ad networks, broadcasters and operators. Our state-of-the-art ad server MADS ONE delivers ads to Mobile Internet sites, Desktop Internet sites and Tablets. The combination of our excellent service and innovative ad serving features made over 200 leading media companies choose for MADS ONE. MADS is headquartered in Amsterdam, the Netherlands, and has offices in London, Milan and Dnipropetrovsk.
     */
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
