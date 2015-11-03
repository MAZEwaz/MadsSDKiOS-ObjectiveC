//
//  AdDescriptor.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import <Foundation/Foundation.h>


typedef enum {
	AdContentTypeUndefined = 0,
    AdContentTypeEmpty,
    AdContentTypeInvalidParams,
	AdContentTypeDefaultHtml,
} MadsAdContentType;


@interface MadsAdDescriptor : NSObject {
}

@property (assign) MadsAdContentType adContentType;
@property (assign) BOOL externalCampaign;
@property (retain) NSDictionary* externalContent;
@property (retain) NSString* appId;
@property (retain) NSString* adId;
@property (retain) NSString* adType;
@property (retain) NSString* latitude;
@property (retain) NSString* longitude;
@property (retain) NSString* zip;
@property (retain) NSString* campaignId;
@property (retain) NSString* trackUrl;
@property (retain) NSData* serverReponse;
@property (retain) NSString* serverReponseString;

+ (MadsAdDescriptor*)descriptorFromContent:(NSData*)data frameSize:(CGSize)frameSize;

@end
