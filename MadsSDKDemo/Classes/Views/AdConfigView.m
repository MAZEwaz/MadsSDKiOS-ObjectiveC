//
//  AdConfigView.m
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdConfigView.h"
#import <QuartzCore/QuartzCore.h>


static CGFloat kMinFrameHeight            = 210.f;
static CGFloat kSegControlHeightAndMargin = 28.f;
static CGRect  kTopDividerFrame           = { 0.f,  32.f, 280.f, 1.f };
static CGRect  kBottomDividerFrame        = { 0.f, 122.f, 280.f, 1.f };

static NSString *const MADSAutocloseAlertTitle = @"Auto close after click on ad";
static NSString *const MADSAppearAlertTitle = @"AD view animation type";

@interface AdConfigView() <UITextFieldDelegate, UIActionSheetDelegate>
{
    UILabel            *_zoneLabel;
    UITextField        *_zoneTextField;
    UIButton           *_resetButton;
    UIButton           *_refreshButton;
    UIButton           *_loadCreativeButton;
    UITextView         *_textView;
    NSString           *_zone;
    NSString           *_htmlString;
    UISegmentedControl *_segControl;
    UIButton           *_animationButton;
    UIView             *_bottomDividerView;
    UIActionSheet      *_actionSheetView;

}
@property(nonatomic, strong) UILabel            *zoneLabel;
@property(nonatomic, strong) UITextField        *zoneTextField;
@property(nonatomic, strong) UIButton           *resetButton;
@property(nonatomic, strong) UIButton           *refreshButton;
@property(nonatomic, strong) UIButton 			*createModalButton;
@property(nonatomic, strong) UIButton           *loadCreativeButton;
@property(nonatomic, strong) UITextView         *textView;
@property(nonatomic, strong) NSString           *zone;
@property(nonatomic, strong) NSString           *htmlString;
@property(nonatomic, strong) UISegmentedControl *segControl;
@property(nonatomic, strong) UIButton           *animationButton;
@property(nonatomic, strong) UIActionSheet      *actionSheetView;
@property(nonatomic, strong) UIView             *bottomDividerView;
@property(nonatomic, strong) UILabel            *frameDescriptionLabel;
@property(nonatomic, strong) UITextField        *minWidthTextField;
@property(nonatomic, strong) UITextField        *maxWidthTextField;
@property(nonatomic, strong) UITextField        *minHeightTextField;
@property(nonatomic, strong) UITextField        *maxHeightTextField;
@property(nonatomic, strong) UILabel            *minWidthLabel;
@property(nonatomic, strong) UILabel            *maxWidthTextLabel;
@property(nonatomic, strong) UILabel            *minHeightTextLabel;
@property(nonatomic, strong) UILabel            *maxHeightTextLabel;

- (void)initialize;
- (void)resetButtonPressed;
- (void)refreshButtonPressed;
- (void)modalButtonPressed;
- (void)animationButtonPressed:(UIButton*)sender;

@end


@implementation AdConfigView

@synthesize delegate = _delegate,
            zoneLabel = _zoneLabel,
            zoneTextField = _zoneTextField,
            resetButton = _resetButton,
            refreshButton = _refreshButton,
            createModalButton = _createModalButton,
            loadCreativeButton = _loadCreativeButton,
            textView = _textView,
            zone = _zone,
            spinner = _spinner,
            statusLabel = _statusLabel,
            titleLabel = _titleLabel,
            testServerModeLabel = _testServerModeLabel,
            htmlString = _htmlString,
            segControl = _segControl,
            position = _position,
            animationButton = _animationButton,
            animationType = _animationType,
            actionSheetView = _actionSheetView,
            bottomDividerView = _bottomDividerView,
            isAutoCloseAfterClick = _isAutoCloseAfterClick;

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.delegate = nil;

}

- (id) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
     
    }
    return self;
}

- (CGFloat) getCurrentWidth {
    return CGRectGetWidth(self.bounds);
}

- (id)initWithFrame:(CGRect)frame
           delegate:(id)delegate
               zone:(NSString *)zone {
    CGRect theFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    
    // We define the min width and height of the frame, so override it if needed
//    CGFloat maxWidth = [self getCurrentWidth];
//    if(theFrame.size.width < maxWidth)
//        theFrame = CGRectMake(theFrame.origin.x, theFrame.origin.y, maxWidth - theFrame.origin.x, theFrame.size.height);

    if(theFrame.size.height < kMinFrameHeight)
        theFrame = CGRectMake(theFrame.origin.x, theFrame.origin.y, theFrame.size.width, kMinFrameHeight);    

    self = [super initWithFrame:theFrame];
    if (self) {
        self.zone = zone;
        self.isAutoCloseAfterClick = YES;
        self.delegate = delegate;
        self.animationType = MadsAdAnimationTypeAppear;
        // Initialization code
        self.frame = theFrame;
        [self initialize];
    }
    return self;

}

