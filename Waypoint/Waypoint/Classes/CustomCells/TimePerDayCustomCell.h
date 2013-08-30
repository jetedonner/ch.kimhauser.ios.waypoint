//
//  QuickViewDescriptionCustomCell.h
//  OnlineTimeSheet
//
//  Created by dave on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol TimePerDayCustomCellDelegate <NSObject>
- (void)timePerDayCustomCellDelegateDoButton:(NSString*)sDate;
@end

@interface TimePerDayCustomCell : UITableViewCell {
	IBOutlet UILabel *lblTime;
	IBOutlet UILabel *lblText;
	IBOutlet UIButton *cmdEdit;
    
	IBOutlet UIView *viewForBackground;
    NSString *sDate;
    
	int nRowIdx;
    id <NSObject, TimePerDayCustomCellDelegate > delegate;
}
@property (nonatomic, retain) UILabel *lblTime;
@property (nonatomic, retain) UILabel *lblText;
@property (nonatomic, retain) UIButton *cmdEdit;
@property (nonatomic, retain) UIView *viewForBackground;
@property (nonatomic, retain) NSString *sDate;
@property (nonatomic) int nRowIdx;

- (IBAction) loadTimeSheetView:(id)sender;
- (void)setDelegate:(id)val;
@end