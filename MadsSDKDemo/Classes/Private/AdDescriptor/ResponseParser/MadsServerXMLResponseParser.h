//
//  ServerResponseParser.h
//  AdMobileSDK
//
//  Created by Constantine Mureev on 10/8/10.
//

#import <Foundation/Foundation.h>

#import "MadsAdDescriptor.h"


// Delegate support not implemented yet

@protocol ServerXMLResponseParserDelegate <NSObject>

- (void)xmlParsingFinished:(id)sender;
- (void)xmlReadError:(id)sender;

@end


@interface MadsServerXMLResponseParser : NSObject <NSXMLParserDelegate> {
	NSXMLParser*	      _parser;
	BOOL              _startSynchronous;
	NSString*         _propertyName;
	NSMutableString*	  _propertyContent;
	NSString*         _campaignId;
	MadsAdContentType _adContentType;
	NSString*         _trackUrl;
	NSString*         _appId;
	NSString*         _adId;
	NSString*         _adType;
}

//@property (nonatomic, assign) id <ServerXMLResponseParserDelegate> delegate;

@property (retain) NSXMLParser*	parser;

@property (retain) NSString* propertyName;
@property (retain) NSMutableString* propertyContent;
@property (retain) NSMutableDictionary* content;
@property (readonly) MadsAdContentType adContentType;
@property (retain) NSString* campaignId;
@property (retain) NSString* trackUrl;
@property (retain) NSString* appId;
@property (retain) NSString* adId;
@property (retain) NSString* adType;
@property (retain) NSString* latitude;
@property (retain) NSString* longitude;
@property (retain) NSString* zip;


- (void) startParseSynchronous:(NSString*)content;

@end