- (void)resetButtonPressed {
    if(self.delegate && [self.delegate respondsToSelector:@selector(resetButtonPressed:)])
        [self.delegate resetButtonPressed:self];
}

-(void)refreshButtonPressed
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(refreshButtonPressed:)])
        [self.delegate refreshButtonPressed:self];
}

- (void)modalButtonPressed {
    if(self.delegate && [self.delegate respondsToSelector:@selector(modalButtonPressed:)])
        [self.delegate modalButtonPressed:self];
}

- (void)enterHTML:(NSString *)text {
    self.htmlString = text;

    if ([self.delegate respondsToSelector:@selector(htmlEntered:)]) {
        [self.delegate htmlEntered:self];
    }
}

- (void)segControlPressed:(id)sender {
    self.position = (MadsAdPosition) ((UISegmentedControl *)sender).selectedSegmentIndex;

    if ([self.delegate respondsToSelector:@selector(bannerPositionPressed:)]) {
        [self.delegate bannerPositionPressed:self];
    }
}

- (void)loadCreativeButtonPressed {
    if ([self.delegate respondsToSelector:@selector(showCreativeController)]) {
        [self.delegate showCreativeController];
    }
}

- (void)animationButtonPressed:(UIButton*)sender {
    if (!self.actionSheetView) {
        self.actionSheetView = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(MADSAppearAlertTitle, nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"Appear", nil),
                                NSLocalizedString(@"Top", nil),
                                NSLocalizedString(@"Bottom", nil),
                                NSLocalizedString(@"Left", nil),
                                NSLocalizedString(@"Right", nil), nil];
//        UIActionSheet *anActionSheetView = [[MadsAdAnimationPickerView alloc] init];
//        [self addSubview:aPickerView];
//        aPickerView.myDelegate = self;
//        self.actionSheetView = anActionSheetView;
//        self.animationButton.enabled = NO;
    }
    [self.actionSheetView showInView:self.superview.superview];
//    [self.actionSheetView showFromRect:sender.frame
//                                inView:self.superview.superview.superview
//                              animated:YES];
}

- (void)autocloseButtonPressed:(UIButton*)sender {
    if (!self.actionSheetView) {
        self.actionSheetView = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(MADSAutocloseAlertTitle, nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:NSLocalizedString(@"NO", nil),
                                NSLocalizedString(@"YES", nil), nil];
    }
    [self.actionSheetView showInView:self.superview.superview];
}

- (void)setupZoneUI {
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 90.0, 40.0, 22.0)];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];

    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textAlignment = NSTextAlignmentCenter;
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(14.0)];
    aLabel.numberOfLines = 2;
	
    aLabel.text = NSLocalizedString(@"ZONE",);
    [self addSubview: aLabel];
    self.zoneLabel = aLabel;
    
    CGFloat maxWidth = [self getCurrentWidth];
    
    UITextField *aTextField = [[UITextField alloc] init];
    aTextField.frame = CGRectMake(56.0, 90.0, maxWidth - 135.0, 22.0);
    aTextField.delegate = self;
    aTextField.minimumFontSize = (10.0);
    aTextField.adjustsFontSizeToFitWidth = YES;
    aTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    aTextField.keyboardType = UIKeyboardTypeDefault;
    aTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    aTextField.textColor = UIColor.whiteColor; // [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0];
    aTextField.backgroundColor = UIColor.blackColor;
//    aTextField.backgroundColor = UIColor.whiteColor;
    UIView *aLeftView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 5.0, 20.0)];
    aTextField.leftView = aLeftView;
    aTextField.leftViewMode = UITextFieldViewModeAlways;
    aTextField.autocapitalizationType =  UITextAutocapitalizationTypeNone;
    aTextField.returnKeyType = UIReturnKeyDone;
    aTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    aTextField.placeholder = NSLocalizedString(@"ZONE",);
    aTextField.accessibilityIdentifier = @"ZONE";

//    aTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"clear_button.png"] forState:UIControlStateNormal];
    aTextField.rightView = button;
    aTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    [button setFrame:CGRectMake(0.0f, 0.0f, 20.0f, 16.0f)]; // Required for iOS7

    aTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;    
    aTextField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [aTextField layer].cornerRadius = 3.0;
    [aTextField layer].borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
    [aTextField layer].borderWidth = 1.0;
    [aTextField layer].masksToBounds = YES;

    aTextField.text = self.zone;
    [self addSubview:aTextField];
    self.zoneTextField = aTextField;
}

