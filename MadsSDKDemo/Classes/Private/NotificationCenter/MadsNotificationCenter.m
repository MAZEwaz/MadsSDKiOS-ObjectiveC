//
//  NotificationCenter.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import "MadsNotificationCenter.h"

#import "MadsDownloadController.h"
#import "MadsAdController.h"
#import "MadsInternalBrowser.h"
#import "MadsLogger.h"
#import "MadsSharedModel.h"
#import "MadsAdClicker.h"
#import "MadsInternalAVPlayer.h"


@implementation MadsNotificationCenter

static MadsNotificationCenter* sharedInstance = nil;

#pragma mark -
#pragma mark Singleton

- (id) init {
    self = [super init];
	if (self) {
	}
	
	return self;
}

+ (id)sharedInstance {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [[self alloc] init];
            
			
            if (![MadsLogger sharedInstance]) {
				// somtheing going wrong...
			}
            
            if (![MadsSharedModel sharedInstance]) {
				// somtheing going wrong...
			}
            
			if (![MadsAdController sharedInstance]) {
				// somtheing going wrong...
			}
			
            if (![MadsDownloadController sharedInstance]) {
				// somtheing going wrong...
			}
			
            if (![MadsAdClicker sharedInstance]) {
				// somtheing going wrong...
			}
			
			if ([NSThread isMainThread]) {
				if (![MadsInternalBrowser sharedInstance]) {
					// somtheing going wrong...
				}
			}
			else {
				[MadsInternalBrowser performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
			}
			
			if ([NSThread isMainThread]) {
				if (![MadsInternalAVPlayer sharedInstance]) {
					// somtheing going wrong...
				}
			}
			else {
				[MadsInternalAVPlayer performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
			}

		}
	}
	return sharedInstance;
}

- (oneway void)superRelease {	
	[super release];
}

+ (void)releaseSharedInstance {
	@synchronized(self) {
		[sharedInstance superRelease];
		sharedInstance = nil;
	}
}

+ (id)allocWithZone:(NSZone*)zone {
	@synchronized(self) {
		if (nil == sharedInstance) {
			sharedInstance = [super allocWithZone:zone];
		}
	}
	
	return sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone {
	return sharedInstance;
}

- (id)retain {
	return sharedInstance;
}

- (unsigned)retainCount {
	return NSUIntegerMax;
}

- (oneway void)release {
	// Do nothing.
}

- (id)autorelease {
	return sharedInstance;
}


#pragma mark -
#pragma mark Public

@end
