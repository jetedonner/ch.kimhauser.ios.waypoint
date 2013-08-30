//
//  QuickViewController.m
//  Waypoint
//
//  Created by Kim David Hauser on 03.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import "QuickViewController.h"
#import "TimeSheetViewController.h"
#import "ReportMainViewController.h"
#import "ConfigMainViewController.h"
#import "PickerCustomCell.h"
#import "CommonFunctions.h"
#import "DateHelper.h"

@interface QuickViewController ()
    //- (void)event:(int)nSubView;
@end

@implementation QuickViewController

@synthesize objRoot;
@synthesize cfgMgr;
@synthesize la;
@synthesize sDate;
@synthesize dSelectedDate;

-(IBAction)resetQuickView:(id)sender{
    [delegate closeQuickView:1];
}

- (void)closeConfigMainView{
    [configMainView dismissModalViewControllerAnimated:NO];
    configMainView = nil;
    [tbvQuick reloadData];
}

- (void)showDisabledBackground:(UIView*)superView{
    dimBackgroundView = [[UIView alloc] initWithFrame:superView.bounds];
    dimBackgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.5f];
    
    [superView addSubview:dimBackgroundView];
}

#pragma mark - HPGrowingTextView functions

-(void)resignTextView
{
    [dimBackgroundView removeFromSuperview];
	[textView resignFirstResponder];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    if(!bNewText){
        // get keyboard size and loctaion
        CGRect keyboardBounds;
        [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
        NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // Need to translate the bounds to account for rotation.
        keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
        
        // get a rect for the textView frame
        CGRect containerFrame = containerView.frame;
        containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        // set views with new info
        containerView.frame = containerFrame;
        
        // commit animations
        [UIView commitAnimations];
        //CGRect frame = textView.internalTextView.frame;
        //[textView resizeTextView:frame.size.height];
        [textView setText:sDescription];
    }
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height; // - containerFrame.size.height + 40
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	
    sDescription = [textView.text copy];
    [tbvQuick reloadData];
    
	// commit animations
	[UIView commitAnimations];
    
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    //r.size.height = height;
    r.origin.y += diff;
	containerView.frame = r;
}

- (IBAction)doneProject{
    if(nPickerMode == 0){
        if (![sClient isEqualToString:((ClientEntry*)[cfgMgr.aClients objectAtIndex:[projectPicker selectedRowInComponent:0]]).sClient]) {
            clientEntry = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:[projectPicker selectedRowInComponent:0]]);
            sClient = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:[projectPicker selectedRowInComponent:0]]).sClient;
            sProject = nil;
        }
    }else if(nPickerMode == 1){
        if (clientEntry != nil) {
            if ([projectPicker selectedRowInComponent:0] <= clientEntry.aProjects.count) {
                sProject = ((ProjectEntry*)[clientEntry.aProjects objectAtIndex:[projectPicker selectedRowInComponent:0]]).sProjectName;
            }else {
                sProject = nil;
            }
        }else {
            sProject = nil;
        }
    }else{
        sWorkcode = ((WorkcodeEntry*)[cfgMgr.aWorkcodes objectAtIndex:[projectPicker selectedRowInComponent:0]]).sWorkcode; 
    }    
    [self hideProjectPicker];
    
    [tbvQuick reloadData];
}

- (IBAction)hideProjectPicker{
    [dimBackgroundView removeFromSuperview];
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerProjectView.transform = transform;
	[UIView commitAnimations];	
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { 
	return 1; 
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { 
    if(nPickerMode == 0)
        return [cfgMgr.aClients count];
    else if(nPickerMode == 1)
        if (clientEntry != nil) {
            return [clientEntry.aProjects count];
        }else {
            return 0;
        }
    else if (nPickerMode == 2) 
        return [cfgMgr.aWorkcodes count];   
    else return 0;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 
    // This method asks for what     
    if (nPickerMode == 0) {
        ClientEntry *daEntry = [cfgMgr.aClients objectAtIndex:row];
        return daEntry.sClient;	
    }else if (nPickerMode == 1) {
        if (clientEntry != nil) {
            ProjectEntry *daEntry = [clientEntry.aProjects objectAtIndex:row];
            return daEntry.sProjectName;	
        }else {
            return nil;	
        }
    }else if(nPickerMode == 2) {
        WorkcodeEntry *daEntry = [cfgMgr.aWorkcodes objectAtIndex:row];
        return daEntry.sWorkcode;
    }else return 0;
}

-(IBAction) cancelNewConfigText{
    txtNewConfigText.text = @"";
    [self doneNewConfigText];
}

-(void)doneNewConfigText{
    bNewText = FALSE;
    [dimBackgroundView removeFromSuperview];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	viewTextNew.transform = transform;
	[UIView commitAnimations];	
	[txtNewConfigText resignFirstResponder];
    [self hideNewConfigText];
}

-(void)hideNewConfigText{
    [dimBackgroundView removeFromSuperview];
    [textView resignFirstResponder];
}

- (void)pickerCustomCellDelegateDoButton:(int)nID{
    [self newConfigTextShow:nID];
}

- (IBAction)newConfigTextShow:(int)sender{
    bNewText = YES;
    nConfigID = sender;
    if(sender == 0){
        bbiTitleConfig.title = NSLocalizedString(@"lblNewClient", @""); 
        txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterNewClient", @""); 
    }else if(sender == 1){
        bbiTitleConfig.title = NSLocalizedString(@"lblNewProject", @""); 
        txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterNewProject", @"");
    }else if(sender == 2){
        bbiTitleConfig.title = NSLocalizedString(@"lblNewWorkcode", @"");
        txtNewConfigText.placeholder =  NSLocalizedString(@"lblEnterNewWorkcode", @"");
    }
    //[viewTextNew setFrame:CGRectMake(0, 120, viewTextNew.frame.size.width, viewTextNew.frame.size.height)];
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 360);
	viewTextNew.transform = transform;
    [self showDisabledBackground:self.view];
	[self.view addSubview:viewTextNew];
	[UIView commitAnimations];	
	//[txtNewConfigText becomeFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	transform = CGAffineTransformMakeTranslation(0, 155);
	viewTextNew.transform = transform;
	[self.view addSubview:viewTextNew];
	[UIView commitAnimations];	
	[txtNewConfigText becomeFirstResponder];
}

- (IBAction) saveNewConfigText:(id)sender{
	if([txtNewConfigText.text isEqualToString:@""]){
        NSString *sConfigType;
        if(nConfigID == 0)
            sConfigType = NSLocalizedString(@"lblClient", @""); 
        else if(nConfigID == 1)
            sConfigType = NSLocalizedString(@"lblProject", @"");
        else //if(nID == 2)
            sConfigType = NSLocalizedString(@"lblWorkcode", @"");
        [CommonFunctions showMessageBox:NSLocalizedString(@"titMissingInput", @"") message:[NSString stringWithFormat: NSLocalizedString(@"msgPleaseEnterA", @""), sConfigType]];
	}else {
        int nParentID = -1;
        if (nConfigID == 0 | nConfigID == 2)
            nParentID = la.nUserID;
        else
            if(clientEntry != nil)
                nParentID = clientEntry.nClientID;
        
        OrderedDictionary *od = [[OrderedDictionary alloc] init];
        [od setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ]; 
        //[od setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];
        [od setObject: [NSString stringWithFormat:@"%d", nParentID] forKey: @"idparent" ];  
        [od setObject: [NSString stringWithFormat:@"%d", nConfigID] forKey: @"idconfig" ];
        [od setObject: [NSString stringWithFormat:@"%d", -1] forKey: @"idtext" ];
        [od setObject: txtNewConfigText.text forKey: @"text" ];
        ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
        
        srConfigText = [[SOAPRequester alloc] init];
        srConfigText.delegate = self; 
        [srConfigText sendSOAPRequest:cfgTmp message:@"UpdateConfigText" od:od];
	}
}

- (IBAction)doneTime{
    [dimBackgroundView removeFromSuperview];
    [self hideTimePicker];
}

- (IBAction)hideTimePicker{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerTimeView.transform = transform;
	[UIView commitAnimations];	
}
-(IBAction)dateChanged{
    if(nTimeMode == 0){
        int nTest = [self getPlace:0:0];    
        if(arrQE != nil & arrQE.count > 0 & arrQE.count > nTest){
            QuickEntry *qe = [arrQE objectAtIndex:nTest];
            if (qe.qeType == QE_WORKTIME) {
                QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:0:0]];
                qe2.startTime = timePicker.date;
            }
        }
    }else{
        int nTest = [self getPlace:2:0];    
        if(arrQE != nil & arrQE.count > 0 & arrQE.count > nTest){
            QuickEntry *qe = [arrQE objectAtIndex:nTest];
            if (qe.qeType == QE_WORKTIME) {
                QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:2:0]];
                qe2.endTime = timePicker.date;
            }
        }
    }
    [tbvQuick reloadData];
}
#pragma mark -
#pragma mark Geolocation Methoden: wo bin ich?