- (void)setupResetButton
{
    CGFloat maxWidth = [self getCurrentWidth];

    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(maxWidth - 10.0 - 60.0, 87.0, 60.0, 28.0);
    [aButton setTitle:NSLocalizedString(@"Reset",) forState:UIControlStateNormal];    
    aButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(11.0)];
    aButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aButton setTitleColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0] forState:UIControlStateNormal];
//    [aButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    aButton.titleLabel.shadowOffset = CGSizeMake(0, 1);

    [[aButton layer] setCornerRadius:8.0f];
    [[aButton layer] setMasksToBounds:YES];
    [[aButton layer] setBorderWidth:1.0f];
    //[[aButton layer] setBackgroundColor:[UIColor lightGrayColor].CGColor];
    
    [aButton layer].borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;

    aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

    [aButton addTarget:self action:@selector(resetButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:aButton];
    self.resetButton = aButton;
}

- (void) setupRefreshButton
{
    CGFloat maxWidth = [self getCurrentWidth];

    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(maxWidth - 10.0 - 60.0, kBottomDividerFrame.origin.y + 11, 60.0, 28.0);
    [aButton setTitle:NSLocalizedString(@"Refresh",) forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(11.0)];
    aButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aButton setTitleColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0] forState:UIControlStateNormal];

    [[aButton layer] setCornerRadius:8.0f];
    [[aButton layer] setMasksToBounds:YES];
    [[aButton layer] setBorderWidth:1.0f];

    [aButton layer].borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;

    [aButton addTarget:self action:@selector(refreshButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;

    [self addSubview:aButton];
    self.refreshButton = aButton;    
}

- (void)setupCreateModalButton {
    if (!self.createModalButton) {
        CGFloat maxWidth = [self getCurrentWidth];
        
        UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat maxY = CGRectGetMaxY(self.refreshButton.frame);
        aButton.frame = CGRectMake(maxWidth - 10.0 - 60.0, maxY + 11, 60.0, 28.0);
        [aButton setTitle:NSLocalizedString(@"Modal",) forState:UIControlStateNormal];
        aButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(11.0)];
        aButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aButton setTitleColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0] forState:UIControlStateNormal];
        
        [[aButton layer] setCornerRadius:8.0f];
        [[aButton layer] setMasksToBounds:YES];
        [[aButton layer] setBorderWidth:1.0f];
        
        [aButton layer].borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
        
        [aButton addTarget:self action:@selector(modalButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        aButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        
        [self addSubview:aButton];
        self.createModalButton = aButton;
    }
}

- (void)setupLoadCreativeButton {
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(10.0, kBottomDividerFrame.origin.y + 11, 60.0, 28.0);
    [aButton setTitle:NSLocalizedString(@"HTML",) forState:UIControlStateNormal];
    aButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(11.0)];
    aButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aButton setTitleColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0] forState:UIControlStateNormal];

    [[aButton layer] setCornerRadius:8.0f];
    [[aButton layer] setMasksToBounds:YES];
    [[aButton layer] setBorderWidth:1.0f];

    [aButton layer].borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;

    [aButton addTarget:self action:@selector(loadCreativeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    aButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    [self addSubview:aButton];
    self.loadCreativeButton = aButton;    
}

- (void)setupSpinner {
    UIActivityIndicatorView *aView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        aView.frame = CGRectMake(140.0, self.titleLabel.frame.origin.y + 4.0, 30.0, 30.0);
    } else {
        aView.frame = CGRectMake(125.0, self.titleLabel.frame.origin.y + 4.0, 30.0, 30.0);        
    }
    
    aView.hidden = YES;
    [self addSubview:aView];
    self.spinner = aView;
}

- (void)setupTitleLabel {
    CGFloat maxWidth = [self getCurrentWidth];
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, maxWidth - 10.0, 15.0)];

    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(14.0)];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textAlignment = NSTextAlignmentLeft;
    
    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    self.titleLabel = aLabel;
    [self addSubview:aLabel];
}


- (void)setupStatusLabel {
    CGFloat maxWidth = [self getCurrentWidth];
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.spinner.frame.origin.x + self.spinner.frame.size.width, self.spinner.frame.origin.y, maxWidth - 10.0 - 40.0, 30.0)];
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:(12.0)];
    aLabel.backgroundColor = [UIColor clearColor];
    aLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.textAlignment = NSTextAlignmentLeft;
    
    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    self.statusLabel = aLabel;
    [self addSubview:aLabel];
}

