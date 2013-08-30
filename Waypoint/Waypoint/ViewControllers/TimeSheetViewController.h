//
//  TimeSheetViewController.h
//  Waypoint
//
//  Created by Kim David Hauser on 02.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigMgr.h"
#import "SOAPRequester.h"
#import "XMLReader.h"
#import "LoginAnswere.h"
#import "QuickViewController.h"
#import "TimeSheetEntry.h"
#import "TimeSheetCustomCell.h"
#import "ConfigMainViewController.h"
#import "EditTimeSheetViewController.h"
#import "ReportMainViewController.h"

@interface TimeSheetViewController : UIViewController<XMLReaderDelegate, QuickViewControllerDelegate, UIGestureRecognizerDelegate, TimeSheetCustomCellDelegate,ConfigMainViewControllerDelegate,EditTimeSheetViewControllerDelegate>{
    ConfigMgr *cfgMgr;
    LoginAnswere *la;
    SOAPRequester *sr;
    SOAPRequester *srTimesheet;
    XMLReader *xmlReader;
    BOOL bErrorSessionId;
    BOOL bReloading;
    
    QuickViewController *quickView;
    ConfigMainViewController *configMainView;
    EditTimeSheetViewController *editTimeSheetView;
    ReportMainViewController *reportMainView;
    IBOutlet UITabBar *tabMain;
    IBOutlet UITabBarItem *tbiTimesheet;
    IBOutlet UITabBarItem *tbiQuickview;
    IBOutlet UITabBarItem *tbiReports;
    IBOutlet UITabBarItem *tbiConfig;
    
    int nUserID;
    
    IBOutlet UISwipeGestureRecognizer *swipRec;
    IBOutlet UISwipeGestureRecognizer *swipRec2;
    IBOutlet UIDatePicker * datePicker;
	IBOutlet UIView *pickerView;
	
	IBOutlet UIActivityIndicatorView *actMain;
	
    int nTimeDifference;
    NSTimeInterval *totalTime;
	NSTimeInterval *totalTimeLeft;
  	NSTimeInterval *totalTimeCenter;
	NSTimeInterval *totalTimeRight;
    NSDate *dSelectedDate;
    
	NSString *sUserID;
	NSString *sUsername;
	NSString *sQuickEntryStart;
    
	IBOutlet UILabel *lblLoginUser;
	IBOutlet UIButton *cmbLogout;
	IBOutlet UIButton *cmbSelectDate;
	IBOutlet UIButton *cmbLoad;
	IBOutlet UIButton *cmbNew;
	IBOutlet UITableView *tbvTimeSheet;
	IBOutlet UITableView *tbvTimeSheetLeft;
	IBOutlet UITableView *tbvTimeSheetRight;
    
    CGRect leftFrame;
    CGRect centerFrame;
    CGRect rightFrame;
    
	IBOutlet UILabel *lblDayTotal;
	IBOutlet UILabel *lblUser;	
	IBOutlet UILabel *lblDayTotalLeft;
	IBOutlet UILabel *lblUserLeft;	
    IBOutlet UILabel *lblDayTotalRight;
	IBOutlet UILabel *lblUserRight;	
    
	IBOutlet UIBarButtonItem *cmdBarLogout;
	IBOutlet UIBarButtonItem *cmdBarAddNew;
	IBOutlet UINavigationItem *niDate;
	
	IBOutlet UITabBar *tabBar;
	IBOutlet UITabBarItem *cmdSettings;
	IBOutlet UITabBarItem *cmdQuickEntry;
	IBOutlet UITabBarItem *cmdChart;
    
	NSArray *arrData;
	
	TimeSheetEntry *entry;
	NSMutableArray *arrTimeSheetEntries;
	NSMutableArray *arrTimeSheetEntries2;
    
    NSMutableArray *arrTSELeft;
    NSMutableArray *arrTSECenter;
    NSMutableArray *arrTSERight;
    
    NSString *sWorkDateLeft;
	NSString *sWorkDate;
    NSString *sWorkDateRight;
	NSString *sWorkDateGroup;
    
    NSString *sWorkDateToRequest;
    
    //EditTimeSheetViewController *editTimesheetView;
    //NSObject* startViewController;
}
@property (nonatomic, retain) ConfigMgr *cfgMgr;
@property (nonatomic, retain) LoginAnswere *la;

-(void)showSubView:(int)nSubView;

@end
