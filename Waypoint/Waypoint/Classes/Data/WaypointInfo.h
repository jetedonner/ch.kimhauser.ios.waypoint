//
//  WaypointInfo.h
//  Waypoint
//
//  Created by dave on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface WaypointInfo : NSObject{
	int nWaypointId;
    int nClientId;
    int nProjectId;
    int nWorkcodeId;
    double dLat;
    double dLng;
    double dRad;
    NSString *sName;
    NSString *sClient;
    NSString *sProject;
    NSString *sWorkcode;
    
}
@property (nonatomic) int nWaypointId;
@property (nonatomic) int nClientId;
@property (nonatomic) int nProjectId;
@property (nonatomic) int nWorkcodeId;
@property (nonatomic) double dLat;
@property (nonatomic) double dLng;
@property (nonatomic) double dRad;
@property (nonatomic, retain) NSString *sName;
@property (nonatomic, retain) NSString *sClient;
@property (nonatomic, retain) NSString *sProject;
@property (nonatomic, retain) NSString *sWorkcode;

@end
