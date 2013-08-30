//
//  ConfigMgr.m
//  EITOnlineTimeSheet
//
//  Created by dave on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ConfigMgr.h"
#import "CommonFunctions.h"

@implementation ConfigMgr

@synthesize sServerName;
@synthesize sServiceName;
//@synthesize bAutoLogin;
@synthesize bStayLoggedIn;
@synthesize bShowDebugInfo;
@synthesize bShowMoreInfo;
@synthesize bShowQuickView;
@synthesize bUseGeoFencing;
@synthesize bShowSeconds;
@synthesize bShowDescriptions;
@synthesize sDefaultMandate;
@synthesize sDefaultUser;
@synthesize sDefaultPassword;

@synthesize iduser;
@synthesize aClients;
@synthesize aProjects;
@synthesize aWorkcodes;
@synthesize aWaypoints;


-(ConfigMgr*) initWithName : (NSString*) aName
{
    // This also demonstrates the self and super keywords briefly
    self = [super init];
    [self loadData];    
    
    return self;
    
}
- (void) loadData{
    // Bill: Note that some will claim that self.name = name is wrong;  you shouldn't use accessors in initializer.  I don't happen to agree.
    //if (self)
    //    self.name = aName;
    // Do any additional setup after loading the view from its nib.
    // Data.plist code
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"WaypointConfig.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get property list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"WaypointConfig" ofType:@"plist"];
    }
    
    // read property list into memory as an NSData object
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    // convert static property liost into dictionary object
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp)
    {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    self.sServerName  = [temp objectForKey:@"ServerName"];
    self.sServiceName = [temp objectForKey:@"ServiceName"];
    
    self.sDefaultMandate  = [temp objectForKey:@"DefaultMandate"];
    self.sDefaultUser = [temp objectForKey:@"DefaultUser"];
    self.sDefaultPassword = [temp objectForKey:@"DefaultPassword"];
    
    //NSString *sTmp = [temp objectForKey:@"StayLoggedIn"];
    /*if([[temp objectForKey:@"AutoLogin"] isEqualToString:@"FALSE"]){
        self.bAutoLogin = FALSE;
    }else{
        self.bAutoLogin = TRUE;
    }*/
    
    if([[temp objectForKey:@"StayLoggedIn"] isEqualToString:@"FALSE"]){
        self.bStayLoggedIn = FALSE;
    }else{
        self.bStayLoggedIn = TRUE;    
    }

    if([[temp objectForKey:@"ShowMoreInfo"] isEqualToString:@"FALSE"]){
        self.bShowMoreInfo = FALSE;
    }else{
        self.bShowMoreInfo = TRUE;
    }
    
    if([[temp objectForKey:@"ShowDebugInfo"] isEqualToString:@"FALSE"]){
        self.bShowDebugInfo = FALSE;
    }else{
        self.bShowDebugInfo = TRUE;    
    }
    
    if([[temp objectForKey:@"ShowQuickView"] isEqualToString:@"FALSE"]){
        self.bShowQuickView = FALSE;
    }else{
        self.bShowQuickView = TRUE;    
    }
    
    if([[temp objectForKey:@"UseGeoFencing"] isEqualToString:@"FALSE"]){
        self.bUseGeoFencing = FALSE;
    }else{
        self.bUseGeoFencing = TRUE;    
    }
    
    if([[temp objectForKey:@"ShowSeconds"] isEqualToString:@"FALSE"]){
        self.bShowSeconds = FALSE;
    }else{
        self.bShowSeconds = TRUE;    
    }
    
    if([[temp objectForKey:@"ShowDescriptions"] isEqualToString:@"FALSE"]){
        self.bShowDescriptions = FALSE;
    }else{
        self.bShowDescriptions = TRUE;    
    }
    /*self.bStayLoggedIn = [temp objectForKey:@"StayLoggedIn"];
     self.bShowDebugInfo = [temp objectForKey:@"ShowDebugInfo"];
     */
}

