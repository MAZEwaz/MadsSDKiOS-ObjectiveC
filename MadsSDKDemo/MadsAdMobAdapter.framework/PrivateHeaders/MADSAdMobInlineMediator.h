//
//  MADSAdMobConfigurator.h
//  MadsAdMobAdapter
//
//  Created by Yevhen Herasymenko on 30/06/2015.
//  Copyright (c) 2015 MADS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MADSAdMobInlineDelegate.h"

@interface MADSAdMobInlineMediator : NSObject

- (instancetype)initWithParameters:(NSDictionary *)parameters
                          delegate:(id<MADSAdMobInlineDelegate>)delegate;
- (void)execute;

@end
