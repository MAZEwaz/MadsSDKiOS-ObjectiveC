//
//  NotificationCenter.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import <Foundation/Foundation.h>

#import "MadsNotificationAtlas.h"
#import "MadsNotificationCenterAdditions.h"


@interface MadsNotificationCenter : NSNotificationCenter {

}

+ (MadsNotificationCenter*)sharedInstance;
+ (void)releaseSharedInstance;

@end