- (void) loadDefault{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WaypointConfig" ofType:@"plist"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath2 = [documentsPath stringByAppendingPathComponent:@"WaypointConfig.plist"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    //check if destinationFolder exists
    if ([ fileManager fileExistsAtPath:plistPath2])
    {
        //removing destination, so soucer may be copied
        if (![fileManager removeItemAtPath:plistPath2 error:&error])
        {
            NSLog(@"Could not remove old files. Error:%@",error);
            [CommonFunctions showMessageBox:@"Error remove" message:error.description];
        }
    }
    
    BOOL bSuccess = [fileManager copyItemAtPath:plistPath toPath:plistPath2 error:&error];
    if (bSuccess) {
        [self loadData];
        [CommonFunctions showMessageBox:@"Success" message:@"Default config loaded!"];
    }else {
        [CommonFunctions showMessageBox:@"Error copy" message:error.description];
    }

}

- (BOOL) saveData
{
    // get paths from root direcory
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    // get documents path
    NSString *documentsPath = [paths objectAtIndex:0];
    // get the path to our Data/plist file
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"WaypointConfig.plist"];
    
    // set the variables to the values in the text fields
    //self.personName = nameEntered.text;
    /*self.phoneNumbers = [[NSMutableArray alloc] initWithCapacity:3];
    [phoneNumbers addObject:homePhone.text];
    [phoneNumbers addObject:workPhone.text];
    [phoneNumbers addObject:cellPhone.text];
    */
    // create dictionary with values in UITextFields

    //NSString *sAutoLogin = bAutoLogin ? @"TRUE" : @"FALSE";
    NSString *sStayLoggedIn = bStayLoggedIn ? @"TRUE" : @"FALSE";
    NSString *sShowMoreInfo = bShowMoreInfo ? @"TRUE" : @"FALSE";
    NSString *sShowDebugInfo = bShowDebugInfo ? @"TRUE" : @"FALSE";
    NSString *sShowQuickView = bShowQuickView ? @"TRUE" : @"FALSE";
    NSString *sUseGeoFencing = bUseGeoFencing ? @"TRUE" : @"FALSE";
    NSString *sShowSeconds = bShowSeconds ? @"TRUE" : @"FALSE";
    NSString *sShowDescription = bShowDescriptions ? @"TRUE" : @"FALSE";
    
    /*NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: sServerName,sServiceName,sStayLoggedIn,sShowDebugInfo,sShowQuickView,sDefaultMandate,nil] forKeys:[NSArray arrayWithObjects: @"ServerName", @"ServiceName",@"StayLoggedIn",@"ShowDebugInfo",@"ShowQuickView",@"DefaultMandate",nil]];*/
    
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: 
                               [NSArray arrayWithObjects: 
                                sServerName,
                                sServiceName,
//                                sAutoLogin,
                                sStayLoggedIn,
                                sShowMoreInfo,
                                sShowDebugInfo,
                                sShowQuickView,
                                sUseGeoFencing,
                                sShowSeconds,
                                sShowDescription,
                                sDefaultMandate,
                                sDefaultUser,
                                sDefaultPassword,nil] 
                            forKeys:[NSArray arrayWithObjects: 
                                     @"ServerName", 
                                     @"ServiceName",
//                                     @"AutoLogin",
                                     @"StayLoggedIn",
                                     @"ShowMoreInfo",
                                     @"ShowDebugInfo",
                                     @"ShowQuickView",
                                     @"UseGeoFencing",
                                     @"ShowSeconds",
                                     @"ShowDescriptions",                                     
                                     @"DefaultMandate",
                                     @"DefaultUser", 
                                     @"DefaultPassword", nil]];
    
    NSString *error = nil;
    // create NSData from dictionary
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    
    // check is plistData exists
    if(plistData)
    {
        // write plistData to our Data.plist file
        [plistData writeToFile:plistPath atomically:YES];
        return TRUE;
        
    }
    else
    {
        NSLog(@"Error in saveData: %@", error);
        //[error release];
        return FALSE;
    }
}

@end
