//
//  MandateCustomCell.m
//  EITOnlineTimeSheet
//
//  Created by dave on 5/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerCustomCell.h"

@implementation PickerCustomCell

@synthesize lblTime;
@synthesize cmdEdit;
@synthesize imgView;
@synthesize viewForBackground;
//@synthesize quickView;
//@synthesize editView;
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

- (IBAction) doButton:(id)sender{
    /*if(editView != nil){
        [editView newConfigTextShow:nID];
    }else if (quickView != nil) {
        */
    //[quickView newConfigTextShow:nID];
    //}
    [delegate pickerCustomCellDelegateDoButton:nID];
}
- (void)setDelegate:(id)val{
    delegate = val;
}
    
@end
