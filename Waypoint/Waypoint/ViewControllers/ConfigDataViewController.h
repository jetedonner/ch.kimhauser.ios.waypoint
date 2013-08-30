//
//  ConfigDataViewController.h
//  Waypoint
//
//  Created by Kim David Hauser on 02.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigMgr.h"
#import "LoginAnswere.h"
#import "DataConfigMoreCustomCell.h"
#import "SOAPRequester.h"
#import "XMLReader.h"
#import "ClientEntry.h"

@interface ConfigDataViewController : UIViewController<DataConfigMoreCustomCellDelegate, XMLReaderDelegate>{
    BOOL bErrorSessionId;
    ConfigMgr *cfgMgr;
    LoginAnswere *la;
    
    SOAPRequester *srConfigText;
    SOAPRequester *srDeleteConfigText; 
    XMLReader *xmlReader;
    XMLReader *xmlReaderDelete;
    NSIndexPath *idxDelete;
    ClientEntry *clientEntry;
    
    IBOutlet UIActivityIndicatorView *actMain;
    
    UIView *dimBackgroundView;
    int nViewIdx;
    IBOutlet UIView *viewTextNew;
	IBOutlet UITextField *txtNewConfigText;
    IBOutlet UIBarButtonItem *bbiTitleConfig; 
    
    IBOutlet UITabBar *tabMain;
    IBOutlet UITabBarItem *tbiConfigMain;
    IBOutlet UITabBarItem *tbiConfigData;
    
    IBOutlet UITableView *tbvDataConfig;
    IBOutlet UITableView *tbvDataConfig2;
    IBOutlet UITableView *tbvDataConfig3;
    
    IBOutlet UINavigationBar *nvbMain;
    IBOutlet UINavigationItem *nviMain;
    IBOutlet UIBarButtonItem *bbi1;
    IBOutlet UIBarButtonItem *bbi2;
    IBOutlet UIBarButtonItem *bbiCancel;
    IBOutlet UIBarButtonItem *bbiCancel2;    
    
    CGRect centerFrame;
    CGRect rightFrame;
    int nTbvMode;
    
    NSObject *objMainView;
}
@property (nonatomic, retain) NSObject *objMainView;
@property (nonatomic, retain) LoginAnswere *la;
@property (nonatomic, retain) ConfigMgr *cfgMgr;

- (IBAction)swipeBack;
@end
