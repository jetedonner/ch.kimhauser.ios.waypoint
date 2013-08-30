//
//  WorkcodeEntry.h
//  EITOnlineTimeSheet
//
//  Created by dave on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WorkcodeEntry : NSObject {
	int nWorkcodeID;
	NSString *sWorkcode;
}
@property (nonatomic) int nWorkcodeID;
@property (nonatomic, retain) NSString *sWorkcode;

@end
