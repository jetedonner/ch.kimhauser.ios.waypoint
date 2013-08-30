//
//  CommonFunctions.h
//  Waypoint
//
//  Created by Kim David Hauser on 26.06.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFunctions : NSObject

+ (void)showMessageBox:(NSString*)sTitle:(NSString*)sMsg;
+ (void)showYesNoBox:(NSString*)sTitle:(NSString*)sMsg:(id)msgDelegate;
+ (NSString*)stringByReplaceEmDash:(NSString*)sSource;
@end
