//
//  ReportMainViewController.h
//  Waypoint
//
//  Created by Kim David Hauser on 03.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginAnswere.h"
#import "SOAPRequester.h"
#import "ConfigMgr.h"
#import "XMLReader.h"
#import "TimeSheetEntry.h"
#import "S7GraphView.h"
#import "MinMaxDateEntry.h"
#import "ReportTimePerDayViewController.h"

@protocol ReportMainViewControllerDelegate <NSObject>
- (void)showTimeSheetForDay:(NSString*)sDate;
@end

@interface ReportMainViewController : UIViewController<S7GraphViewDataSource,XMLReaderDelegate,ReportTimePerDayViewControllerDelegate>{
	int nViewIdx;
    BOOL bErrorSessionId;
    
    ConfigMgr *cfgMgr;
    LoginAnswere *la;
	S7GraphView *graphView;
	SOAPRequester *srMinMax;
	SOAPRequester *srTimePerDay;
    XMLReader *xmlReader;
	MinMaxDateEntry *entry;
    TimeSheetEntry *tpdEntry;
    ReportTimePerDayViewController *reportTimePerDay;

    
    IBOutlet UIActivityIndicatorView *actMain;
    
	IBOutlet UILabel *lblTimePerDayTitle;
	NSDate *dSelectedMonth;
	IBOutlet UIButton *cmdSelectMonth;
	IBOutlet UIPickerView * monthYearPicker;
	IBOutlet UIView *pickerView;
	IBOutlet UIBarButtonItem *cmdCancel;	
	IBOutlet UIView *chartView;
	IBOutlet UIView *timePerDayView;
	IBOutlet UITableView *tbvTimePerDay;
    
	NSMutableArray *arrMinMax;
    
	NSString *sUserID;
	NSString *sUserName;
	
	IBOutlet UITabBar *tabMain;
	IBOutlet UITabBarItem *tbiStartEndTime;
	IBOutlet UITabBarItem *tbiTimePerDay;
    id <NSObject, ReportMainViewControllerDelegate > delegate;
}
@property (nonatomic, retain) ConfigMgr *cfgMgr;
@property (nonatomic, retain) LoginAnswere *la;
@property (nonatomic, retain) NSDate *dSelectedMonth;

- (void)setDelegate:(id)val;
@end
