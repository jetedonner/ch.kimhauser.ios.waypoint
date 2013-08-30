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

#import "DataConfigMoreCustomCell.h"

@implementation DataConfigMoreCustomCell

@synthesize lblTime;
@synthesize cmdEdit;
@synthesize imgView;
@synthesize viewForBackground;
//@synthesize configDataView;
@synthesize nID;

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
    /*if(editView != nil){
        [editView newConfigTextShow:nID];
    }else if (quickView != nil) {
        [quickView newConfigTextShow:nID];
    }else if (configDataView != nil) {
        [configDataView swipe:nID];
    }*/
    //[delegate re:]
    
    if(delegate != nil){
        if ([delegate respondsToSelector:@selector(dataConfigMoreCustomCellDelegateDoButton:)]) {
            [delegate dataConfigMoreCustomCellDelegateDoButton:nID];
        }
    }

}

- (void)setDelegate:(id)val{
    delegate = val;
}


@end
