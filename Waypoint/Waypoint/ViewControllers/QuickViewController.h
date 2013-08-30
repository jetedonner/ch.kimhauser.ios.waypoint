//
//  QuickViewController.h
//  Waypoint
//
//  Created by Kim David Hauser on 03.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigMgr.h"
#import "QuickEntry.h"
#import "ClientEntry.h"
#import "ProjectEntry.h"
#import "WorkcodeEntry.h"
#import "HPGrowingTextView.h"
#import "LoginAnswere.h"
#import "SOAPRequester.h"
#import <MapKit/MapKit.h>
#import "HPGrowingTextView.h"
#import "ConfigMainViewController.h"
#import "PickerCustomCell.h"
#import "WaypointInfo.h"
#import "XMLReader.h"

@protocol QuickViewControllerDelegate <NSObject>
- (void)loadSubView:(int)nSubView;
- (void)closeQuickView:(int)nSubView;
@end

@interface QuickViewController : UIViewController<HPGrowingTextViewDelegate, CLLocationManagerDelegate, ConfigMainViewControllerDelegate, PickerCustomCellDelegate,XMLReaderDelegate>{
    BOOL bErrorSessionId;
    BOOL bEndWaypoint;
    BOOL bInvalideTime;
    ConfigMgr *cfgMgr;
    LoginAnswere *la;

    SOAPRequester *sr;
    SOAPRequester *srWaypoint;
    SOAPRequester *srConfigText;
    
    XMLReader *xmlReader;

    NSDate *dSelectedDate;
    
    CLLocationManager *lm;
    CLGeocoder *geocoder;
    //MKReverseGeocoder *geocoder;

    WaypointInfo *wpiStart;
    WaypointInfo *wpiEnd; 
    ClientEntry *clientEntry;
    ConfigMainViewController *configMainView;
    IBOutlet UIView *viewTextNew;
	IBOutlet UITextField *txtNewConfigText;
    bool bNewText;
    int nConfigID;
    
    UIView *dimBackgroundView;
    UIView *containerView;
    HPGrowingTextView *textView;
    
    IBOutlet UITabBar *tabMain;
    IBOutlet UITabBarItem *tbiTimesheet;
    IBOutlet UITabBarItem *tbiQuickview;
    IBOutlet UITabBarItem *tbiReports;
    IBOutlet UITabBarItem *tbiConfig;
    
    IBOutlet UIButton *cmdQuick;
    IBOutlet UIButton *cmdPause;
	IBOutlet UILabel *lblLocation;
	IBOutlet UILabel *lblLocation2;
    IBOutlet UITableView *tbvQuick;
    
    IBOutlet NSTimer *timer;
    IBOutlet NSDate *startTime;
    IBOutlet NSDate *endTime;
    IBOutlet NSDate *startPause;
    
    NSMutableDictionary *dictPause;
    NSMutableArray *arrQE;
    
    int nPickerMode;
    BOOL bProject;
    IBOutlet UIBarButtonItem *bbiTitle;
    IBOutlet UIBarButtonItem *bbiTitleConfig;    
    IBOutlet UIBarButtonItem *bbiTitleTime;   
    IBOutlet UIBarButtonItem *cmdCancel;
    IBOutlet UIView *pickerProjectView;
	IBOutlet UIView *pickerWorkcodeView;
    
    IBOutlet UIPickerView * projectPicker;
    NSString *sDate;
    NSString *sClient;
    NSString *sProject;
    NSString *sWorkcode;
    NSString *sDescription;
	//IBOutlet UIPickerView * workcodePicker;
    
    IBOutlet UIView *pickerTimeView;
    IBOutlet UIDatePicker * timePicker;
    int nTimeMode;
    
    double dLat;
    double dLng;
    double dAcc;
    NSString *sLoc;
    BOOL bMon;
    
    NSObject *objRoot;
    id <NSObject, QuickViewControllerDelegate > delegate;
}
@property (nonatomic, retain) ConfigMgr *cfgMgr;
@property (nonatomic, retain) LoginAnswere *la;

@property (nonatomic, retain) NSObject *objRoot;
@property (nonatomic, retain) NSString *sDate;
@property (nonatomic, retain) NSDate *dSelectedDate;
- (void)setDelegate:(id)val;

@end
