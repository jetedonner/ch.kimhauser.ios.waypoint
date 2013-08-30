//
//  ReportTimePerDayViewController.h
//  Waypoint
//
//  Created by Kim David Hauser on 05.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigMgr.h"
#import "LoginAnswere.h"
#import "SOAPRequester.h"
#import "XMLReader.h"
#import "MinMaxDateEntry.h"
#import "TimePerDayCustomCell.h"

@protocol ReportTimePerDayViewControllerDelegate <NSObject>
- (void)closeReportTimePerDayView;
- (void)showTimeSheetForDay:(NSString*)sDate;
@end

@interface ReportTimePerDayViewController : UIViewController<XMLReaderDelegate, TimePerDayCustomCellDelegate>{
    
    BOOL bErrorSessionId;
    LoginAnswere *la;
    ConfigMgr *cfgMgr;
   	SOAPRequester *srTimePerDay;
    XMLReader *xmlReader;
	MinMaxDateEntry *entry;
    
	IBOutlet UITabBar *tabMain;
	IBOutlet UITabBarItem *tbiStartEndTime;
	IBOutlet UITabBarItem *tbiTimePerDay;
    

    IBOutlet UIActivityIndicatorView *actMain;
    
	IBOutlet UITableView *tbvTimePerDay;
    
    IBOutlet UITabBar *tabBar;
	IBOutlet UITabBarItem *cmdStartEndTime;
	IBOutlet UITabBarItem *cmdTimePerDay;
    
   	NSDate *dSelectedMonth;
   	IBOutlet UIButton *cmdSelectMonth;
    
    NSMutableArray *arrMinMax;

    
    NSMutableArray *arrWeeks;
    NSMutableArray *arrWeekTotals;
   	IBOutlet UIBarButtonItem *cmdCancel;
  	NSObject *chartView;
   	IBOutlet UIView *pickerView;
	IBOutlet UIPickerView * monthYearPicker;
    
    int nHourMonthTot;        
    int nMinMonthTot;
    
    IBOutlet UILabel *lblMonthTotal;
    IBOutlet UILabel *lblMonthTitle; 
    id <NSObject, ReportTimePerDayViewControllerDelegate > delegate;
}
@property (nonatomic, retain) ConfigMgr *cfgMgr;
@property (nonatomic, retain) LoginAnswere *la;
@property (nonatomic, retain) NSDate *dSelectedMonth;
@property (nonatomic, retain) NSMutableArray *arrMinMax;
- (void)setDelegate:(id)val;
- (void) reloadViewElements;
@end
