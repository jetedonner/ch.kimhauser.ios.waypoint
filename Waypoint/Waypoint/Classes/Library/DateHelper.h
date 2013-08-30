//
//  DateHelper.h
//  OnlineTimeSheet
//
//  Created by Imran on 03.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface DateHelper : NSObject {

}

-(NSDate*)dateFromShortString:(NSString*)sShortDate;
-(NSString*)shortStringFromDate:(NSDate*)dDate;
-(NSString*)shortStringFromDateSql:(NSDate*)dDate;

-(NSString*)longStringFromDate:(NSDate*)dDate;

-(NSDate*)dateFromStrings:(NSString*)sDate:(NSString*)sFormat;
-(NSString*)stringFromDate:(NSDate*)dDate:(NSString*)sFormat;

-(NSDate*)dateAddDay:(NSDate*)dDate:(int)nDays;

@end
