//
//  TimeSheetEntry.h
//  EITOnlineTimeSheet
//
//  Created by dave on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSheetEntry : NSObject {
	NSString *nID;
	NSString *tHoursWorked;
	NSString *dStartTime;
	NSString *dEndTime;
	NSString *sDescription;
	NSString *nClientID;
	NSString *sClient;
	NSString *nProjectID;
	NSString *sProject;
	NSString *nWorkcodeID;
	NSString *sWorkcode;
	NSString *sWorkdate;    
}
@property (nonatomic, retain) NSString *nID;
@property (nonatomic, retain) NSString *tHoursWorked;
@property (nonatomic, retain) NSString *dStartTime;
@property (nonatomic, retain) NSString *dEndTime;
@property (nonatomic, retain) NSString *sDescription;
@property (nonatomic, retain) NSString *nClientID;
@property (nonatomic, retain) NSString *sClient;
@property (nonatomic, retain) NSString *nProjectID;
@property (nonatomic, retain) NSString *sProject;
@property (nonatomic, retain) NSString *nWorkcodeID;
@property (nonatomic, retain) NSString *sWorkcode;
@property (nonatomic, retain) NSString *sWorkdate;
@end