- (void) locationManager: (CLLocationManager *) manager
     didUpdateToLocation: (CLLocation *) newLocation
            fromLocation: (CLLocation *) oldLocation
{
    int nAcc = newLocation.horizontalAccuracy;
    if ( nAcc < 85.0) {

        NSString *lat = [[NSString alloc] initWithFormat:@"%g",newLocation.coordinate.latitude];
        NSString *lng = [[NSString alloc] initWithFormat:@"%g",newLocation.coordinate.longitude];
        //NSString *acc = [[NSString alloc] initWithFormat:@"%g",newLocation.horizontalAccuracy];
        NSString *sLocation = [[NSString alloc] initWithFormat:@"lat: %@ lng:%@ (%d)",lat, lng, bMon];
        dLat =  [lat doubleValue];
        dLng = [lng doubleValue];
        lblLocation2.text = sLocation;
        CLLocationCoordinate2D coord;
        coord.latitude = [lat doubleValue];
        coord.longitude = [lng doubleValue];

        geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation: manager.location completionHandler: 
         ^(NSArray *placemarks, NSError *error) {
            //Get nearby address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
             //String to hold address
             NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
             //Print the location to console
             //NSLog(@"I am currently at %@",locatedAt); // 18.
             sLoc = [CommonFunctions stringByReplaceEmDash:locatedAt];
         
             //[CommonFunctions showMessageBox:@"WP info" :sLoc];

             cmdQuick.enabled = TRUE;
             wpiStart = [[WaypointInfo alloc] init];
             wpiStart.sName = locatedAt;
             wpiStart.dLng = dLng;
             wpiStart.dLat = dLat;
             [tbvQuick reloadData];
         
             //Set the label text to current location
             //[locationLabel setText:locatedAt];
        }];
    }    
}

- (void) locationManager: (CLLocationManager *) manager
        didFailWithError: (NSError *) error {
    /*NSString *msg = [[NSString alloc] initWithString:@"Error obtaining location"];
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
     message:msg
     delegate:nil
     cancelButtonTitle: @"Done"
     otherButtonTitles:nil];
     [alert show];
     [msg release];
     [alert release];*/
    dLat = 0.0;
    dLng = 0.0;
    
    cmdQuick.enabled = TRUE;
    //lblLocation2.text = [NSString stringWithFormat:@"Location unknown"];
}

- (IBAction) onPause:(id)sender{
    if([cmdPause.titleLabel.text isEqualToString:NSLocalizedString(@"lblPauseWaypoint", @"")]){
        startPause = [[NSDate alloc] init];        
        QuickEntry *qe = [[QuickEntry alloc] init];
        qe.startTime = startPause;
        qe.qeType = QE_PAUSE;
        [arrQE addObject:qe];
        
        [cmdPause setTitle:NSLocalizedString(@"lblStopPauseWaypoint", @"") forState:UIControlStateNormal];    
        
        [dictPause setObject:@"" forKey:startPause];
        //[cmdPause setImage:[UIImage imageNamed:@"player_end.png"] forState:UIControlStateNormal];        
    }else{
        [cmdPause setTitle:NSLocalizedString(@"lblPauseWaypoint", @"") forState:UIControlStateNormal];
        //[cmdPause setImage:[UIImage imageNamed:@"player_pause.png"] forState:UIControlStateNormal];        
        if(startPause != nil){
            [dictPause setObject:[[NSDate alloc] init] forKey:startPause];
        }
        
        for (NSUInteger i = [arrQE count]; i > 0; i--) {
            QuickEntry *qe = [arrQE objectAtIndex:i-1];
            if (qe.qeType == QE_PAUSE & qe.endTime == nil) {
                qe.endTime  = [[NSDate alloc] init];
                break;
            }
        }
    }
    [tbvQuick reloadData];
}

