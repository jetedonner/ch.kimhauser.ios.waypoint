//
//  XMLReader.h
//  EITOnlineTimeSheet
//
//  Created by dave on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol XMLReaderDelegate
- (void) foundXMLElement: (NSObject*)sourceXmlReader element:(NSString*)sElementName value:(NSMutableString*)sValue;
//- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error;
@end

@interface XMLReader : NSObject<NSXMLParserDelegate>{

    //---web service access---
    //NSMutableData *webData;
    //NSMutableString *soapResults;
    //NSURLConnection *conn;
    
	//---xml parsing---
	NSXMLParser *xmlParser;
	BOOL elementFound;
    NSMutableString *soapResults;
	id <NSObject, XMLReaderDelegate > delegate;
    NSMutableArray *aElementsToFind;
}
@property (retain) id <NSObject,XMLReaderDelegate> delegate;
@property (nonatomic, retain) NSMutableString *soapResults;
@property (nonatomic, retain) NSMutableArray *aElementsToFind;

- (void) parseForElements:(NSMutableArray*)aElements data:(NSData*)data;
@end
