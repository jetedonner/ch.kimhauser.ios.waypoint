//
//  TimeSheetCustomCell.m
//  EITOnlineTimeSheet
//
//  Created by dave on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TimeSheetCustomCell.h"
#import "TimeSheetViewController.h"

@implementation TimeSheetCustomCell

@synthesize lblTime;
@synthesize lblTime2;
@synthesize lblText;
@synthesize lblProjectWorkcode;
@synthesize cmdEdit;
@synthesize viewForBackground;
@synthesize nRowIdx;
@synthesize tse;

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

- (IBAction) editTimesheetEntry:(id)sender{
    [delegate timeSheetCustomCellDelegateDoButton:tse];
}

@end
