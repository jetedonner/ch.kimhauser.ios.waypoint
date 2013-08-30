//
//  ConfigMainViewController.m
//  Waypoint
//
//  Created by Kim David Hauser on 02.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import "ConfigMainViewController.h"
#import "XMLReader.h"
#import "CommonFunctions.h"

@interface ConfigMainViewController ()

@end

@implementation ConfigMainViewController

@synthesize la;
@synthesize bOpenDataConfig;
@synthesize cfgMgr;
@synthesize txtTimeSheetServer;
@synthesize txtTimeSheetService;
@synthesize swtStayLoggedIn;
@synthesize swtShowMoreInfo;
@synthesize swtShowDebugInfo;
@synthesize swtShowQuickView;
@synthesize swtShowSeconds;
@synthesize swtUseGeoFencing;    
@synthesize swtShowDescriptions;
@synthesize cmdTestConnection;

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item == tbiConfigData){
        [self openDataConfig];
    }
}

-(void)openDataConfig{
    tabMain.selectedItem = tbiConfigMain;
    
    if (dataView == nil){
        dataView = [[ConfigDataViewController alloc] init];
        dataView.cfgMgr = cfgMgr;
        dataView.la = la;
    }
    dataView.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    dataView.objMainView = self;
    [self presentModalViewController:dataView animated:YES];  
}

-(IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction) save:(id)sender{
    
    [actMain startAnimating];
    cfgMgr.sServerName = txtTimeSheetServer.text;
    cfgMgr.sServiceName = txtTimeSheetService.text;
    cfgMgr.bStayLoggedIn = swtStayLoggedIn.on;
    cfgMgr.bShowDebugInfo = swtShowDebugInfo.on;
    cfgMgr.bShowMoreInfo = swtShowMoreInfo.on;
    cfgMgr.bShowQuickView = swtShowQuickView.on;
    cfgMgr.bUseGeoFencing = swtUseGeoFencing.on;
    cfgMgr.bShowSeconds = swtShowSeconds.on;
    cfgMgr.bShowDescriptions = swtShowDescriptions.on;
    
    if(cfgMgr.saveData){
        [delegate closeConfigMainView];
    }
    
}

-(IBAction)loadDefaultConfig:(id)sender{
    [actMain startAnimating];
    if(cfgMgr == nil)
        cfgMgr = [[ConfigMgr alloc] initWithName: @""];
    [cfgMgr loadDefault];
    [self loadConfig:nil];
    [actMain stopAnimating];
}

-(IBAction)loadConfig:(id)sender{
    if(cfgMgr == nil)
        cfgMgr = [[ConfigMgr alloc] initWithName: @""];
    
    txtTimeSheetServer.text  = cfgMgr.sServerName;
    txtTimeSheetService.text = cfgMgr.sServiceName;
    swtStayLoggedIn.on = cfgMgr.bStayLoggedIn;
    swtShowDebugInfo.on = cfgMgr.bShowDebugInfo;
    swtShowMoreInfo.on = cfgMgr.bShowMoreInfo;
    swtShowQuickView.on = cfgMgr.bShowQuickView;  
    swtUseGeoFencing.on = cfgMgr.bUseGeoFencing;
    swtShowSeconds.on = cfgMgr.bShowSeconds;
    swtShowDescriptions.on = cfgMgr.bShowDescriptions;
    tabMain.selectedItem = tbiConfigMain;
}

- (IBAction) testConnection:(id)sender{
    
    [actMain startAnimating];
    [txtTimeSheetServer resignFirstResponder];
    [txtTimeSheetService resignFirstResponder];
    
    OrderedDictionary *od = nil;
    if(la != nil){
        od = [[OrderedDictionary alloc] init];
        [od setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ];
    }
    ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
    
    cfgTmp.sServerName = txtTimeSheetServer.text;
    cfgTmp.sServiceName = txtTimeSheetService.text;
    
    sr = [[SOAPRequester alloc] init];
    sr.delegate = self;
    [sr sendSOAPRequest:cfgTmp:@"HelloWorld":od];
}

- (void)setDelegate:(id)val{
	delegate = val;
}

- (void) foundXMLElement: (NSObject*)sourceXmlReader:(NSString*)sElementName:(NSMutableString*)sValue{
    [CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionOk", @""):[NSString stringWithFormat:NSLocalizedString(@"msgConnectionTest", @""), sValue]];
}

- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error{
    [actMain stopAnimating];
    [CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @""): [error description]];
}

- (void) gotSOAPAnswere:(NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data{   
    
    //[actMain stopAnimating];
    
    NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
    [aElementsToFind addObject:@"ns1:HelloWorldResponse"];
    
    XMLReader *xmlReader = [[XMLReader alloc] init];
    xmlReader.delegate = self;
    //sr.delegate = self;
    [xmlReader parseForElements:aElementsToFind:sr.webData];
    
    //[aElementsToFind release];
    [actMain stopAnimating];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    bFirstTime = FALSE;
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 800)];
    
    [self loadConfig:nil];
    if (cfgMgr.aClients.count <= 0 & cfgMgr.aWorkcodes <= 0) {
        tbiConfigData.enabled = NO;
    }

}

-(void)viewDidAppear:(BOOL)animated {
    if (bOpenDataConfig & !bFirstTime) {
        bFirstTime = TRUE;
        [self openDataConfig];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
