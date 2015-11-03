//
//  MadsAdCell.m
//  MadsSDKDemo
//
//  Created by VimSolution on 7/7/15.
//
//

#import "MadsAdCell.h"
#import <MadsSDK/MadsSDK.h>

@implementation MadsAdCell

- (void)prepareForReuse {
    [self.adView removeFromSuperview];
}

@end
