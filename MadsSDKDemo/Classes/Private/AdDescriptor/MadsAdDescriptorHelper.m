//
//  AdDescriptorHelper.m
//  AdMobileSDK
//
//  Created by Constantine Mureev on 3/3/11.
//

#import "MadsAdDescriptorHelper.h"
#import "MadsOrmmaConstants.h"
#import "MadsJSConstants.h"

@interface MadsAdDescriptorHelper()

+ (BOOL)isLandscapeMode;
+ (BOOL)isStatusBarHidden;

@end

@implementation MadsAdDescriptorHelper

+ (BOOL)isMedialetsContent:(NSString *)data
{
	NSRange textRange = [data rangeOfString:@"medialets:launchAd?"];
	
	return textRange.location != NSNotFound;
}

+ (BOOL)isVideoContent:(NSString *)data
{
	NSRange textRange = [data rangeOfString:@"<video"];
	
	return textRange.location != NSNotFound;
}


+ (BOOL)isExternalCampaign:(NSString *)data
{
	NSRange textRange = [data rangeOfString:@"<!-- client_side_external_campaign"];
	
	return textRange.location != NSNotFound;
}

+ (NSString*)stringByStrippingHTMLcomments:(NSString *)html {
    NSScanner *thescanner;
    NSString *text = nil;
    
    if ([html rangeOfString:@"<!--//"].location == NSNotFound) {
        thescanner = [NSScanner scannerWithString:html];
        
        while ([thescanner isAtEnd] == NO) {
            
            // find start of tag
            [thescanner scanUpToString:@"<!--" intoString:nil] ; 
            
            // find end of tag
            [thescanner scanUpToString:@"-->" intoString:&text] ;
            
            // replace the found tag with a space
            //(you can filter multi-spaces out later if you wish)
            html = [html stringByReplacingOccurrencesOfString:
                    [NSString stringWithFormat:@"%@-->", text] withString:@""];
            
        } // while //
    }
    
    return html;	
}


+ (NSString*)wrapHTML:(NSString *)data frameSize:(CGSize)frameSize aligmentCenter:(BOOL)aligmentCenter {
	/*NSString* html = [NSString stringWithFormat:@"<html><head><style> body { margin:0; padding:0; }</style><script type=\"text/javascript\">%@ %@</script></head><body>%@</body></html>",kJavaScript_ormma_bridge,kJavaScript_ormma, data];
     */
    NSString* html = nil;
    
    float bannerWidth = [UIScreen mainScreen].applicationFrame.size.width;
    
    if ([self isLandscapeMode]) {
        bannerWidth = [UIScreen mainScreen].applicationFrame.size.height;
    } else if ([self isStatusBarHidden]) {
        bannerWidth += [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    
    if (aligmentCenter) {
         html = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/><style> body { margin:0; padding:0; } img { max-width:%.0f; }</style><script type=\"text/javascript\">%@</script>%@<script type=\"text/javascript\">%@</script></head><body><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\" align=\"center\" width=\"device-width\" height=\"device-height\"><tr ><td align=\"center\" valign=\"middle\" height=\"%.0f\"><div id=\"contentheight\"><span id=\"contentwidth\">%@</span></div></td></tr></table></body></html>", bannerWidth, ORMMA_JS, ORMMA_PLACEHOLDER, frameSize.height, MADS_JS, data];
     } else {
         html = [NSString stringWithFormat:@"<html><head><meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/><style> body { margin:0; padding:0; } img { max-width:%.0f; }</style><script type=\"text/javascript\">%@</script>%@<script type=\"text/javascript\">%@</script></head><body><div id=\"contentheight\"><span id=\"contentwidth\">%@</span></div></body></html>", bannerWidth, ORMMA_JS, ORMMA_PLACEHOLDER, MADS_JS, data];
    }
    return html;
}

+ (BOOL)isLandscapeMode {
    return ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft || [UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight);
}

+ (BOOL)isStatusBarHidden {
    return [[UIApplication sharedApplication] isStatusBarHidden];
}

@end
