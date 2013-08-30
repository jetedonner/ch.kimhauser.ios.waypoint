//
//  DateHelper.m
//  OnlineTimeSheet
//
//  Created by Imran on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

/*-(DateHelper*) init
{
    //[super init];
}*/

-(NSDate*)dateFromShortString:(NSString*)sShortDate{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSString *sTmp = [NSString stringWithFormat:@"%@ 00:00:00", sShortDate];
    NSDate *dFrom = [df dateFromString:sTmp];
    //[df release];
    return dFrom;
}

-(NSString*)shortStringFromDate:(NSDate*)dDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.yyyy"];
    //df.dateStyle = NSDateFormatterMediumStyle;
    NSString *sTmp = [NSString stringWithFormat:@"%@", [df stringFromDate:dDate]];
    //[df release];
    return sTmp;
}

-(NSString*)shortStringFromDateSql:(NSDate*)dDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    //df.dateStyle = NSDateFormatterMediumStyle;
    NSString *sTmp = [NSString stringWithFormat:@"%@", [df stringFromDate:dDate]];
    //[df release];
    return sTmp;
}

-(NSString*)longStringFromDate:(NSDate*)dDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEEE dd. MMMM yyyy"];
    //df.dateStyle = NSDateFormatterMediumStyle;
    NSString *sTmp = [NSString stringWithFormat:@"%@", [df stringFromDate:dDate]];
    //[df release];
    return sTmp;
}

-(NSDate*)dateFromStrings:(NSString*)sDate format:(NSString*)sFormat{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:sFormat];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSString *sTmp = [NSString stringWithFormat:@"%@", sDate];
    NSDate *dFrom = [df dateFromString:sTmp];
    //[df release];
    return dFrom;
}

-(NSString*)stringFromDate:(NSDate*)dDate format:(NSString*)sFormat{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:sFormat];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSString *sTmp = [df stringFromDate:dDate];
    //[df release];
    return sTmp;
}

-(NSDate*)dateAddDay:(NSDate*)dDate days:(int)nDays{
    //return [dDate addTimeInterval:60*60*24*nDays];
    //NSTimeInterval *ti = [[NSTimeI]]
    NSTimeInterval delta = 60*60*24*nDays;
    return [dDate dateByAddingTimeInterval:delta];
}

@end
