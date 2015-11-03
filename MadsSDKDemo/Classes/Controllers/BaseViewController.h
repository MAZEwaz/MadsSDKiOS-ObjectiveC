//
//  BaseViewController.h
//  MadsDemo
//
//  Created by Alexander van Elsas on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdConfigViewDelegate.h"
#import <UIKit/UIKit.h>


@class AdConfigView;

@interface MadsDemoGridView : UIView
@property(nonatomic, assign) float cellSize;
@property(nonatomic, assign) UIColor* color;
@end

@interface BaseViewController : UIViewController <AdConfigViewDelegate>
{
    AdConfigView *_adConfigView;
    NSString     *_currentZone;
    BOOL          _showJSON;
}
@property(nonatomic,strong) AdConfigView *adConfigView;
@property(nonatomic, copy)  NSString     *currentZone;
@property(nonatomic, strong) MadsDemoGridView *gridView;
@property(nonatomic, strong) MadsDemoGridView *gridView2;
@property(nonatomic, assign) BOOL hideGrid;

- (void)placeConfigWindowAboveFrame:(CGRect)frame;
- (void)placeConfigWindowBelowFrame:(CGRect)frame;
- (void)placeConfigWindowBelowFrame:(CGRect)frame callbackBlock:(void(^)(void))callbackBlock;
- (void)updateZone:(NSString *)zone;

@end
