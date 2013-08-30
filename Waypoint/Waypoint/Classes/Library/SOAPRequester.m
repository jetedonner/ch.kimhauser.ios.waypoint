//
//  SOAPRequester.m
//  EITOnlineTimeSheet
//
//  Created by dave on 4/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SOAPRequester.h"


@implementation SOAPRequester

@synthesize webData;
@synthesize soapResults;
@synthesize conn;
//@synthesize delegate;

- (void) gotSOAPAnswere: (NSObject*)requester answere:(NSString*)sXMLAnswere data:(NSData*)data{

}

- (void) errorSOAPRequest: (NSObject*)requester error:(NSError*)error{
}

- (void)setDelegate:(id)val{
	delegate = val;
}

- (id)delegate{
	return delegate;
}
- (void)sendSOAPRequest:(ConfigMgr*)configMgr message:(NSString *)sSOAPAction od:(OrderedDictionary*)od
{
    NSMutableString *soapMsg;
    
    soapMsg = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">                        <soap:Body><%@ xmlns=\"http://%@/\">", sSOAPAction, configMgr.sServerName];
    
    if(od != nil){
        
        /*for (int i = 0; i < mutableDict.count; i++) {
            NSArray* arr234 = [mutableDict allKeys];
        }
        
        int i = 0;*/
        NSEnumerator *enumerator = [od keyEnumerator];
        id key;
        
        while ( key = [enumerator nextObject] ) {
            [soapMsg appendString:[NSString stringWithFormat:@"<%@>%@</%@>",[key description], [[od objectForKey: key] description],[key description]]];
        }
    }
    
    [soapMsg appendString:[NSString stringWithFormat:@"</%@></soap:Body></soap:Envelope>",sSOAPAction]];
    
	NSLog(@"%@",soapMsg);
    
    
	NSString *sURL = [NSString stringWithFormat:@"http://%@%@", configMgr.sServerName, configMgr.sServiceName];
	NSURL *url = [NSURL URLWithString:sURL];
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:[NSString stringWithFormat:@"http://%@%@/%@", configMgr.sServerName, configMgr.sServiceName,sSOAPAction] forHTTPHeaderField:@"SOAPAction"];
    
    //[req addValue:sServer forHTTPHeaderField:@"Host"];
	[req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
	
	conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	if (conn) {
		webData = [NSMutableData data];
	}
}
/*
- (void)sendSOAPRequest:(ConfigMgr*)configMgr:(NSString*)sSOAPAction:(NSMutableDictionary*)mutableDict {
    NSMutableString *soapMsg;
   
    soapMsg = [NSMutableString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">                        <soap:Body><%@ xmlns=\"http://%@/\">", sSOAPAction, configMgr.sServerName];
    
    if(mutableDict != nil){
        
        for (int i = 0; i < mutableDict.count; i++) {
            NSArray* arr234 = [mutableDict allKeys];
        }
        
        int i = 0;
        NSEnumerator *enumerator = [mutableDict keyEnumerator];
        id key;
            
        while ( key = [enumerator nextObject] ) {
            [soapMsg appendString:[NSString stringWithFormat:@"<%@>%@</%@>",[key description], [[mutableDict objectForKey: key] description],[key description]]];
            }
    }
    
    [soapMsg appendString:[NSString stringWithFormat:@"</%@></soap:Body></soap:Envelope>",sSOAPAction]];
    
	NSLog(soapMsg);
    
	NSString *sURL = [NSString stringWithFormat:@"http://%@%@", configMgr.sServerName, configMgr.sServiceName];
	NSURL *url = [NSURL URLWithString:sURL];
	
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
	
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMsg length]];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:[NSString stringWithFormat:@"http://%@%@/%@", configMgr.sServerName, configMgr.sServiceName,sSOAPAction] forHTTPHeaderField:@"SOAPAction"];
    
    //[req addValue:sServer forHTTPHeaderField:@"Host"];
	[req addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody: [soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
	
	conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
	if (conn) {
		webData = [[NSMutableData data] retain];
	}
}*/


-(void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response {
	[webData setLength: 0];
}

-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data {
	[webData appendData:data];
}

-(void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error {
    NSLog(@"%@", [error description]);
	//[webData release];
    [delegate errorSOAPRequest:self error:error];
    //[connection release];
}

-(void) connectionDidFinishLoading:(NSURLConnection *) connection {
    NSLog(@"DONE. Received Bytes: %d", [webData length]);
    NSString *theXML = [[NSString alloc] 
                        initWithBytes: [webData mutableBytes] 
                        length:[webData length] 
                        encoding:NSUTF8StringEncoding];

    NSLog(@"%@", theXML);
    [delegate gotSOAPAnswere:self answere:theXML data:webData];
    //[theXML release];    

	
	//if(xmlParser){
	//	[xmlParser release];
	//}
	
	//xmlParser = [[NSXMLParser alloc] initWithData:webData];
	//[xmlParser setDelegate: self];
	//[xmlParser setShouldResolveExternalEntities: YES];
	//[xmlParser parse];
	
	
	//[activityIndicator stopAnimating];    
	//if([delegate respondsToSelector:@selector(delegateFunction1:)]){
	//	[delegate delegateFunction1];
	//}
    
    //[connection release];
    //[webData release];
}


@end