- (IBAction) onButton:(id)sender{
    if([cmdQuick.titleLabel.text isEqualToString:NSLocalizedString(@"lblStartWorktime", @"")]){
        startTime = [[NSDate alloc] init];
        QuickEntry *qe = [[QuickEntry alloc] init];
        qe.startTime = startTime;
        qe.qeType = QE_WORKTIME;
        [arrQE addObject:qe];
        
        dictPause = [[NSMutableDictionary alloc] init];
        
        
        endTime = nil;
        [cmdQuick setTitle:NSLocalizedString(@"lblStopWorktime", @"") forState:UIControlStateNormal];
        [cmdQuick setImage:[UIImage imageNamed:@"player_stop.png"] forState:UIControlStateNormal];
        //[cmdPause setTitle:NSLocalizedString(@"lblPauseWaypoint", @"") forState:UIControlStateNormal];
        //[cmdPause setHidden:FALSE];
        
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                 target:self
                                               selector:@selector(updateCounter:)
                                               userInfo:nil
                                                repeats:YES];
        [tbvQuick reloadData];
        
        if(cfgMgr.bUseGeoFencing == TRUE & dLat != 0 & dLng != 0 & sLoc != nil){
            OrderedDictionary *od = [[OrderedDictionary alloc] init];
            [od setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ];
            //[od setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];
            [od setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"iduser" ];  
            [od setObject: [NSString stringWithFormat:@"%f", dLat] forKey: @"lat" ];
            [od setObject: [NSString stringWithFormat:@"%f", dLng] forKey: @"lng" ];
            /*unichar u[1] = {0x2013};    // I think em-dash is 0x2014
            NSString *emdash = [NSString stringWithCharacters:u length:sizeof(u)
                                / sizeof(unichar)];
            
            sLoc = [sLoc stringByReplacingOccurrencesOfString:emdash withString:@"-"];
            */
            [od setObject: sLoc forKey: @"name" ];
            [od setObject: @"" forKey: @"idclient" ];
            [od setObject: @"" forKey: @"idproject" ];
            [od setObject: @"" forKey: @"idworkcode" ];
            ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
            
            srWaypoint = [[SOAPRequester alloc] init];
            srWaypoint.delegate = self;
            [srWaypoint sendSOAPRequest:cfgTmp message:@"UpdateWaypoint" od:od];
        }
    }else if([cmdQuick.titleLabel.text isEqualToString:NSLocalizedString(@"lblStopWorktime", @"")]){
        [timer invalidate];
        
        endTime = [[NSDate alloc] init];
        for (NSUInteger i = [arrQE count]; i > 0; i--) {
            QuickEntry *qe = [arrQE objectAtIndex:i-1];
            if (qe.qeType == QE_WORKTIME & qe.endTime == nil) {
                qe.endTime  = [[NSDate alloc] init];
                break;
            }
        }
        
        [cmdQuick setTitle:NSLocalizedString(@"lblSaveWorktime", @"") forState:UIControlStateNormal];
        [cmdQuick setImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
        [cmdPause setHidden:TRUE];
        [tbvQuick reloadData];
//        tbvQuick.contentSize = CGSizeMake(tbvQuick.contentSize.width, tbvQuick.contentSize.height+30);
    }else if([cmdQuick.titleLabel.text isEqualToString:NSLocalizedString(@"lblSaveWorktime", @"")]){
        if (bInvalideTime) {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titErrorInput", @"") message:NSLocalizedString(@"msgTimeValueError", @"")];
            return;
        }
        
        if(sClient == nil){
            [CommonFunctions showMessageBox:NSLocalizedString(@"titMissingInput", @"") message:[NSString stringWithFormat: NSLocalizedString(@"msgPleaseSelectA", @""), NSLocalizedString(@"lblClient", @"")]];
            return;
        }
        if(sProject == nil){
            [CommonFunctions showMessageBox:NSLocalizedString(@"titMissingInput", @"") message:[NSString stringWithFormat: NSLocalizedString(@"msgPleaseSelectA", @""), NSLocalizedString(@"lblProject", @"")]];
            return;
        }
        if(sWorkcode == nil){
            [CommonFunctions showMessageBox:NSLocalizedString(@"titMissingInput", @"") message:[NSString stringWithFormat: NSLocalizedString(@"msgPleaseSelectA", @""), NSLocalizedString(@"lblWorkcode", @"")]];
            return;
        }
        // ATTENTION Return project overwrittes sProject
        if(cfgMgr.bUseGeoFencing == TRUE & dLat != 0 & dLng != 0 ){
            
            int nClient= 0;
            if(![sClient isEqualToString:@""]){
                for (NSUInteger i = 0; i < [cfgMgr.aClients count]; i++) {
                    ClientEntry *prjEntry = [cfgMgr.aClients objectAtIndex:i]; 
                    if([prjEntry.sClient isEqualToString:sClient]){
                        nClient = prjEntry.nClientID;
                        break;
                    }
                }
            }
            
            int nProject= 0;
            if(![sProject isEqualToString:@""] && clientEntry != nil){
                for (NSUInteger i = 0; i < [clientEntry.aProjects count]; i++) {
                    ProjectEntry *prjEntry = [clientEntry.aProjects objectAtIndex:i]; 
                    if([prjEntry.sProjectName isEqualToString:sProject]){
                        nProject = prjEntry.nProjectID;
                        break;
                    }
                }
            }
            
            int nWorkcode= 0;
            if(![sWorkcode isEqualToString:@""]){
                for (NSUInteger i = 0; i < [cfgMgr.aWorkcodes count]; i++) {
                    WorkcodeEntry *prjEntry = [cfgMgr.aWorkcodes objectAtIndex:i]; 
                    if([prjEntry.sWorkcode isEqualToString:sWorkcode]){
                        nWorkcode = prjEntry.nWorkcodeID;
                        break;
                    }
                }
            }
            
            bEndWaypoint = TRUE;
            OrderedDictionary *od = [[OrderedDictionary alloc] init];
            [od setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ]; 
            //[od setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ]; 
            [od setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"iduser" ];  
            [od setObject: [NSString stringWithFormat:@"%f", dLat] forKey: @"lat" ];
            [od setObject: [NSString stringWithFormat:@"%f", dLng] forKey: @"lng" ];
            [od setObject: sLoc forKey: @"name" ];
            [od setObject: [NSString stringWithFormat:@"%d",nClient] forKey: @"idclient" ];
            [od setObject: [NSString stringWithFormat:@"%d",nProject] forKey: @"idproject" ];
            [od setObject: [NSString stringWithFormat:@"%d",nWorkcode] forKey: @"idworkcode" ];
            ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
            
            srWaypoint = [[SOAPRequester alloc] init];
            srWaypoint.delegate = self;
            [srWaypoint sendSOAPRequest:cfgTmp message:@"UpdateWaypoint" od:od];
            
        }else {
            [self save:nil];
        }
        //[self save:nil];
    }
}

- (IBAction) save:(id)sender{
    
    int nClient= 0;
    if(![sClient isEqualToString:@""]){
        for (NSUInteger i = 0; i < [cfgMgr.aClients count]; i++) {
            ClientEntry *prjEntry = [cfgMgr.aClients objectAtIndex:i]; 
            if([prjEntry.sClient isEqualToString:sClient]){
                nClient = prjEntry.nClientID;
                break;
            }
        }
    }
    
    int nProject= 0;
    if(![sProject isEqualToString:@""] && clientEntry != nil){
        for (NSUInteger i = 0; i < [clientEntry.aProjects count]; i++) {
            ProjectEntry *prjEntry = [clientEntry.aProjects objectAtIndex:i]; 
            if([prjEntry.sProjectName isEqualToString:sProject]){
                nProject = prjEntry.nProjectID;
                break;
            }
        }
    }
    
    int nWorkcode= 0;
    if(![sWorkcode isEqualToString:@""]){
        for (NSUInteger i = 0; i < [cfgMgr.aWorkcodes count]; i++) {
            WorkcodeEntry *prjEntry = [cfgMgr.aWorkcodes objectAtIndex:i]; 
            if([prjEntry.sWorkcode isEqualToString:sWorkcode]){
                nWorkcode = prjEntry.nWorkcodeID;
                break;
            }
        }
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
    
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
	[df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
	[df3 setDateFormat:@"HH:mm:ss"];
    
    QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:0:0]];
    //qe2.startTime = [timePicker.date copy];
    
    NSString *sTmp = [NSString stringWithFormat:@"%@ %@", sDate, [df3 stringFromDate:qe2.startTime]];
    NSDate * dTmp = [df dateFromString:sTmp];
    
    NSString *sTmp2 = [NSString stringWithFormat:@"%@ %@", sDate, [df3 stringFromDate:qe2.endTime]];
    NSDate * dTmp2 = [df dateFromString:sTmp2];
    
    OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
    NSString* sID = @"-1";
    [mutable setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ];
    //[mutable setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];
    [mutable setObject: sID forKey: @"idtimesheet"];
    [mutable setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"iduser" ];
    [mutable setObject: [NSString stringWithFormat:@"%d", nClient] forKey: @"idclient" ];
    [mutable setObject: [NSString stringWithFormat:@"%d", nProject] forKey: @"idproject" ];
    [mutable setObject: [NSString stringWithFormat:@"%d", nWorkcode] forKey: @"idworkcode" ];    
    [mutable setObject: [df2 stringFromDate:dTmp] forKey: @"timeFrom" ];
    [mutable setObject: [df2 stringFromDate:dTmp2] forKey: @"timeTo" ];
    [mutable setObject: (sDescription != nil ? sDescription : @"") forKey: @"description" ];
       
    ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
    
    sr = [[SOAPRequester alloc] init];
    sr.delegate = self;
    [sr sendSOAPRequest:cfgTmp message:@"UpdateTimesheetEntry" od:mutable];

}

