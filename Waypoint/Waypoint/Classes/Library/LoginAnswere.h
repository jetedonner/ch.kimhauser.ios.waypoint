//
//  WorkcodeEntry.h
//  EITOnlineTimeSheet
//
//  Created by dave on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LoginAnswere : NSObject {
	int nResult;
    int nUserID;
    int nMandateID;
    NSString *sUsername;
    NSString *sSessionID;
}
@property (nonatomic) int nResult;
@property (nonatomic) int nUserID;
@property (nonatomic) int nMandateID;
@property (nonatomic, retain) NSString *sUsername;
@property (nonatomic, retain) NSString *sSessionID;

@end
