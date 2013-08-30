//
//  ProjectEntry.h
//  EITOnlineTimeSheet
//
//  Created by dave on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ClientEntry : NSObject {
	int nClientID;
	NSString *sClient;    
    NSMutableArray *aProjects;
}
@property (nonatomic) int nClientID;
@property (nonatomic, retain) NSString *sClient;
@property (nonatomic, retain) NSMutableArray *aProjects;
@end
