//
//  AdConfigView.h
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdConfigViewDelegate.h"
#import <MadsSDK/MadsSDK.h>


typedef NS_ENUM(NSInteger, MadsAdPosition) {
    MadsAdPositionTop,
    MadsAdPositionCenter,
    MadsAdPositionBottom,
    MadsAdPositionScrollingDown
};


@interface AdConfigView : UIView <UITextFieldDelegate, UITextViewDelegate>
{
    id<AdConfigViewDelegate> __weak _delegate;
    UIActivityIndicatorView *_spinner;
    UILabel *_statusLabel;
    UILabel *_titleLabel;
    UILabel *_testServerModeLabel;
    
    MadsAdPosition _position;
    MadsAdAnimationType _animationType;
    BOOL _isAutoCloseAfterClick;
}
@property (nonatomic, weak) id<AdConfigViewDelegate> delegate;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *testServerModeLabel;
@property (nonatomic, assign) MadsAdPosition position;
@property (nonatomic, assign) MadsAdAnimationType animationType;
@property (assign, nonatomic) BOOL isAutoCloseAfterClick;

// note that the view requires a minimum width and height.
// If the dev sets this too low, we replace the values
- (id)initWithFrame:(CGRect)frame
           delegate:(id)delegate
               zone:(NSString *)zone;
- (void)updateZone:(NSString *)zone;
- (void)updateTitle:(NSString *)title;
- (void)updateTestServerModeLabel;
- (NSString *)currentZone;
- (CGSize)minSize;
- (CGSize)maxSize;

// A vc can turn the spinner on and off when activities are started and stopped
- (void)spinnerOn;
- (void)spinnerOff;

// returns HTML that needs to be loaded, else nil
- (NSString *)getHTML;

- (void)hideAdPositionControls:(BOOL)hidden;
- (void)showAdSizeControls;

- (void)setupOverlayAutoCloseButton;

- (void)enterHTML:(NSString *)text;

- (void)setDescriptionForFrame:(CGRect)frame;

- (void)setupCreateModalButton;

- (void)setupADSizeUI:(BOOL)isLandscape;

@end
