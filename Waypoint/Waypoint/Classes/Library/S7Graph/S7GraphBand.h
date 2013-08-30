//
//  S7GraphBand.h
//  EITOnlineTimeSheet
//
//  Created by dave on 4/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface S7GraphBand : NSObject {
	int nStart;
	int nStop;
	double nStart2;
	double nStop2;
    CGColorRef bandColor;
}

@property (nonatomic, assign) CGColorRef bandColor;
@property (nonatomic) int nStart;
@property (nonatomic) int nStop;
@property (nonatomic) double nStart2;
@property (nonatomic) double nStop2;
@end 