-(void) setupTestServerModeLabel
{
    CGFloat maxWidth = [self getCurrentWidth];
    UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxWidth - 60.0, self.spinner.frame.origin.y, 60.0, 24.0)];
    aLabel.layer.cornerRadius = 12.0;
    aLabel.layer.masksToBounds = true;
    aLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aLabel.backgroundColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    aLabel.textColor = [UIColor colorWithRed:0.13333 green:0.11764 blue:0.121566 alpha:1.0];
    aLabel.textAlignment = NSTextAlignmentCenter;
    
    aLabel.numberOfLines = 1;
    aLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    aLabel.text = @"STAGING";
    [aLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
    self.testServerModeLabel = aLabel;
    [self addSubview:aLabel];
    [self updateTestServerModeLabel];
}

- (void)updateTestServerModeLabel
{
    self.testServerModeLabel.hidden = ![[[NSUserDefaults standardUserDefaults] objectForKey:@"testservermode"] boolValue];
}

-(void) setupSegmentedControl
{
    CGFloat maxWidth = [self getCurrentWidth];
    
    UISegmentedControl *myControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 42.0, maxWidth - 20.0, 32)];
// Deprecated in 7_0        myControl.segmentedControlStyle = UISegmentedControlStyleBar;
    myControl.tintColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    [myControl insertSegmentWithTitle:NSLocalizedString(@"Top", ) atIndex:0 animated:NO ];
    [myControl insertSegmentWithTitle:NSLocalizedString(@"Below UI", ) atIndex:1 animated:NO];
    [myControl insertSegmentWithTitle:NSLocalizedString(@"Bottom", ) atIndex:2 animated:NO];
    [myControl insertSegmentWithTitle:NSLocalizedString(@"Scrolling", ) atIndex:3 animated:NO];
    myControl.selectedSegmentIndex = 0;
    [myControl addTarget:self action:@selector(segControlPressed:) forControlEvents:UIControlEventValueChanged];
    myControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    self.segControl = myControl;
    [self addSubview:myControl];
}

-(void) setupAnimationPickerViewButton
{
    CGFloat maxWidth = [self getCurrentWidth];
    
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    aButton.frame = CGRectMake(self.loadCreativeButton.frame.origin.x + self.loadCreativeButton.frame.size.width + 10.0, kBottomDividerFrame.origin.y + 11, maxWidth - 30.0 - self.refreshButton.frame.size.width - self.loadCreativeButton.frame.origin.x - self.loadCreativeButton.frame.size.width, 28.0);
    [aButton setTitle:NSLocalizedString(@"Animation type: Appear",) forState:UIControlStateNormal];

    aButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    aButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    aButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [aButton setTitleColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0] forState:UIControlStateNormal];

    [[aButton layer] setCornerRadius:8.0f];
    [[aButton layer] setMasksToBounds:YES];
    [[aButton layer] setBorderWidth:1.0f];

    [aButton layer].borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;

    [aButton addTarget:self action:@selector(animationButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    aButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:aButton];
    self.animationButton = aButton;    

}

- (void)setupOverlayAutoCloseButton {
    CGFloat maxWidth = [self getCurrentWidth];
    UIButton* autoCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    autoCloseButton.frame = CGRectMake(CGRectGetMinX(self.loadCreativeButton.frame) + CGRectGetWidth(self.loadCreativeButton.frame) + 10.0,
                                       CGRectGetMinY(self.refreshButton.frame),
                                       maxWidth - 30.0 - CGRectGetWidth(self.refreshButton.frame) - CGRectGetMinX(self.loadCreativeButton.frame) - CGRectGetWidth(self.loadCreativeButton.frame),
                                       28.0);
    [autoCloseButton setTitle:NSLocalizedString(@"Close after click: YES",) forState:UIControlStateNormal];
    autoCloseButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:(12.0)];
    autoCloseButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    autoCloseButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [autoCloseButton setTitleColor:[UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0] forState:UIControlStateNormal];
    
    [[autoCloseButton layer] setCornerRadius:8.0f];
    [[autoCloseButton layer] setMasksToBounds:YES];
    [[autoCloseButton layer] setBorderWidth:1.0f];
    
    [autoCloseButton layer].borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
    
    [autoCloseButton addTarget:self action:@selector(autocloseButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    autoCloseButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:autoCloseButton];
    self.animationButton = autoCloseButton;
}

-(void) setupTopDivider
{
    CGFloat maxWidth = [self getCurrentWidth];
    CGRect divFrame  = CGRectMake(kTopDividerFrame.origin.x, kTopDividerFrame.origin.y, maxWidth, kTopDividerFrame.size.height);
    UIView *dividerView = [[UIView alloc] initWithFrame:divFrame];
    dividerView.backgroundColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    dividerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:dividerView];
}

