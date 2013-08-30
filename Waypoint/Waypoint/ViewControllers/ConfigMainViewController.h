//
//  ConfigMainViewController.h
//  Waypoint
//
//  Created by Kim David Hauser on 02.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigMgr.h"
#import "LoginAnswere.h"
#import "SOAPRequester.h"
#import "XMLReader.h"
#import "ConfigDataViewController.h"


@protocol ConfigMainViewControllerDelegate <NSObject>
- (void)closeConfigMainView;
@end

@interface ConfigMainViewController : UIViewController<XMLReaderDelegate>{
    BOOL bOpenDataConfig;
    BOOL bFirstTime;
    ConfigDataViewController *dataView;
    
    ConfigMgr *cfgMgr;
    LoginAnswere *la;    
    SOAPRequester *sr;
    
    IBOutlet UIScrollView *scroller;
    IBOutlet UITabBar *tabMain;
    IBOutlet UITabBarItem *tbiConfigMain;
    IBOutlet UITabBarItem *tbiConfigData;
    
    // Controls
    IBOutlet UITextField *txtTimeSheetServer;
	IBOutlet UITextField *txtTimeSheetService;
    IBOutlet UISwitch *swtStayLoggedIn;
    IBOutlet UISwitch *swtShowDebugInfo;
    IBOutlet UISwitch *swtShowMoreInfo;
    IBOutlet UISwitch *swtShowQuickView;
    IBOutlet UISwitch *swtUseGeoFencing;    
    IBOutlet UISwitch *swtShowSeconds;
    IBOutlet UISwitch *swtShowDescriptions;
    IBOutlet UIButton *cmdTestConnection;
    
    IBOutlet UIActivityIndicatorView *actMain;
    
    id <NSObject, ConfigMainViewControllerDelegate > delegate;
}
@property (nonatomic) BOOL bOpenDataConfig;
@property (nonatomic, retain) ConfigMgr *cfgMgr;
@property (nonatomic, retain) LoginAnswere *la;
@property (nonatomic, retain) UITextField *txtTimeSheetServer;
@property (nonatomic, retain) UITextField *txtTimeSheetService;
@property (nonatomic, retain) UISwitch *swtStayLoggedIn;
@property (nonatomic, retain) UISwitch *swtShowMoreInfo;
@property (nonatomic, retain) UISwitch *swtShowDebugInfo;
@property (nonatomic, retain) UISwitch *swtShowQuickView;
@property (nonatomic, retain) UISwitch *swtShowSeconds;
@property (nonatomic, retain) UISwitch *swtUseGeoFencing;    
@property (nonatomic, retain) UISwitch *swtShowDescriptions;
@property (nonatomic, retain) UIButton *cmdTestConnection;

-(IBAction)cancel:(id)sender;
-(void)setDelegate:(id)val;
-(void)openDataConfig;
@end
