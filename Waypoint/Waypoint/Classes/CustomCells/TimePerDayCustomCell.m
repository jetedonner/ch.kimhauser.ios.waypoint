//
//  QuickViewDescriptionCustomCell.m
//  OnlineTimeSheet
//
//  Created by dave on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
#import "QuickViewDescriptionCustomCell.h"

@implementation QuickViewDescriptionCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
*/
//
//  MandateCustomCell.m
//  EITOnlineTimeSheet
//
//  Created by dave on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimePerDayCustomCell.h"

@implementation TimePerDayCustomCell

@synthesize lblTime;
@synthesize lblText;
@synthesize cmdEdit;
@synthesize viewForBackground;
@synthesize nRowIdx;
@synthesize sDate;

- (void)setDelegate:(id)val{
    delegate = val;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (IBAction) loadTimeSheetView:(id)sender{
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test MSG" message:@"Do you really want to do this?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Yes", nil];
	[alert show];
	[alert release];*/
    //[timePerDayView reloadTimesheet:sDate];
    //[timePerDayView cancel:nil];
    if(delegate != nil){
        if ([delegate respondsToSelector:@selector(timePerDayCustomCellDelegateDoButton:)]) {
            [delegate timePerDayCustomCellDelegateDoButton:sDate];
        }
    }
}
@end
