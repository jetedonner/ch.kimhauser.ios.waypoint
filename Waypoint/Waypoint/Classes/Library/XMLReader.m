//
//  XMLReader.m
//  EITOnlineTimeSheet
//
//  Created by dave on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLReader.h"

@implementation XMLReader

@synthesize soapResults;
@synthesize delegate;
@synthesize aElementsToFind;

- (void)setDelegate:(id)val{
	delegate = val;
}

- (id)delegate{
	return delegate;
}

- (void) parseForElements:(NSMutableArray*)aElements:(NSData*)data{
    //NSLog(theXML);
    self.aElementsToFind = aElements;
	xmlParser = [[NSXMLParser alloc] initWithData:data];
	[xmlParser setDelegate: self];
    [xmlParser setShouldProcessNamespaces:NO];
    [xmlParser setShouldReportNamespacePrefixes:NO];
    [xmlParser setShouldResolveExternalEntities:NO];
	[xmlParser parse];
    
}

//---when the start of an element is found---
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
 {
     for (NSString *str in aElementsToFind) {
         //NSLog(str);
         if( [elementName isEqualToString:str]) {
             if (!soapResults) {
                 soapResults = [[NSMutableString alloc] init];
             }
             elementFound = YES;
             break;
         }
     }
}

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    if (elementFound)
    {
        [soapResults appendString:string];
    }
}

//---when the end of element is found---
-(void)parser:(NSXMLParser *)parser 
didEndElement:(NSString *)elementName 
 namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName
{
    for (NSString *str in aElementsToFind) {
        //NSLog(str);s
        if( [elementName isEqualToString:str]) {
            [delegate foundXMLElement:self :elementName :soapResults];
            
            [soapResults setString:@""];
            elementFound = FALSE;
            
            break;
        }
    }
}


@end
