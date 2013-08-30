//
//  MinMaxDateEntry.h
//  EITOnlineTimeSheet
//
//  Created by dave on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MinMaxDateEntry : NSObject {
	NSString *sDate;
	NSString *sMin;
	NSString *sMax;
    int nMinHour;
    int nMinMinute;
    int nMinSecond;    
    int nMaxHour;
    int nMaxMinute;
    int nMaxSecond;
	NSString *sWorkTime;
}
@property (nonatomic, retain) NSString *sDate;
@property (nonatomic, retain) NSString *sMin;
@property (nonatomic, retain) NSString *sMax;
@property (nonatomic) int nMinHour;
@property (nonatomic) int nMinMinute;
@property (nonatomic) int nMinSecond;
@property (nonatomic) int nMaxHour;
@property (nonatomic) int nMaxMinute;
@property (nonatomic) int nMaxSecond;
@property (nonatomic, retain) NSString *sWorkTime;
@end