- (void)updateCounter:(NSTimer *)theTimer {
    [tbvQuick reloadData];
}

- (void) foundXMLElement: (NSObject*)sourceXmlReader:(NSString*)sElementName:(NSMutableString*)sValue{
    
    /*UIAlertView *alert = [[UIAlertView alloc] 
     initWithTitle:@"XMLReader Test"
     message:[NSString stringWithFormat:@"FOUND Element %@:%@", sElementName, sValue] 
     delegate:self  
     cancelButtonTitle:@"OK" 
     otherButtonTitles:nil];*/
    if([sElementName isEqualToString:@"idwaypoint"]){
        if(wpiStart == nil)
            wpiStart = [[WaypointInfo alloc] init];
        
        wpiStart.nWaypointId = sValue.intValue;
        if (wpiStart.nWaypointId == -1) {
            bErrorSessionId = TRUE;
        }
    }else if([sElementName isEqualToString:@"idclient"]){
        wpiStart.nClientId = sValue.intValue;
    }else if([sElementName isEqualToString:@"idproject"]){
        wpiStart.nProjectId = sValue.intValue;
    }else if([sElementName isEqualToString:@"idworkcode"]){
        wpiStart.nWorkcodeId = sValue.intValue;
    }else if([sElementName isEqualToString:@"client"]){
        wpiStart.sClient = [sValue copy];
        if(![wpiStart.sClient isEqualToString:@""]){
            sClient = [wpiStart.sClient copy];
        }
        for (int i = 0; i < cfgMgr.aClients.count; i++) {
            if (((ClientEntry*)[cfgMgr.aClients objectAtIndex:i]).nClientID == wpiStart.nClientId) {
                clientEntry = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:i]);
                break;
            }
        }
    }else if([sElementName isEqualToString:@"project"]){
        wpiStart.sProject = [sValue copy];
        if(![wpiStart.sProject isEqualToString:@""]){
            sProject = [wpiStart.sProject copy];
        }
    }else if([sElementName isEqualToString:@"workcode"]){
        wpiStart.sWorkcode = [sValue copy];
        if(![wpiStart.sWorkcode isEqualToString:@""]){
            sWorkcode = [wpiStart.sWorkcode copy];
        }
    }else if([sElementName isEqualToString:@"return"]){
        int nRet = sValue.intValue;
        if(nRet <= 0){
            //Error
            nRet = nRet;
            if(nRet == -1){
                bErrorSessionId = TRUE;
            }
        }else {
            /*[UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
            viewTextNew.transform = transform;
            [UIView commitAnimations];
            [txtNewConfigText resignFirstResponder];
            //NSMutableArray *arrTmp;
            */
            
            if([sValue isEqualToString:@"-1"]){
                bErrorSessionId = true;
                [self doneNewConfigText];
                return;
            }
            BOOL bFound = NO;
            if(nConfigID == 0){
                for (int i = 0; i < cfgMgr.aClients.count; i++) {
                    ClientEntry *ce = [cfgMgr.aClients objectAtIndex:i];
                    if(ce.nClientID == nRet){
                        clientEntry = ce;
                        bFound = YES;
                        break;
                    }
                }
                if(!bFound){
                    ClientEntry *clientEntry2 = [[ClientEntry alloc] init];
                    clientEntry2.nClientID = nRet;
                    clientEntry2.sClient = [txtNewConfigText.text copy];
                    [cfgMgr.aClients addObject:clientEntry2];
                    clientEntry = clientEntry2;
                }
                sClient = [txtNewConfigText.text copy];
                sProject = nil;
                wpiStart.sClient = [txtNewConfigText.text copy];
                wpiStart.nClientId = nRet;
            }else if (nConfigID == 1) {
                if (clientEntry != nil) {
                    for (int i = 0; i < clientEntry.aProjects.count; i++) {
                        ProjectEntry *ce = [clientEntry.aProjects objectAtIndex:i];
                        if(ce.nProjectID == nRet){
                            bFound = YES;
                            break;
                        }
                    }
                    if(!bFound){
                        ProjectEntry *projectEntry = [[ProjectEntry alloc] init];
                        projectEntry.nProjectID = nRet;
                        projectEntry.sProjectName = [txtNewConfigText.text copy];
                        NSLog(@"Before ADD %d", clientEntry.aProjects.count);
                        if (clientEntry != nil) {
                            if (clientEntry.aProjects == nil)
                                clientEntry.aProjects = [[NSMutableArray alloc] init];
                            [clientEntry.aProjects addObject:projectEntry];
                        }
                        NSLog(@"After ADD %d", clientEntry.aProjects.count);                        
                    }
                    sProject = [txtNewConfigText.text copy];
                    wpiStart.sProject = [txtNewConfigText.text copy];
                    wpiStart.nProjectId = nRet;
                }
            }else {
                for (int i = 0; i < cfgMgr.aWorkcodes.count; i++) {
                    WorkcodeEntry *ce = [cfgMgr.aWorkcodes objectAtIndex:i];
                    if(ce.nWorkcodeID == nRet){
                        bFound = YES;
                        break;
                    }
                }
                if(!bFound){
                    WorkcodeEntry *workcodeEntry = [[WorkcodeEntry alloc] init];
                    workcodeEntry.nWorkcodeID = nRet;
                    workcodeEntry.sWorkcode = [txtNewConfigText.text copy];
                    [cfgMgr.aWorkcodes addObject:workcodeEntry];
                }
                sWorkcode = [txtNewConfigText.text copy];
                wpiStart.sWorkcode = [txtNewConfigText.text copy];
                wpiStart.nWorkcodeId = nRet;
            }
            [self doneNewConfigText];
            [tbvQuick reloadData];
            
        }
    }
}

- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error{
    
    //[actMain stopAnimating];
    [CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @"") message:[error description]];
    
}