-(void) setupBottomDivider
{
    CGFloat maxWidth = [self getCurrentWidth];
    CGRect divFrame  = CGRectMake(kBottomDividerFrame.origin.x, kBottomDividerFrame.origin.y, maxWidth, kBottomDividerFrame.size.height);
    UIView *dividerView = [[UIView alloc] initWithFrame:divFrame];
    dividerView.backgroundColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    dividerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.bottomDividerView = dividerView;
    
    [self addSubview:dividerView];
}

- (void)removeAdSizeUI {
    [self.minWidthLabel removeFromSuperview];
    [self.minWidthTextField removeFromSuperview];
    [self.maxWidthTextField removeFromSuperview];
    [self.maxWidthTextLabel removeFromSuperview];
    [self.minHeightTextField removeFromSuperview];
    [self.minHeightTextLabel removeFromSuperview];
    [self.maxHeightTextField removeFromSuperview];
    [self.maxHeightTextLabel removeFromSuperview];
}

- (void)setupADSizeUI:(BOOL)isLandscape {
    [self removeAdSizeUI];
    if (!self.minWidthLabel) {
        self.minWidthLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 175.0, 80.0, 22.0)];
        self.minWidthLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
        self.minWidthLabel.backgroundColor = [UIColor clearColor];
        self.minWidthLabel.textAlignment = NSTextAlignmentCenter;
        self.minWidthLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(14.0)];
        self.minWidthLabel.numberOfLines = 1;
        self.minWidthLabel.text = NSLocalizedString(@"Min Width:",);
    }
    [self addSubview: self.minWidthLabel];
    
    if (!self.minWidthTextField) {
        _minWidthTextField = [[UITextField alloc] init];
        _minWidthTextField.frame = CGRectMake(90.0, 175.0, 45.0, 22.0);
        _minWidthTextField.delegate = self;
        _minWidthTextField.keyboardType = UIKeyboardTypeNumberPad;
        _minWidthTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
        _minWidthTextField.textColor = UIColor.whiteColor;
        _minWidthTextField.backgroundColor = UIColor.blackColor;
        _minWidthTextField.returnKeyType = UIReturnKeyDone;
        _minWidthTextField.layer.cornerRadius = 3.0;
        _minWidthTextField.layer.borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
        _minWidthTextField.layer.borderWidth = 1.0;
        _minWidthTextField.layer.masksToBounds = YES;
        _minWidthTextField.text = @"1";
    }
    [self addSubview:_minWidthTextField];
    
    if (!self.maxWidthTextLabel) {
        self.maxWidthTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(145.0, 175.0, 80.0, 22.0)];
        self.maxWidthTextLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
        self.maxWidthTextLabel.backgroundColor = [UIColor clearColor];
        self.maxWidthTextLabel.textAlignment = NSTextAlignmentCenter;
        self.maxWidthTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(14.0)];
        self.maxWidthTextLabel.numberOfLines = 1;
        self.maxWidthTextLabel.text = NSLocalizedString(@"Max Width:",);
    }
    [self addSubview: self.maxWidthTextLabel];
    
    if (!self.maxWidthTextField) {
        _maxWidthTextField = [[UITextField alloc] init];
        _maxWidthTextField.frame = CGRectMake(225.0, 175.0, 45.0, 22.0);
        _maxWidthTextField.delegate = self;
        _maxWidthTextField.keyboardType = UIKeyboardTypeNumberPad;
        _maxWidthTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
        _maxWidthTextField.textColor = UIColor.whiteColor;
        _maxWidthTextField.backgroundColor = UIColor.blackColor;
        _maxWidthTextField.returnKeyType = UIReturnKeyDone;
        _maxWidthTextField.layer.cornerRadius = 3.0;
        _maxWidthTextField.layer.borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
        _maxWidthTextField.layer.borderWidth = 1.0;
        _maxWidthTextField.layer.masksToBounds = YES;
        _maxWidthTextField.text = [NSString stringWithFormat:@"%1.0f", UIApplication.sharedApplication.keyWindow.frame.size.width];
    }
    [self addSubview:_maxWidthTextField];
    
    CGRect minHeigtLabelFrame = CGRectZero;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && !isLandscape) {
        minHeigtLabelFrame = CGRectMake(10.0, 215.0, 80.0, 22.0);
    } else {
        minHeigtLabelFrame = CGRectMake(280.0, 175.0, 80.0, 22.0);
    }
    if (!self.minHeightTextLabel) {
        self.minHeightTextLabel = [[UILabel alloc] init];
        self.minHeightTextLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
        self.minHeightTextLabel.backgroundColor = [UIColor clearColor];
        self.minHeightTextLabel.textAlignment = NSTextAlignmentCenter;
        self.minHeightTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(14.0)];
        self.minHeightTextLabel.numberOfLines = 1;
        self.minHeightTextLabel.text = NSLocalizedString(@"Min Height:",);
    }
    self.minHeightTextLabel.frame = minHeigtLabelFrame;

    [self addSubview: self.minHeightTextLabel];
    
    CGRect minHeigtTextFieldFrame = CGRectZero;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && !isLandscape) {
        minHeigtTextFieldFrame = CGRectMake(90.0, 215.0, 45.0, 22.0);
    } else {
        minHeigtTextFieldFrame = CGRectMake(360.0, 175.0, 45.0, 22.0);
    }
    
    if (!self.minHeightTextField) {
        _minHeightTextField = [[UITextField alloc] init];
        _minHeightTextField.delegate = self;
        _minHeightTextField.keyboardType = UIKeyboardTypeNumberPad;
        _minHeightTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
        _minHeightTextField.textColor = UIColor.whiteColor;
        _minHeightTextField.backgroundColor = UIColor.blackColor;
        _minHeightTextField.returnKeyType = UIReturnKeyDone;
        _minHeightTextField.layer.cornerRadius = 3.0;
        _minHeightTextField.layer.borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
        _minHeightTextField.layer.borderWidth = 1.0;
        _minHeightTextField.layer.masksToBounds = YES;
        _minHeightTextField.text = @"1";
    }

    _minHeightTextField.frame = minHeigtTextFieldFrame;
    [self addSubview:_minHeightTextField];
    
    CGRect maxHeigtLabelFrame = CGRectZero;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && !isLandscape) {
        maxHeigtLabelFrame = CGRectMake(145.0, 215.0, 80.0, 22.0);
    } else {
        maxHeigtLabelFrame = CGRectMake(415.0, 175.0, 80.0, 22.0);
    }
    
    if (!self.maxHeightTextLabel) {
        self.maxHeightTextLabel = [[UILabel alloc] init];
        self.maxHeightTextLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
        self.maxHeightTextLabel.backgroundColor = [UIColor clearColor];
        self.maxHeightTextLabel.textAlignment = NSTextAlignmentCenter;
        self.maxHeightTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(14.0)];
        self.maxHeightTextLabel.numberOfLines = 1;
        self.maxHeightTextLabel.text = NSLocalizedString(@"Max Height:",);
    }

    self.maxHeightTextLabel.frame = maxHeigtLabelFrame;
    [self addSubview: self.maxHeightTextLabel];
    
    CGRect maxHeigtTextFieldFrame = CGRectZero;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && !isLandscape) {
        maxHeigtTextFieldFrame = CGRectMake(225.0, 215.0, 45.0, 22.0);
    } else {
        maxHeigtTextFieldFrame = CGRectMake(495.0, 175.0, 45.0, 22.0);
    }
    
    if (!self.maxHeightTextField) {
        _maxHeightTextField = [[UITextField alloc] init];
        
        _maxHeightTextField.delegate = self;
        _maxHeightTextField.keyboardType = UIKeyboardTypeNumberPad;
        _maxHeightTextField.font = [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
        _maxHeightTextField.textColor = UIColor.whiteColor;
        _maxHeightTextField.backgroundColor = UIColor.blackColor;
        _maxHeightTextField.returnKeyType = UIReturnKeyDone;
        _maxHeightTextField.layer.cornerRadius = 3.0;
        _maxHeightTextField.layer.borderColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0].CGColor;
        _maxHeightTextField.layer.borderWidth = 1.0;
        _maxHeightTextField.layer.masksToBounds = YES;
        _maxHeightTextField.text = [NSString stringWithFormat:@"%1.0f", UIApplication.sharedApplication.keyWindow.frame.size.height];
    }
    _maxHeightTextField.frame = maxHeigtTextFieldFrame;
    [self addSubview:_maxHeightTextField];
}

