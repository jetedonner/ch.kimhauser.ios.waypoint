//
//  CommonFunctions.m
//  Waypoint
//
//  Created by Kim David Hauser on 26.06.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import "CommonFunctions.h"

@implementation CommonFunctions

+ (void)showMessageBox:(NSString*)sTitle:(NSString*)sMsg{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:sTitle 
                          message:sMsg
                          delegate:self 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil, 
                          nil];
    
    
    [alert show];
}

+ (void)showYesNoBox:(NSString*)sTitle:(NSString*)sMsg:(id)msgDelegate{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:sTitle 
                          message:sMsg
                          delegate:msgDelegate 
                          cancelButtonTitle:@"No" 
                          otherButtonTitles:@"Yes", 
                          nil];
    
    
    [alert show];
}

+ (NSString*)stringByReplaceEmDash:(NSString*)sSource{
    unichar u[1] = {0x2013};    // I think em-dash is 0x2014
    NSString *emdash = [NSString stringWithCharacters:u length:sizeof(u)
                    / sizeof(unichar)];
    return [sSource stringByReplacingOccurrencesOfString:emdash withString:@"-"];
}

@end