- (void) gotSOAPAnswere:(NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data{   
    
    //[actMain stopAnimating];
    if(requester == srWaypoint){
        if (!bEndWaypoint) {
            NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
            [aElementsToFind addObject:@"idwaypoint"];
            [aElementsToFind addObject:@"idclient"];
            [aElementsToFind addObject:@"idproject"];
            [aElementsToFind addObject:@"idworkcode"];
            [aElementsToFind addObject:@"client"];
            [aElementsToFind addObject:@"project"];
            [aElementsToFind addObject:@"workcode"];
            
            xmlReader = [[XMLReader alloc] init];
            xmlReader.delegate = self;
            [xmlReader parseForElements:aElementsToFind data:srWaypoint.webData];
            if (bErrorSessionId) {
                [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];
            }else {
                /*if (bEndWaypoint) {
                    [self save:nil];
                }*/
            }
        }else {
            [self save:nil];
        }
        
        
        return;
    }else if (requester == srConfigText) {
        NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"return"];
        
        xmlReader = [[XMLReader alloc] init];
        xmlReader.delegate = self;
        [xmlReader parseForElements:aElementsToFind data:srConfigText.webData];
        
        if (bErrorSessionId) {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];
        }
        return;
    }
    
    if(requester == sr){
        NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"return"];
        xmlReader = [[XMLReader alloc] init];
        xmlReader.delegate = self;
        [xmlReader parseForElements:aElementsToFind data:sr.webData];
        if (bErrorSessionId) {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];
        }else {
            [delegate closeQuickView:0];
        }
        return;
    }
}


#pragma mark - Tableview functions

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int nRet = 0;
    if(cfgMgr.bUseGeoFencing && wpiStart != nil)
        nRet++;
    if(startTime != nil)
        nRet++;
    if(endTime != nil)
        nRet+=2;
    for (NSUInteger i = 0; i < [arrQE count]; i++) {
        QuickEntry *qe = [arrQE objectAtIndex:i];
        if (qe.qeType == QE_PAUSE) {
            nRet++;
            break;
        }
    }
    return nRet;
    //return 1;
}

//Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int nPause = 0;
    for (NSUInteger i = [arrQE count]; i > 0; i--) {
        QuickEntry *qe = [arrQE objectAtIndex:i-1];
        if(qe.qeType == QE_PAUSE){
            nPause += 1;
        }
    }
    
    if(cfgMgr.bUseGeoFencing && wpiStart != nil){
        if(section == 0){
            if (startTime == nil) {
                return 1;
            }else {
                if(endTime != nil)
                    return 3;
                else
                    return 2;
            }
        }else if(nPause > 0 & section == 1){
            return nPause;
        }else if((nPause > 0 & section == 2) || (nPause == 0 & section == 1) ){
            if(endTime != nil)
                if (clientEntry != nil) {
                    return 3;
                }else {
                    return 2;
                }
            else
                return 1;
        }else if ((nPause > 0 & section == 4) || (nPause == 0 & section == 3)) {
            return 2;
        }else {
            return 1;
        }
    }else {
        if(section == 0){
            if(endTime != nil)
                return 3;
            else
                return 2;
        }else if(nPause > 0 & section == 1){
                return nPause;
        }else if((nPause > 0 & section == 2) || (nPause == 0 & section == 1) ){
                //return 3;
            if (clientEntry != nil) {
                return 3;
            }else {
                return 2;
            }
        }else {
                return 1;
        }
    }
}

-(int)getPlace:(int)nOrder:(int)nSection{
    int nRet = 0;
    if(arrQE != nil){
        if(nSection == 0){
            for (NSUInteger i = 0; i < [arrQE count]; i++) {
                QuickEntry *qe = [arrQE objectAtIndex:i];
                if (qe.qeType == QE_WORKTIME) {
                    if(qe.endTime != nil){
                        //return i + 2;
                        if(nOrder >= nRet & nOrder <= nRet + 4)
                            return i;
                        nRet += 5;
                    }else{
                        if(nOrder >= nRet & nOrder <= nRet + 1)
                            return i;
                        nRet += 2;
                        //return i + 1;
                    }
                }else if(qe.qeType == QE_PAUSE){
                    if(nOrder == nRet)
                        return i;
                    nRet += 1;
                    
                }
                //if(nRet == nOrder)
                //    return i;
            }
        }else if(nSection == 1){
            nRet = 0;
            for (NSUInteger i = 0; i < [arrQE count]; i++) {
                QuickEntry *qe = [arrQE objectAtIndex:i];
                if(qe.qeType == QE_PAUSE){
                    if(nOrder == nRet)
                        return i;                  
                    nRet += 1;
                }
                
                //if(nRet == nOrder)
                //    return i;
            }
        }
    }
    return nRet;
}

-(int)getBase:(int)nOrder{
    int nRet = 0;
    if(arrQE != nil){
        for (NSUInteger i = 0; i < [arrQE count]; i++) {
            QuickEntry *qe = [arrQE objectAtIndex:i];
            if (qe.qeType == QE_WORKTIME) {
                if(qe.endTime != nil){
                    if(nOrder >= nRet & nOrder <= nRet + 4)
                        return nRet;
                    nRet += 5;
                }else{
                    if(nOrder >= nRet & nOrder <= nRet + 1)
                        return nRet;
                    nRet += 2;
                }
            }else if(qe.qeType == QE_PAUSE){
                if(nOrder == nRet)
                    return nRet;
                nRet += 1;
            }
        }
    }
    return nRet;
}

-(NSString*)getTimeInterval:(NSDate*)dFrom:(NSDate*)dTo{
    if(dTo == nil)
        dTo = [[NSDate alloc] init];
    NSTimeInterval timeDifference = [dTo timeIntervalSinceDate:dFrom];
	//totalTime = totalTime + (int)timeDifference;
	
	int nHours = ((int)(((int)timeDifference)/60/60));
	int nMinutes = ((int)(((((int)timeDifference) / 60) - (nHours * 60))));
	int nSeconds = ((int)(((((int)timeDifference)) - (nHours * 60 * 60) - (nMinutes * 60))));
	
    if(nHours < 0 | nMinutes < 0 | nSeconds < 0){
        bInvalideTime = TRUE;
        return @"--:--:--";
    }else {
        bInvalideTime = FALSE;
    }  
    
   	NSString *sSecExt = @"";
	NSString *sMinExt = @"";
	NSString *sAllExt = @"";
    
    if(nSeconds < 10)
		sSecExt = @"0";
	else if(nSeconds < 0){
		if(nSeconds > -10)
			sSecExt = @"0";
		//sAllExt = @"-";
		nSeconds *= -1;
	}
    
	if(nMinutes < 10 & nMinutes >= 0)
		sMinExt = @"0";
	else if(nMinutes < 0){
		if(nMinutes > -10)
			sMinExt = @"0";
		sAllExt = @"-";
		nMinutes *= -1;
	}
	if(nHours < 10){
        sAllExt = @"0";
    }
    return [NSString stringWithFormat:@"%@%d:%@%d:%@%d",sAllExt, nHours, sMinExt, nMinutes, sSecExt, nSeconds];
}

//Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int nPause = 0;
    for (NSUInteger i = [arrQE count]; i > 0; i--) {
        QuickEntry *qe = [arrQE objectAtIndex:i-1];
        if(qe.qeType == QE_PAUSE){
            nPause += 1;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];  
    
	/////////////////
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
	[df setDateFormat:(cfgMgr.bShowSeconds ? @"HH:mm:ss" : @"HH:mm")];
	[df setTimeZone:[NSTimeZone systemTimeZone]];
	[df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
	[df2 setDateFormat:@"HH:mm:ss"];
	[df2 setTimeZone:[NSTimeZone systemTimeZone]];
	[df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    //NSString * sStartTime = [df stringFromDate:startTime];
    //NSString * sEndTime = [df stringFromDate:endTime];
    
    NSDate * timeNow = [[NSDate alloc] init];
	NSTimeInterval timeDifference = [timeNow timeIntervalSinceDate:startTime];
	//totalTime = totalTime + (int)timeDifference;
	
	int nHours = ((int)(((int)timeDifference)/60/60));
	int nMinutes = ((int)(((((int)timeDifference) / 60) - (nHours * 60))));
	int nSeconds = ((int)(((((int)timeDifference)) - (nHours * 60 * 60) - (nMinutes * 60))));
	
   	NSString *sSecExt = @"";
	NSString *sMinExt = @"";
	NSString *sAllExt = @"";
    
    if(nSeconds < 10)
		sSecExt = @"0";
	else if(nSeconds < 0){
		if(nSeconds > -10)
			sSecExt = @"0";
		//sAllExt = @"-";
		nSeconds *= -1;
	}
    
	if(nMinutes < 10 & nMinutes >= 0)
		sMinExt = @"0";
	else if(nMinutes < 0){
		if(nMinutes > -10)
			sMinExt = @"0";
		sAllExt = @"-";
		nMinutes *= -1;
	}
	if(nHours < 10){
        sAllExt = @"0";
    }
	/*if(nHours < 0){
     sAllExt = @"-
     nHours *= -1; 
     }*/
    
    if(cfgMgr.bUseGeoFencing && wpiStart != nil){
        if(indexPath.section == 0){
            if (startTime == nil) {
                //return 1;
                [cell textLabel].text = [NSString stringWithFormat:@"Start WP: %@", wpiStart.sName];
                [cell imageView].image = [UIImage imageNamed:@"flag_green.png"];
            }else {
                /*if(endTime != nil){
                    //return 3;
                }else{
                    //return 2;
                }*/
                int nTest = [self getPlace:indexPath.row:0];    
                
                if(arrQE != nil & arrQE.count > 0 & arrQE.count > nTest){
                    QuickEntry *qe = [arrQE objectAtIndex:nTest];
                    if (qe.qeType == QE_WORKTIME) {
                        QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:indexPath.row:0]];
                        
                        if(indexPath.row == 0){

                            NSString * sStartTime = [df stringFromDate:qe2.startTime];
                            [cell imageView].image = [UIImage imageNamed:@"start-icon.png"]; //Clock-icon.png"]
                    
                            [cell textLabel].text = [NSString stringWithFormat:@"%@%@",(cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblStartTime", @"")] : @""), sStartTime];

                        }else if (indexPath.row == 1) {
                            [cell textLabel].text = [NSString stringWithFormat:@"%@%@",(cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblWorkTime", @"")] : @""), [self getTimeInterval:qe2.startTime :qe2.endTime]];//[NSString stringWithFormat:@"Work Time: %@", [self getTimeInterval:qe2.startTime :qe2.endTime]];
                            [cell imageView].image = [UIImage imageNamed:@"Clock-icon.png"];
                        }else if (indexPath.row == 2) {
                            NSString * sEndTime = [df stringFromDate:qe2.endTime];
                            [cell textLabel].text = [NSString stringWithFormat:@"%@%@",(cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblEndTime", @"")] : @""), sEndTime];//[NSString stringWithFormat:@"End Time: %@", sEndTime];
                            [cell imageView].image = [UIImage imageNamed:@"player_stop.png"];
                        }
                    }
                }
            }
        }else if(nPause > 0 & indexPath.section == 1){
            //if(indexPath.row == [self getBase:indexPath.row]){
                QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:indexPath.row:0]];
                NSString * sStartTime = [df stringFromDate:qe2.startTime];
                
                NSString * sEndTime;
                if (qe2.endTime != nil) {
                    sEndTime = [df stringFromDate:qe2.endTime];
                }else{
                    sEndTime = [df2 stringFromDate:[[NSDate alloc] init]];
                }
                
                [cell textLabel].text = [NSString stringWithFormat:@"%@: %@ - %@", NSLocalizedString(@"lblPause", @""), sStartTime, sEndTime];
                [cell imageView].image = [UIImage imageNamed:@"player_pause.png"];        
            //}
        }else if((nPause > 0 & indexPath.section == 2) || (nPause == 0 & indexPath.section == 1) ){
            if(endTime != nil){
                //return 3;
                static NSString *CellIdentifier = @"PickerCustomCell";
                PickerCustomCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if(cell2 == nil){
                    //NSLog(@"New cell made");
                    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickerCustomCell" owner:self options:nil];
                    for(id currentObject in topLevelObjects){
                        if([currentObject isKindOfClass:[PickerCustomCell class]]){
                            cell2 = (PickerCustomCell *)currentObject;
                            break;
                        }
                    }
                }
                [cell2 setDelegate:self];
                if(indexPath.row == 0){
                    [cell2 lblTime].text = [NSString stringWithFormat:@"%@", sClient != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"lblClient", @""), sClient] : sClient) : [NSString stringWithFormat:@"<Select %@>", NSLocalizedString(@"lblClient", @"")]];
                    [cell2 imgView].image = [UIImage imageNamed:@"user_business.png"];
                    //[cell ].
                }else if(clientEntry != nil & indexPath.row == 1){
                    //[cell2 lblTime].text = [NSString stringWithFormat:@"%@", sProject != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"Project: %@", sProject] : sProject) : @"<Select Project>"];
                    [cell2 lblTime].text = [NSString stringWithFormat:@"%@", sProject != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"lblProject", @""), sProject] : sProject) : [NSString stringWithFormat:@"<Select %@>", NSLocalizedString(@"lblProject", @"")]];
                    [cell2 imgView].image = [UIImage imageNamed:@"folder.png"];
                }else if((clientEntry == nil & indexPath.row == 1) | (clientEntry != nil & indexPath.row == 2)){
                    //[cell2 lblTime].text = [NSString stringWithFormat:@"%@", sWorkcode != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"Workcode: %@", sWorkcode] : sWorkcode) : @"<Select Workcode>"];
                    [cell2 lblTime].text = [NSString stringWithFormat:@"%@", sWorkcode != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"lblWorkcode", @""), sWorkcode] : sWorkcode) : [NSString stringWithFormat:@"<Select %@>", NSLocalizedString(@"lblWorkcode", @"")]];
                    [cell2 imgView].image = [UIImage imageNamed:@"workcode.gif"];
                }
                //cell2.quickView = self;
                cell2.nID = indexPath.row;
                return cell2;
            }else{
                [cell textLabel].text = [NSString stringWithFormat:@"Start WP: %@", wpiStart.sName];
                [cell imageView].image = [UIImage imageNamed:@"flag_green.png"];                
            }
        }else if ((nPause > 0 & indexPath.section == 4) || (nPause == 0 & indexPath.section == 3)) {
            //return 2;
            if(indexPath.row == 0){
                [cell textLabel].text = [NSString stringWithFormat:@"Start WP: %@", wpiStart.sName];
                [cell imageView].image = [UIImage imageNamed:@"flag_green.png"];
            }else if (indexPath.row == 1) {
                [cell textLabel].text = [NSString stringWithFormat:@"Stop WP: %@", wpiStart.sName];
                [cell imageView].image = [UIImage imageNamed:@"flag_red.png"];
            }
                
        }else {
            [cell textLabel].text = [NSString stringWithFormat:@"%@", (sDescription != nil && (![sDescription isEqualToString:@""])) ? sDescription : NSLocalizedString(@"lblEnterDescription", @"")];
            if (sDescription == nil || [sDescription isEqualToString:@""]) {
                [cell textLabel].textColor = [UIColor lightGrayColor];
            }
            [cell imageView].image = [UIImage imageNamed:@"txt.png"];   
        }
    }else {
    
    if(indexPath.section == 0){
        int nTest = [self getPlace:indexPath.row:0];    
        
        if(arrQE != nil & arrQE.count > 0 & arrQE.count > nTest){
            QuickEntry *qe = [arrQE objectAtIndex:nTest];
            if (qe.qeType == QE_WORKTIME) {
                QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:indexPath.row:0]];
                NSString * sStartTime = [df stringFromDate:qe2.startTime];
                //qe.endTime  = [[NSDate alloc] init];
                
                if(indexPath.row == [self getBase:indexPath.row] & indexPath.section == 0){
                    [cell imageView].image = [UIImage imageNamed:@"start-icon.png"]; //Clock-icon.png"]
                    
                    [cell textLabel].text = [NSString stringWithFormat:@"%@%@",(cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblStartTime", @"")] : @""), sStartTime];//
                    
                }else if(indexPath.row == [self getBase:indexPath.row]+1 & indexPath.section == 0){
                    [cell textLabel].text = [NSString stringWithFormat:@"%@%@",(cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblWorkTime", @"")] : @""), [self getTimeInterval:qe2.startTime :qe2.endTime]];//[NSString stringWithFormat:@"Work Time: %@", [self getTimeInterval:qe2.startTime :qe2.endTime]];
                    [cell imageView].image = [UIImage imageNamed:@"Clock-icon.png"];
                }else if(indexPath.row == [self getBase:indexPath.row]+2 & indexPath.section == 0){
                    NSString * sEndTime = [df stringFromDate:qe2.endTime];
                    [cell textLabel].text = [NSString stringWithFormat:@"%@%@",(cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblEndTime", @"")] : @""), sEndTime];//[NSString stringWithFormat:@"End Time: %@", sEndTime];
                    [cell imageView].image = [UIImage imageNamed:@"player_stop.png"];
                }
                
            }else{
                if(indexPath.row == [self getBase:indexPath.row]){
                    QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:indexPath.row:0]];
                    NSString * sStartTime = [df stringFromDate:qe2.startTime];
                    
                    NSString * sEndTime;
                    if (qe2.endTime != nil) {
                        sEndTime = [df stringFromDate:qe2.endTime];
                    }else{
                        sEndTime = [df2 stringFromDate:[[NSDate alloc] init]];
                    }
                    
                    [cell textLabel].text = [NSString stringWithFormat:@"%@: %@ - %@", NSLocalizedString(@"lblPause", @""), sStartTime, sEndTime];
                    [cell imageView].image = [UIImage imageNamed:@"player_pause.png"];        
                }
            }
        }
    }else if(nPause > 0 & indexPath.section == 1){
        //if(indexPath.row == [self getBase:indexPath.row]){
        QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:indexPath.row:1]];
        NSString * sStartTime = [df stringFromDate:qe2.startTime];
        
        NSString * sEndTime;
        if (qe2.endTime != nil) {
            sEndTime = [df stringFromDate:qe2.endTime];
        }else{
            sEndTime = [df2 stringFromDate:[[NSDate alloc] init]];
        }
        
        [cell textLabel].text = [NSString stringWithFormat:@"%@: %@ - %@", NSLocalizedString(@"lblPause", @""), sStartTime, sEndTime];
        [cell imageView].image = [UIImage imageNamed:@"player_pause.png"];        
        //}
    }else if((nPause > 0 & indexPath.section == 2) || (nPause == 0 & indexPath.section == 1) ){
        //static NSString *CellIdentifier = @"PickerCustomCell";
        //PickerCustomCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        static NSString *CellIdentifier = @"PickerCustomCell";
        PickerCustomCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell2 == nil){
            //NSLog(@"New cell made");
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickerCustomCell" owner:self options:nil];
            for(id currentObject in topLevelObjects){
                if([currentObject isKindOfClass:[PickerCustomCell class]]){
                    cell2 = (PickerCustomCell *)currentObject;
                    break;
                }
            }
        }
        [cell2 setDelegate:self];
        if(indexPath.row == 0){
            [cell2 lblTime].text = [NSString stringWithFormat:@"%@", sClient != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"lblClient", @""), sClient] : sClient) : [NSString stringWithFormat:@"<Select %@>", NSLocalizedString(@"lblClient", @"")]];
            [cell2 imgView].image = [UIImage imageNamed:@"user_business.png"];
            //[cell ].
        }else if(indexPath.row == 1){
            //[cell2 lblTime].text = [NSString stringWithFormat:@"%@", sProject != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"Project: %@", sProject] : sProject) : @"<Select Project>"];
            [cell2 lblTime].text = [NSString stringWithFormat:@"%@", sProject != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"lblProject", @""), sProject] : sProject) : [NSString stringWithFormat:@"<Select %@>", NSLocalizedString(@"lblProject", @"")]];
            [cell2 imgView].image = [UIImage imageNamed:@"folder.png"];
        }else if(indexPath.row == 2){
            //[cell2 lblTime].text = [NSString stringWithFormat:@"%@", sWorkcode != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"Workcode: %@", sWorkcode] : sWorkcode) : @"<Select Workcode>"];
            [cell2 lblTime].text = [NSString stringWithFormat:@"%@", sWorkcode != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"lblWorkcode", @""), sWorkcode] : sWorkcode) : [NSString stringWithFormat:@"<Select %@>", NSLocalizedString(@"lblWorkcode", @"")]];
            [cell2 imgView].image = [UIImage imageNamed:@"workcode.gif"];
        }
        //cell2.quickView = self;
        cell2.nID = indexPath.row;
        return cell2;
    }else if((nPause > 0 & indexPath.section == 3) || (nPause == 0 & indexPath.section == 2) ){
        [cell textLabel].text = [NSString stringWithFormat:@"%@", (sDescription != nil && (![sDescription isEqualToString:@""])) ? sDescription : NSLocalizedString(@"lblEnterDescription", @"")];
        if (sDescription == nil || [sDescription isEqualToString:@""]) {
            [cell textLabel].textColor = [UIColor lightGrayColor];
        }
        [cell imageView].image = [UIImage imageNamed:@"txt.png"];    
    }
    }
	return cell;	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int nPause = 0;
    for (NSUInteger i = [arrQE count]; i > 0; i--) {
        QuickEntry *qe = [arrQE objectAtIndex:i-1];
        if(qe.qeType == QE_PAUSE){
            nPause += 1;
        }
    }
    
    if(startTime != nil & indexPath.section == 0 && (indexPath.row == 0 | indexPath.row == 2)){
        [self hideProjectPicker];
        [self hideNewConfigText];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 200);
        pickerTimeView.transform = transform;
        [self showDisabledBackground:self.view];
        [self.view addSubview:pickerTimeView];
        [UIView commitAnimations];
        if(indexPath.row == 0){
            bbiTitleTime.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblStartTime", @"")]; // [NSString stringWithFormat:@"Select starttime"]; 
            
            QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:0:0]];
            timePicker.date = qe2.startTime;
            nTimeMode = 0;
        }else{
            bbiTitleTime.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblEndTime", @"")]; //[NSString stringWithFormat:@"Select endtime"]; 
            QuickEntry *qe2 = [arrQE objectAtIndex:[self getPlace:0:0]];
            timePicker.date = qe2.endTime;
            nTimeMode = 1;
        }
        
        //[timePicker reloadData];
    }
    
    if((!cfgMgr.bUseGeoFencing && nPause > 0 &  indexPath.section == 2) || (!cfgMgr.bUseGeoFencing && nPause == 0 & indexPath.section == 1) || ((cfgMgr.bUseGeoFencing && endTime != nil ) && nPause == 0 & indexPath.section == 1) || ((cfgMgr.bUseGeoFencing && endTime != nil ) && nPause > 0 &  indexPath.section == 2) ){
        if(indexPath.row == 0){
            nPickerMode = 0;
            bbiTitle.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblClient", @"")];
        }else if(indexPath.row == 1){
            nPickerMode = 1;
            bbiTitle.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblProject", @"")]; 
        }else{
            nPickerMode = 2;            
            bbiTitle.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblWorkcode", @"")];
        }
        
        [self hideTimePicker];
        [self hideNewConfigText];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 200);
        pickerProjectView.transform = transform;
        [self showDisabledBackground:self.view];
        [self.view addSubview:pickerProjectView];
        [UIView commitAnimations];
        
        //[projectPicker reloadData];
        if(indexPath.row == 0){
            if(![sClient isEqualToString:@""]){
                [projectPicker reloadAllComponents];
                for (NSUInteger i = 0; i < [cfgMgr.aClients count]; i++) {
                    ClientEntry *cliEntry = [cfgMgr.aClients objectAtIndex:i]; 
                    if([cliEntry.sClient isEqualToString:sClient]){
                        [projectPicker selectRow:i inComponent:0 animated:YES];
                        break;
                    }
                }
            } 
        }else if(indexPath.row == 1){
            if(![sProject isEqualToString:@""] && clientEntry != nil){
                [projectPicker reloadAllComponents];
                for (NSUInteger i = 0; i < [clientEntry.aProjects count]; i++) {
                    ProjectEntry *prjEntry = [clientEntry.aProjects objectAtIndex:i]; 
                    if([prjEntry.sProjectName isEqualToString:sProject]){
                        [projectPicker selectRow:i inComponent:0 animated:YES];
                        break;
                    }
                }
            } 
        }else if(indexPath.row == 2){
            if(![sWorkcode isEqualToString:@""]){
                [projectPicker reloadAllComponents];
                for (NSUInteger i = 0; i < [cfgMgr.aWorkcodes count]; i++) {
                    WorkcodeEntry *prjEntry = [cfgMgr.aWorkcodes objectAtIndex:i]; 
                    if([prjEntry.sWorkcode isEqualToString:sWorkcode]){
                        [projectPicker selectRow:i inComponent:0 animated:YES];
                        break;
                    }
                }
            } 
        }
    }else if((nPause > 0 &  indexPath.section == 3) || (nPause == 0 & indexPath.section == 2) ){
        [self hideTimePicker];
        [self hideProjectPicker];
        
        containerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, 320, 40)];//255
        
        textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
        textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        
        textView.minNumberOfLines = 1;
        textView.maxNumberOfLines = 6;
        textView.returnKeyType = UIReturnKeyDefault; //just as an example
        textView.font = [UIFont systemFontOfSize:15.0f];
        textView.delegate = self;
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        textView.backgroundColor = [UIColor whiteColor];
        //textView.
        
        // textView.text = @"test\n\ntest";
        // textView.animateHeightChange = NO; //turns off animation
        [self showDisabledBackground:self.view];        
        [self.view addSubview:containerView];
        
        UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
        UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
        entryImageView.frame = CGRectMake(5, 0, 248, 40);
        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
        UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // view hierachy
        [containerView addSubview:imageView];
        [containerView addSubview:textView];
        [containerView addSubview:entryImageView];
        
        UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
        doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
        
        [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
        doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
        doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(resignTextView) forControlEvents:UIControlEventTouchUpInside];
        [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
        [containerView addSubview:doneBtn];
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [textView becomeFirstResponder];        
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0)
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    else if (indexPath.section == 1) {
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    }else {
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    }
}