- (void)initialize {
    // Set up the view
    self.backgroundColor = [UIColor colorWithRed:0.13333 green:0.11764 blue:0.121566 alpha:1.0];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _htmlString = nil;
    _position = MadsAdPositionTop;
    [self setupTopDivider];
    [self setupBottomDivider];


    [self setupResetButton];
    [self setupZoneUI];
    [self setupRefreshButton];
    [self setupLoadCreativeButton];
    [self setupSpinner];
    [self setupStatusLabel];
    [self setupTestServerModeLabel];
    [self setupTitleLabel];
    [self setupSegmentedControl];
    [self setupAnimationPickerViewButton];
    [self addFrameDescription];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSString *) currentZone
{
    return self.zone;   
}

- (CGSize)minSize
{
    return CGSizeMake([_minWidthTextField.text intValue], [_minHeightTextField.text intValue]);
}

- (CGSize)maxSize
{
    return CGSizeMake([_maxWidthTextField.text intValue], [_maxHeightTextField.text intValue]);
}

- (void) spinnerOn {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

- (void)spinnerOff {
    self.spinner.hidden = YES;
    [self.spinner stopAnimating];
}

- (void)updateZone:(NSString *)zone {
    self.zone = zone;
    self.zoneTextField.text = self.zone;
}

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)getHTML {
    return [self.htmlString copy];
}

