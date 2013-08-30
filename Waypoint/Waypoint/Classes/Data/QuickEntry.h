//
//  QuickEntry.h
//  OnlineTimeSheet
//
//  Created by dave on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum quickEntryType
{
    QE_WORKTIME,
    QE_PAUSE
} QuickEntryType;

@interface QuickEntry : NSObject{

    IBOutlet NSDate *startTime;
    IBOutlet NSDate *endTime;
    QuickEntryType qeType;
    
}

@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, retain) NSDate *endTime;
@property (nonatomic) QuickEntryType qeType;

@end
