//
//  CreativeViewController.m
//  MadsDemo
//
//  Created by Vim Solution on 7/25/14.
//
//

#import "CreativeViewController.h"
#import "AdConfigView.h"


@interface CreativeViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic)                BOOL        statusBarWasHidden; // FIX: MOBILESDK-107

@end


@implementation CreativeViewController

#pragma mark - View lifecycle

- (BOOL)prefersStatusBarHidden
{
    return YES; // FIX: MOBILESDK-107
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UIDevice.currentDevice.systemVersion.floatValue >= 7.f) {
        self.textView.font = [UIFont fontWithName:@"Menlo"
                                             size:self.textView.font.pointSize];
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // FIX: MOBILESDK-107
    self.statusBarWasHidden = [UIApplication sharedApplication].statusBarHidden;
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    // FIX: MOBILESDK-107
    [UIApplication sharedApplication].statusBarHidden = self.statusBarWasHidden;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - IBActions

- (IBAction)onDone:(id)sender
{
    if (self.adConfigView) {
        [self.adConfigView enterHTML:self.textView.text];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
