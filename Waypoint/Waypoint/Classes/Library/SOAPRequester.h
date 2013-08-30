//
//  SOAPRequester.h
//  EITOnlineTimeSheet
//
//  Created by dave on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigMgr.h"
#import "OrderedDictionary.h"

@protocol SOAPRequesterDelegate
- (void) gotSOAPAnswere: (NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data;
- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error;
@end

@interface SOAPRequester : NSObject<SOAPRequesterDelegate> {

	//---web service access---
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
	
	//---xml parsing---
	NSXMLParser *xmlParser;
	BOOL *elementFound;
	id <NSObject, SOAPRequesterDelegate > delegate;
}

//---web service access---
@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSMutableString *soapResults;
@property (nonatomic, retain) NSURLConnection *conn;

- (void) gotSOAPAnswere: (NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data;
- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error;
- (void)sendSOAPRequest:(ConfigMgr*)configMgr:(NSString*)sSOAPAction:(OrderedDictionary*)od;
- (void)setDelegate:(id)val;

@end