- (void)changeAutoCloseAfterClick:(BOOL)isAutoClose {
    NSString *buttonTitle = [NSString stringWithFormat:@"Close after click: %@", isAutoClose ? @"YES" : @"NO"];
    [self.animationButton setTitle:NSLocalizedString(buttonTitle,) forState:UIControlStateNormal];
    self.isAutoCloseAfterClick = isAutoClose;
    if (self.delegate && [self.delegate respondsToSelector:@selector(autoCloseChanged:)]) {
        [self.delegate autoCloseChanged:self];
    } else {
        NSLog(@"AdConfig: delegate not set for autoCloseChanged");
    }
}

- (void)changeAnimationType:(MadsAdAnimationType)animationType {
    // change the title of the button
    switch (animationType) {
        case MadsAdAnimationTypeAppear:
            [self.animationButton setTitle:NSLocalizedString(@"Animation type: Appear",) forState:UIControlStateNormal];
            break;
        case MadsAdAnimationTypeTop:
            [self.animationButton setTitle:NSLocalizedString(@"Animation type: Top",) forState:UIControlStateNormal];
            break;
        case MadsAdAnimationTypeBottom:
            [self.animationButton setTitle:NSLocalizedString(@"Animation type: Bottom",) forState:UIControlStateNormal];
            break;
        case MadsAdAnimationTypeLeft:
            [self.animationButton setTitle:NSLocalizedString(@"Animation type: Left",) forState:UIControlStateNormal];
            break;
        case MadsAdAnimationTypeRight:
            [self.animationButton setTitle:NSLocalizedString(@"Animation type: Right",) forState:UIControlStateNormal];
            break;
        default:
            [self.animationButton setTitle:NSLocalizedString(@"Animation type: Appear",) forState:UIControlStateNormal];
            break;
    }
    
    self.animationType = animationType;
    // warn the delegate
    if(self.delegate && [self.delegate respondsToSelector:@selector(animationSelected:)])
    {
        [self.delegate animationSelected:self];
    }
    else
    {
        NSLog(@"AdConfig: delegate not set for animationSelected");
    }
}

- (void)moveUIControlsUp {
    self.zoneLabel.frame = CGRectMake(self.zoneLabel.frame.origin.x, self.zoneLabel.frame.origin.y - kSegControlHeightAndMargin, self.zoneLabel.frame.size.width, self.zoneLabel.frame.size.height);
    self.zoneTextField.frame = CGRectMake(self.zoneTextField.frame.origin.x, self.zoneTextField.frame.origin.y - kSegControlHeightAndMargin, self.zoneTextField.frame.size.width, self.zoneTextField.frame.size.height);

    self.resetButton.frame = CGRectMake(self.resetButton.frame.origin.x, self.resetButton.frame.origin.y - kSegControlHeightAndMargin, self.resetButton.frame.size.width, self.resetButton.frame.size.height);

    self.bottomDividerView.frame = CGRectMake(self.bottomDividerView.frame.origin.x, self.bottomDividerView.frame.origin.y - kSegControlHeightAndMargin, self.bottomDividerView.frame.size.width, self.bottomDividerView.frame.size.height);

    self.loadCreativeButton.frame = CGRectMake(self.loadCreativeButton.frame.origin.x, self.loadCreativeButton.frame.origin.y - kSegControlHeightAndMargin, self.loadCreativeButton.frame.size.width, self.loadCreativeButton.frame.size.height);

    self.refreshButton.frame = CGRectMake(self.refreshButton.frame.origin.x, self.refreshButton.frame.origin.y - kSegControlHeightAndMargin, self.refreshButton.frame.size.width, self.refreshButton.frame.size.height);
}

