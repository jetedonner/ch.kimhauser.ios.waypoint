//
//  ViewController.h
//  Waypoint
//
//  Created by Kim David Hauser on 02.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigMgr.h"
#import "SOAPRequester.h"
#import "LoginAnswere.h"
#import "XMLReader.h"
#import "ClientEntry.h"
#import "ProjectEntry.h"
#import "WorkcodeEntry.h"
#import "ConfigMainViewController.h"
#import "WaypointInfo.h"

@interface ViewController : UIViewController<XMLReaderDelegate, ConfigMainViewControllerDelegate>{
    ConfigMgr *cfgMgr;
    LoginAnswere *la;
    
    SOAPRequester *sr;
    SOAPRequester *srConfig;
    SOAPRequester *srConfigWorkcodes;
    SOAPRequester *srConfigClients;
    SOAPRequester *srConfigWaypoints;
    
    XMLReader *xmlReader;
    XMLReader *xmlReaderConfig;
    XMLReader *xmlReaderWP;    
    ClientEntry *clientEntry;
    ProjectEntry *projectEntry;
    WorkcodeEntry *workcodeEntry;
    WaypointInfo *waypointInfo;
    
    BOOL bErrorSessionID;
    BOOL bAutoLogin;
    ConfigMainViewController *configMainView;
    
    int nViewIdx;
    IBOutlet UIView *viewTextNew;
	IBOutlet UITextField *txtNewConfigText;
    IBOutlet UIBarButtonItem *bbiTitleConfig;  
    
    IBOutlet UITableView *tbvLogin;
    
    IBOutlet UIActivityIndicatorView *actMain;
    IBOutlet UITabBar *tabMain;
    IBOutlet UITabBarItem *tbiLogin;
    IBOutlet UITabBarItem *tbiMembership;
    IBOutlet UITabBarItem *tbiConfig;
    UITabBarItem *tbiLast;
    IBOutlet UIBarButtonItem *bbiLogin;
}

@end
