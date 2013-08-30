//
//  ConfigMgr.h
//  EITOnlineTimeSheet
//
//  Created by dave on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface ConfigMgr : NSObject{
    NSString *sServerName;
    NSString *sServiceName;
//    BOOL bAutoLogin;
    BOOL bStayLoggedIn;
    BOOL bShowMoreInfo;
    BOOL bShowDebugInfo;
    BOOL bShowQuickView;
    BOOL bUseGeoFencing;
    BOOL bShowSeconds;
    BOOL bShowDescriptions;
    NSString *sDefaultMandate;
    NSString *sDefaultUser;
    NSString *sDefaultPassword;
    
    int iduser;
    NSMutableArray *aClients;
    NSMutableArray *aProjects;
    NSMutableArray *aWorkcodes;
    NSMutableArray *aWaypoints;
}

@property (nonatomic, retain) NSString *sServerName;
@property (nonatomic, retain) NSString *sServiceName;
//@property (nonatomic) BOOL bAutoLogin;
@property (nonatomic) BOOL bStayLoggedIn;
@property (nonatomic) BOOL bShowMoreInfo;
@property (nonatomic) BOOL bShowDebugInfo;
@property (nonatomic) BOOL bShowQuickView;
@property (nonatomic) BOOL bUseGeoFencing;
@property (nonatomic) BOOL bShowSeconds;
@property (nonatomic) BOOL bShowDescriptions;
@property (nonatomic, retain) NSString *sDefaultMandate;
@property (nonatomic, retain) NSString *sDefaultUser;
@property (nonatomic, retain) NSString *sDefaultPassword;
@property (nonatomic) int iduser;

@property (nonatomic, retain) NSMutableArray *aClients;
@property (nonatomic, retain) NSMutableArray *aProjects;
@property (nonatomic, retain) NSMutableArray *aWorkcodes;
@property (nonatomic, retain) NSMutableArray *aWaypoints;

- (BOOL) saveData;
- (ConfigMgr*) initWithName : (NSString*) aName;
- (void) loadDefault;
@end
