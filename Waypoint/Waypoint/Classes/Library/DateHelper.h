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

-(NSDate*)dateFromStrings:(NSString*)sDate format:(NSString*)sFormat;
-(NSString*)stringFromDate:(NSDate*)dDate format:(NSString*)sFormat;

-(NSDate*)dateAddDay:(NSDate*)dDate days:(int)nDays;

@end