- (void)moveUIControlsDown {
    self.zoneLabel.frame = CGRectMake(self.zoneLabel.frame.origin.x, self.zoneLabel.frame.origin.y + kSegControlHeightAndMargin, self.zoneLabel.frame.size.width, self.zoneLabel.frame.size.height);
    self.zoneTextField.frame = CGRectMake(self.zoneTextField.frame.origin.x, self.zoneTextField.frame.origin.y + kSegControlHeightAndMargin, self.zoneTextField.frame.size.width, self.zoneTextField.frame.size.height);
    
    self.resetButton.frame = CGRectMake(self.resetButton.frame.origin.x, self.resetButton.frame.origin.y + kSegControlHeightAndMargin, self.resetButton.frame.size.width, self.resetButton.frame.size.height);
    
    self.bottomDividerView.frame = CGRectMake(self.bottomDividerView.frame.origin.x, self.bottomDividerView.frame.origin.y + kSegControlHeightAndMargin, self.bottomDividerView.frame.size.width, self.bottomDividerView.frame.size.height);
    
    self.loadCreativeButton.frame = CGRectMake(self.loadCreativeButton.frame.origin.x, self.loadCreativeButton.frame.origin.y + kSegControlHeightAndMargin, self.loadCreativeButton.frame.size.width, self.loadCreativeButton.frame.size.height);
    
    self.refreshButton.frame = CGRectMake(self.refreshButton.frame.origin.x, self.refreshButton.frame.origin.y + kSegControlHeightAndMargin, self.refreshButton.frame.size.width, self.refreshButton.frame.size.height);
}

- (void)hideAdPositionControls:(BOOL) hidden {
    if(hidden) {
        if(self.segControl.hidden == NO) { // only execute once
            self.segControl.hidden = YES;
            self.animationButton.hidden = YES;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height -  self.segControl.frame.size.height + 4.0);
            [self moveUIControlsUp];
        }
    } else {
        self.segControl.hidden = NO;
        self.animationButton.hidden = NO;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, kMinFrameHeight);
        [self moveUIControlsDown];
     }
}

- (void)showAdSizeControls {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height+42.f);
    [self setupADSizeUI:UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)];
}

- (void)processTextFieldEdit:(UITextField *)textField {
    if([textField isEqual:self.zoneTextField])
    {
        self.zone = textField.text;
        if(self.delegate && [self.delegate respondsToSelector:@selector(zoneChanged:)])
        {
            [self.delegate zoneChanged:self];
    
        }
    }
}

// UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    [self processTextFieldEdit:textField];
    // figure out what happened and jump the cursor to the other field
    // wait until the keyboard disappeared
    //[self performSelector:@selector(setCursorToOtherTextField:) withObject:textField afterDelay:0.3];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    //[self processTextFieldEdit:textField];
    //[self performSelector:@selector(setCursorToOtherTextField:) withObject:textField afterDelay:0.3];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:self.zoneTextField])
        return true;
    else {
        // allow backspace
        if (!string.length) {
            return YES;
        }
        
        // Prevent invalid character input, if keyboard is numberpad
        if (textField.keyboardType == UIKeyboardTypeNumberPad) {
            if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound) {
                // This field accepts only numeric entries
                return NO;
            }
        }
        
        // verify max length has not been exceeded
        NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if (updatedText.length > 4) // 4 was chosen for SSN verification
        {
            // suppress the max length message only when the user is typing
            // easy: pasted data has a length greater than 1; who copy/pastes one character?
            return NO;
        }
        return YES;
    }
}

- (void)keyboardDidShow:(NSNotification*)notification {
    // only do this if we are in modal view adding html
    if(self.textView)
    {
        CGRect keyboardFrame = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];    
        UIWindow *window = [[UIApplication sharedApplication] windows][0];
        //UIView *mainSubviewOfWindow = window.rootViewController.view;
        UIView *mainSubviewOfWindow = self.textView;
        CGRect keyboardFrameConverted = [mainSubviewOfWindow convertRect:keyboardFrame fromView:window];

        self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, keyboardFrameConverted.origin.y);
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

#pragma mark - UIActionSheetDelegate

- (void)         actionSheet:(UIActionSheet *)actionSheet
  willDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([actionSheet.title isEqualToString:MADSAppearAlertTitle]) {
        if (buttonIndex < 5) {
            [self changeAnimationType:buttonIndex];
        }
    } else if ([actionSheet.title isEqualToString:MADSAutocloseAlertTitle]) {
        [self changeAutoCloseAfterClick:buttonIndex];
    }
}

#pragma mark - Frame Description

- (void)addFrameDescription {
    self.frameDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 ,
                                                          CGRectGetHeight(self.frame) - 35,
                                                          CGRectGetWidth(self.frame) - 80,
                                                          30)];
    self.frameDescriptionLabel.textColor = [UIColor colorWithRed:0.964705 green:0.556862 blue:0.117647 alpha:1.0];
    [self.frameDescriptionLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    self.frameDescriptionLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.frameDescriptionLabel];
}

- (void)setDescriptionForFrame:(CGRect)frame {
    self.frameDescriptionLabel.text = [NSString stringWithFormat:@"scale = %li, x = %li, y = %li, width = %li, height = %li", (long)[[UIScreen mainScreen] scale], (long)CGRectGetMinX(frame), (long)CGRectGetMinY(frame), (long)CGRectGetWidth(frame), (long)CGRectGetHeight(frame)];
}

@end
