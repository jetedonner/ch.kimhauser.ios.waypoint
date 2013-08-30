//
//  EditTimeSheetViewController.h
//  Waypoint
//
//  Created by Kim David Hauser on 05.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigMgr.h"
#import "LoginAnswere.h"
#import "TimeSheetEntry.h"
#import "HPGrowingTextView.h"
#import "SOAPRequester.h"
#import "XMLReader.h"
#import "ClientEntry.h"
#import "ProjectEntry.h"
#import "WorkcodeEntry.h"
#import "PickerCustomCell.h"

@protocol EditTimeSheetViewControllerDelegate <NSObject>
- (void)closeEditTimeSheetView:(BOOL)bReload;
@end

@interface EditTimeSheetViewController : UIViewController<HPGrowingTextViewDelegate, PickerCustomCellDelegate,XMLReaderDelegate>{
    BOOL bErrorSessionId;
    BOOL bInvalideTime;
    ConfigMgr *cfgMgr;
    LoginAnswere *la;
    TimeSheetEntry *tse;
    ClientEntry *clientEntry;
    
    NSString *sClient;    
    NSString *sProject;
    NSString *sWorkcode;
    NSString *sDescription;
    
    UIView *dimBackgroundView;
    
    IBOutlet UIView *viewTextNew;
	IBOutlet UITextField *txtNewConfigText;
    bool bNewText;
    int nConfigID;
    
    UIView *containerView;
    HPGrowingTextView *textView;
    
    IBOutlet UITableView *tbvEdit;
    IBOutlet UIBarButtonItem *cmdCancel;
    //TimeSheetEntry *editTimesheetEntry;
    
    SOAPRequester *sr;
    SOAPRequester *srDelete;
    SOAPRequester *srConfigText;
    
    XMLReader *xmlReader;
    XMLReader *xmlReaderConfig;
    
    NSObject *tsView;
    
    IBOutlet UIView *moreView;
    IBOutlet UIView *pickerTimeView;
    IBOutlet UIDatePicker * timePicker;
    
    IBOutlet UIView *pickerProjectView;
    IBOutlet UIPickerView * projectPicker;
    
    IBOutlet UINavigationItem *niTitle;
    
    BOOL bProject;
    int nPickerMode;
    IBOutlet UIBarButtonItem *bbiTitle;
    IBOutlet UIBarButtonItem *bbiTitleConfig;
    IBOutlet UIBarButtonItem *bbiTitleTime;    
    NSDate *startFrom;
    NSDate *endAt;
    NSDate *dSelectedDate;
    int nTimeMode;
    
    IBOutlet UITabBar *tabBar;
	IBOutlet UITabBarItem *cmdMore;
    BOOL bShowMore;
    id <NSObject, EditTimeSheetViewControllerDelegate > delegate;
}
@property (nonatomic, retain) ConfigMgr *cfgMgr;
@property (nonatomic, retain) LoginAnswere *la;
@property (nonatomic, retain) TimeSheetEntry *tse;
@property (nonatomic, retain) NSDate *dSelectedDate;

- (void)setDelegate:(id)val;

@end