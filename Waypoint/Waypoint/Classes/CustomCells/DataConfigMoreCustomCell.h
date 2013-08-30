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
//#import "QuickViewController.h"
//#import "EditTimeSheetViewController.h"
//#import "ConfigDataViewController.h"

@protocol DataConfigMoreCustomCellDelegate <NSObject>
- (void)dataConfigMoreCustomCellDelegateDoButton:(int)nID;
@end

@interface DataConfigMoreCustomCell : UITableViewCell {
	IBOutlet UILabel *lblTime;
	IBOutlet UIButton *cmdEdit;
	IBOutlet UIImageView *imgView;
    
	IBOutlet UIView *viewForBackground;
    //ConfigDataViewController *configDataView;
    int nID;
    id <NSObject, DataConfigMoreCustomCellDelegate > delegate;
}

@property (nonatomic, retain) UILabel *lblTime;
@property (nonatomic, retain) UIButton *cmdEdit;
@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UIView *viewForBackground;
//@property (nonatomic, retain) ConfigDataViewController *configDataView;
@property (nonatomic) int nID;

- (IBAction) editTimesheetEntry:(id)sender;
- (void)setDelegate:(id)val;

@end