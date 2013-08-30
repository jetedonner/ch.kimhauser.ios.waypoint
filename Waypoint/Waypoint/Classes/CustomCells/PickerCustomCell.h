//
//  QuickViewDescriptionCustomCell.h
//  OnlineTimeSheet
//
//  Created by dave on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
#import <UIKit/UIKit.h>

@interface QuickViewDescriptionCustomCell : UITableViewCell

@end
*/
#import <UIKit/UIKit.h>

@protocol PickerCustomCellDelegate <NSObject>
- (void)pickerCustomCellDelegateDoButton:(int)nID;
@end

@interface PickerCustomCell : UITableViewCell {
	IBOutlet UILabel *lblTime;
	IBOutlet UIButton *cmdEdit;
	IBOutlet UIImageView *imgView;
    
	IBOutlet UIView *viewForBackground;
    int nID;
    id <NSObject, PickerCustomCellDelegate > delegate;
}

@property (nonatomic, retain) UILabel *lblTime;
@property (nonatomic, retain) UIButton *cmdEdit;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UIView *viewForBackground;

@property (nonatomic) int nID;
- (IBAction) doButton:(id)sender;
- (void)setDelegate:(id)val;

@end