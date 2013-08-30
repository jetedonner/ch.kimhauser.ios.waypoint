//
//  ProjectEntry.h
//  EITOnlineTimeSheet
//
//  Created by dave on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProjectEntry : NSObject {
	int nProjectID;
	NSString *sProjectName;
}
@property (nonatomic) int nProjectID;
@property (nonatomic, retain) NSString *sProjectName;

@end
