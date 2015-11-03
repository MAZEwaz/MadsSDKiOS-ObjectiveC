//
//  AdDescriptor.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 2/22/11.
//

#import "MadsAdDescriptor.h"
#import "MadsServerXMLResponseParser.h"
#import "MadsAdDescriptorHelper.h"

@implementation MadsAdDescriptor

@synthesize adContentType, externalCampaign, externalContent, appId, adId, adType, latitude,longitude, zip, campaignId, trackUrl, serverReponse, serverReponseString;

+ (MadsAdDescriptor*)descriptorFromContent:(NSData*)data frameSize:(CGSize)frameSize {
	MadsAdDescriptor* adDescriptor = [MadsAdDescriptor  new];
	
	if (data) {
        if ([data length] == 0) {
            adDescriptor.adContentType = AdContentTypeEmpty;
        } else {
            adDescriptor.serverReponse = data;
            adDescriptor.externalCampaign = NO;
            
            NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            adDescriptor.serverReponseString = dataString;
            [dataString release];
            
            adDescriptor.adContentType = AdContentTypeUndefined;
            
            if ([adDescriptor.serverReponseString.lowercaseString rangeOfString:@"<!-- invalid params -->"].location != NSNotFound) {
                adDescriptor.adContentType = AdContentTypeInvalidParams;
            } else if ([adDescriptor.serverReponseString.lowercaseString rangeOfString:@"<!-- error: -1 -->"].location != NSNotFound) {
                adDescriptor.adContentType = AdContentTypeInvalidParams;
            } else if ([MadsAdDescriptorHelper isExternalCampaign:adDescriptor.serverReponseString]) {
                adDescriptor.externalCampaign = YES;
                
                MadsServerXMLResponseParser* _xmlResponseParser = [[MadsServerXMLResponseParser alloc] init];
                [_xmlResponseParser startParseSynchronous:adDescriptor.serverReponseString];
                
                adDescriptor.externalContent = _xmlResponseParser.content;
                
                adDescriptor.adContentType = AdContentTypeUndefined;
                
                [_xmlResponseParser release];
            } else {
                NSString* clearHtml = [MadsAdDescriptorHelper stringByStrippingHTMLcomments:adDescriptor.serverReponseString];
                if ([clearHtml length] > 0) {
                    adDescriptor.adContentType = AdContentTypeDefaultHtml;
                    adDescriptor.serverReponse = [adDescriptor.serverReponseString dataUsingEncoding:NSUTF8StringEncoding];
                } else {
                    adDescriptor.adContentType = AdContentTypeUndefined;
                }
                
            }
        }
	} else {
		adDescriptor.adContentType = AdContentTypeUndefined;
	}
	
	return [adDescriptor autorelease];
}

- (void)dealloc {
    self.externalContent = nil;
	[appId release];
	[adId release];
	[adType release];
	[latitude release];
	[longitude release];
	[zip release];
	[campaignId release];
	[trackUrl release];
	[serverReponse release];
	[serverReponseString release];
	
	[super dealloc];
}

@end
