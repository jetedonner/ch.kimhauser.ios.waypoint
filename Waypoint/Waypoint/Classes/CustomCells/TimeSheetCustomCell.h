//
//  TimeSheetCustomCell.h
//  EITOnlineTimeSheet
//
//  Created by dave on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeSheetEntry.h"

@protocol TimeSheetCustomCellDelegate <NSObject>
- (void)timeSheetCustomCellDelegateDoButton:(TimeSheetEntry*)tse;
@end

@interface TimeSheetCustomCell : UITableViewCell {
	IBOutlet UILabel *lblTime;
	IBOutlet UILabel *lblTime2;
	IBOutlet UILabel *lblProjectWorkcode;
	IBOutlet UILabel *lblText;
	IBOutlet UIButton *cmdEdit;
	
	IBOutlet UIView *viewForBackground;
	int nRowIdx;
    TimeSheetEntry *tse;
    id <NSObject, TimeSheetCustomCellDelegate > delegate;
}

@property (nonatomic, retain) UILabel *lblTime;
@property (nonatomic, retain) UILabel *lblTime2;
@property (nonatomic, retain) UILabel *lblText;
@property (nonatomic, retain) UILabel *lblProjectWorkcode;
@property (nonatomic, retain) UIButton *cmdEdit;
@property (nonatomic, retain) UIView *viewForBackground;
//@property (nonatomic, retain) EditTimeSheetViewController *editTimesheetView;
@property (nonatomic) int nRowIdx;
@property (nonatomic, retain) TimeSheetEntry *tse;

- (IBAction) editTimesheetEntry:(id)sender;
- (void)setDelegate:(id)val;
@end