- (void)setDelegate:(id)val{
	delegate = val;
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item == tbiTimesheet) {
        [self dismissModalViewControllerAnimated:NO];
    }else if (item == tbiReports) {
        ReportMainViewController *myNewVC = [[ReportMainViewController alloc] init];
        myNewVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        myNewVC.cfgMgr = cfgMgr;
        myNewVC.la = la;
        myNewVC.dSelectedMonth = dSelectedDate;
        [self presentModalViewController:myNewVC animated:YES];

    }else if (item == tbiConfig) {
        if(configMainView == nil)
            configMainView = [[ConfigMainViewController alloc] init];
        
        configMainView.bOpenDataConfig = TRUE;
        configMainView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        configMainView.cfgMgr = cfgMgr;
        configMainView.la = la;
        [configMainView setDelegate:self];
        [self presentModalViewController:configMainView animated:YES];
    }
    tabMain.selectedItem = tbiQuickview;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillHide:) 
													 name:UIKeyboardWillHideNotification 
												   object:nil];		
	}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(cfgMgr.bUseGeoFencing == TRUE)
        cmdQuick.enabled = FALSE;
    sLoc = @"";
    tabMain.selectedItem = tbiQuickview;
    bNewText = FALSE;
    arrQE = [[NSMutableArray alloc] init];
    
    if(lm == nil)
        lm = [[CLLocationManager alloc ] init];
    
    if ( [CLLocationManager locationServicesEnabled])
    {
        lm.delegate = self;
        lm.desiredAccuracy = kCLLocationAccuracyBest;
        lm.distanceFilter = 1.0f;
        [lm startUpdatingLocation];
    }
    bMon = [CLLocationManager regionMonitoringAvailable];
    /*if([CLLocationManager regionMonitoringAvailable]){
        int i = 0;
        i = i;
    }*/
    
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerProjectView.transform = transform;
	pickerWorkcodeView.transform = transform;
    pickerTimeView.transform = transform;
    viewTextNew.transform = transform;
	[UIView commitAnimations];
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
