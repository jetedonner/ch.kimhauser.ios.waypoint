//
//  ViewController.m
//  Waypoint
//
//  Created by Kim David Hauser on 02.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import "ViewController.h"
#import "TimeSheetViewController.h"
#import "ConfigMainViewController.h"
#import "MembershipMainViewController.h"
#import "CommonFunctions.h"
#import <CommonCrypto/CommonHMAC.h>

@interface ViewController ()

@end

@implementation ViewController

- (NSString *) hashString :(NSString *) data withSalt: (NSString *) salt {
    
    
    const char *cKey  = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    return hash;
    
}

- (void)closeConfigMainView{
    [configMainView dismissModalViewControllerAnimated:YES];
    configMainView = nil;
    [tbvLogin reloadData];
}

- (void) saveConfig{    
    [cfgMgr saveData];
}

- (void) foundXMLElement: (NSObject*)sourceXmlReader:(NSString*)sElementName:(NSMutableString*)sValue{
    /*UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:@"Connection Test OK!"
     message:[NSString stringWithFormat:@"Server says: %@", sValue]
     delegate:self
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     [alert show];
     [alert release];
     */
    if (sourceXmlReader == xmlReaderWP) {
        if ([sElementName isEqualToString:@"idwaypoint"])
        {
            waypointInfo = [[WaypointInfo alloc] init];
            waypointInfo.nWaypointId = [sValue intValue];
            if (waypointInfo.nWaypointId == -1) {
                bErrorSessionID = TRUE;
            }
        }else if ([sElementName isEqualToString:@"lat"])
        {
            waypointInfo.dLat = [sValue doubleValue];
        }else if ([sElementName isEqualToString:@"lng"])
        {
            waypointInfo.dLng = [sValue doubleValue];
        }else if ([sElementName isEqualToString:@"radius"])
        {
            waypointInfo.dRad = [sValue doubleValue];
        }else if ([sElementName isEqualToString:@"waypoint"])
        {
            waypointInfo.sName = [sValue copy];
        }else if ([sElementName isEqualToString:@"idclient"])
        {
            waypointInfo.nClientId = [sValue intValue];
        }else if ([sElementName isEqualToString:@"idproject"])
        {
            waypointInfo.nProjectId = [sValue intValue];
        }else if ([sElementName isEqualToString:@"idworkcode"])
        {
            waypointInfo.nWorkcodeId = [sValue intValue];
            [cfgMgr.aWaypoints addObject:waypointInfo];
        }
    }else if(sourceXmlReader == xmlReaderConfig){
        if ([sElementName isEqualToString:@"idclient"])
        {
            clientEntry = [[ClientEntry alloc] init];
            clientEntry.aProjects = [[NSMutableArray alloc] init];
            clientEntry.nClientID = [sValue intValue];
            if(clientEntry.nClientID == -1)
                bErrorSessionID = TRUE; 
        }else if ([sElementName isEqualToString:@"client"])
        {
            clientEntry.sClient = [NSString stringWithFormat:@"%@", sValue];// sValue;
            [cfgMgr.aClients addObject:clientEntry];
        }else if ([sElementName isEqualToString:@"idproject"])
        {
            projectEntry = [[ProjectEntry alloc] init];
            projectEntry.nProjectID = [sValue intValue];
            //if(projectEntry.nProjectID == -1)
            //    bErrorSessionID = TRUE; 
            
        }else if ([sElementName isEqualToString:@"project"])
        {
            projectEntry.sProjectName = [NSString stringWithFormat:@"%@", sValue];// sValue;
            if(cfgMgr.aClients.count > 0){
                ClientEntry *cTmp = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:cfgMgr.aClients.count-1]);
                [cTmp.aProjects addObject:projectEntry];
                cTmp = cTmp;
            }
            //[cfgMgr.aProjects addObject:projectEntry];
        }
    }else {
        if ([sElementName isEqualToString:@"result"])
        {
            la = [[LoginAnswere alloc] init];
            la.nResult = [sValue intValue];
        }else if ([sElementName isEqualToString:@"iduser"])
        {
            la.nUserID = [sValue intValue];
            cfgMgr.iduser = [sValue intValue];
        }else if ([sElementName isEqualToString:@"idmandate"])
        {
            la.nMandateID = [sValue intValue];
        }else if ([sElementName isEqualToString:@"username"])
        {
            la.sUsername = [sValue copy];
        }else if ([sElementName isEqualToString:@"idsession"])
        {
            
            la.sSessionID = [sValue copy];
            //la.sSessionID = @"";
            if(la.nResult == 0 | la.nResult == 1){
                // Bad Mandate / User / Password
                [self abortLoginProcess];
                [CommonFunctions showMessageBox:NSLocalizedString(@"titLoginError", @"") message: NSLocalizedString(@"msgLoginErrorMandateUserPwd", @"")];
            }else if(la.nResult == 2){
                // Bad app version            
                [self abortLoginProcess]; 
                [CommonFunctions showMessageBox:NSLocalizedString(@"titLoginError", @"") message: NSLocalizedString(@"msgLoginErrorAppVersion", @"")];
            }else if(la.nResult == 5){
                // Everything OK
                [self saveConfig];
                
                OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
                ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""]; 
                [mutable setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ];
                //[mutable setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];
                [mutable setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"iduser"];
                
                srConfig = [[SOAPRequester alloc] init];
                srConfig.delegate = self;
                [srConfig sendSOAPRequest:cfgTmp message:@"GetProjectsForUser" od:mutable];
                
            }
        }else if ([sElementName isEqualToString:@"idproject"])
        {
            projectEntry = [[ProjectEntry alloc] init];
            projectEntry.nProjectID = [sValue intValue];
            if(projectEntry.nProjectID == -1)
                bErrorSessionID = TRUE; 
            
        }else if ([sElementName isEqualToString:@"project"])
        {
            projectEntry.sProjectName = [NSString stringWithFormat:@"%@", sValue];// sValue;
            [cfgMgr.aProjects addObject:projectEntry];
        }else if ([sElementName isEqualToString:@"idworkcode"])
        {
            workcodeEntry = [[WorkcodeEntry alloc] init];
            workcodeEntry.nWorkcodeID = [sValue intValue];
            if(workcodeEntry.nWorkcodeID == -1)
                bErrorSessionID = TRUE; 
        }else if ([sElementName isEqualToString:@"workcode"])
        {
            workcodeEntry.sWorkcode = [NSString stringWithFormat:@"%@", sValue];// sValue;
            [cfgMgr.aWorkcodes addObject:workcodeEntry];
        }else if ([sElementName isEqualToString:@"idclient"])
        {
            clientEntry = [[ClientEntry alloc] init];
            clientEntry.nClientID = [sValue intValue];
            if(clientEntry.nClientID == -1)
                bErrorSessionID = TRUE; 
        }else if ([sElementName isEqualToString:@"client"])
        {
            clientEntry.sClient = [NSString stringWithFormat:@"%@", sValue];// sValue;
            [cfgMgr.aClients addObject:clientEntry];
        }else if ([sElementName isEqualToString:@"sessionerror"])
        {
            //clientEntry.sClient = [NSString stringWithFormat:@"%@", sValue];// sValue;
            //[cfgMgr.aClients addObject:clientEntry];
            int n = 0;
            n = n;
        }
    }
}

- (void) abortLoginProcess{
    tbiMembership.enabled = YES;
    tbiConfig.enabled = YES;
    bbiLogin.enabled = YES;
    tbvLogin.userInteractionEnabled = true;
    [actMain stopAnimating];    
}


- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error{

    [self abortLoginProcess];
    [CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @"") message: [error description]];
}

- (void) gotSOAPAnswere:(NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data{
    NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
    xmlReader = [[XMLReader alloc] init];
    xmlReader.delegate = self;

    if(requester == srConfigWaypoints){
        xmlReaderWP = [[XMLReader alloc] init];
        xmlReaderWP.delegate = self;
        NSLog(@"%@", sXMLAnswere);
        cfgMgr.aWaypoints = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"idwaypoint"];
        [aElementsToFind addObject:@"lat"];
        [aElementsToFind addObject:@"lng"];
        [aElementsToFind addObject:@"radius"];
        [aElementsToFind addObject:@"waypoint"];
        [aElementsToFind addObject:@"idclient"];        
        [aElementsToFind addObject:@"idproject"];        
        [aElementsToFind addObject:@"idworkcode"];                
        
        [xmlReaderWP parseForElements:aElementsToFind data:srConfigWaypoints.webData];
        if (!bErrorSessionID) {
            TimeSheetViewController *myNewVC = [[TimeSheetViewController alloc] init];
             myNewVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
             myNewVC.cfgMgr = cfgMgr;
             myNewVC.la = la;
             [self presentModalViewController:myNewVC animated:YES];
        }else {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];
        }
        [self abortLoginProcess];        
    }else if(requester == srConfigClients){
        xmlReaderConfig = [[XMLReader alloc] init];
        xmlReaderConfig.delegate = self;
        cfgMgr.aClients = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"idclient"];
        [aElementsToFind addObject:@"client"];
        [aElementsToFind addObject:@"idproject"];
        [aElementsToFind addObject:@"project"];
        
        [xmlReaderConfig parseForElements:aElementsToFind data:srConfigClients.webData];
        //ClientEntry *clientEntry = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:1]);
        
        //ClientEntry *tmp = (ClientEntry*)[cfgMgr.aClients objectAtIndex:cfgMgr.aClients.count-1];
        //NSMutableArray *tmp2 = ((ClientEntry;
        //cfgMgr = cfgMgr;
        
        if (!bErrorSessionID) {
            OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
            
            ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
            //[mutable setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];            
            [mutable setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ];
            [mutable setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"iduser"];
            
            srConfigWaypoints = [[SOAPRequester alloc] init];
            srConfigWaypoints.delegate = self;
            [srConfigWaypoints sendSOAPRequest:cfgTmp message:@"GetWaypointsForUser" od:mutable];
            
        }else {
            //[CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @""): @"Error sessionid (login again)!"];
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];
            [self abortLoginProcess];
        }
    }else if(requester == srConfigWorkcodes){
        
        cfgMgr.aWorkcodes = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"idworkcode"];
        [aElementsToFind addObject:@"workcode"];
        [xmlReader parseForElements:aElementsToFind data:srConfigWorkcodes.webData];
        
        if (!bErrorSessionID) {
            OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
            
            ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
            //[mutable setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];            
            [mutable setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ];
            [mutable setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"iduser"];
            
            srConfigClients = [[SOAPRequester alloc] init];
            srConfigClients.delegate = self;
            [srConfigClients sendSOAPRequest:cfgTmp message:@"GetClientsForUser2" od:mutable];
        }else {
            //[CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @""): @"Error sessionid (login again)!"];
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];

            [self abortLoginProcess];
        }
    }else if(requester == srConfig){
        NSLog(@"%@", sXMLAnswere);  
        cfgMgr.aProjects = [[NSMutableArray alloc] init];
        
        [aElementsToFind addObject:@"idproject"];
        [aElementsToFind addObject:@"project"];

        [xmlReader parseForElements:aElementsToFind data:srConfig.webData];
        
        //if(!bErrorSessionID){
            OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
        
            ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
            [mutable setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ];
            //[mutable setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];            
            [mutable setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"iduser"];
        
            srConfigWorkcodes = [[SOAPRequester alloc] init];
            srConfigWorkcodes.delegate = self;
            [srConfigWorkcodes sendSOAPRequest:cfgTmp message:@"GetWorkcodesForUser" od:mutable];
        /*}else {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") :NSLocalizedString(@"msgSessionError", @"")];
            [self abortLoginProcess];
        }*/
    }else{
        [aElementsToFind addObject:@"iduser"];
        [aElementsToFind addObject:@"username"];
        [aElementsToFind addObject:@"idmandate"];
        [aElementsToFind addObject:@"result"];
        [aElementsToFind addObject:@"idsession"];
        
        [xmlReader parseForElements:aElementsToFind data:sr.webData];
    }
}


- (IBAction)login:(id)sender{
    [actMain startAnimating];
    tbiMembership.enabled = NO;
    tbiConfig.enabled = NO;
    bbiLogin.enabled = NO;
    tbvLogin.userInteractionEnabled = false;
    //[txtMandate resignFirstResponder];
    //[txtUsername resignFirstResponder];
    //[txtPassword resignFirstResponder];
    
    OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
    
    NSString *sSalt = [[NSString stringWithFormat:@"%@ %@", cfgMgr.sDefaultMandate, cfgMgr.sDefaultUser] lowercaseString];
    
    NSString *sPwd = [self hashString: /*@"123456" */cfgMgr.sDefaultPassword withSalt: sSalt /*@"Demo Mandate Demo User"*/];
    
    [mutable setObject: cfgMgr.sDefaultMandate forKey: @"mandate"];
    [mutable setObject: cfgMgr.sDefaultUser forKey: @"user" ];
    [mutable setObject: sPwd forKey: @"password" ];
    [mutable setObject: @"0.69" forKey: @"version" ];    
    
    
    ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
    
    cfgTmp.sDefaultMandate = cfgMgr.sDefaultMandate;
    cfgTmp.sDefaultUser = cfgMgr.sDefaultUser;
    cfgTmp.sDefaultPassword = cfgMgr.sDefaultPassword;
    
    sr = [[SOAPRequester alloc] init];
    sr.delegate = self;
    [sr sendSOAPRequest:cfgTmp message:@"Login2" od:mutable];
}

-(void)openConfig{
    if(configMainView == nil)
        configMainView = [[ConfigMainViewController alloc] init];
    
    configMainView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    configMainView.cfgMgr = cfgMgr;
    [configMainView setDelegate:self];
    [self presentModalViewController:configMainView animated:YES];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(tbiLast != nil)
        tabMain.selectedItem = tbiLast;
    else
        tabMain.selectedItem = tbiLogin;
    if(item == tbiConfig){
        [self openConfig];
        
    }else if (item == tbiMembership) {
        /*if(tbiLast != nil)
            tabMain.selectedItem = tbiLast;
        else
            tabMain.selectedItem = tbiLogin;
        */
        MembershipMainViewController *myNewVC = [[MembershipMainViewController alloc] init];
        myNewVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:myNewVC animated:YES];
        
    }
    if(item != tbiConfig & item != tbiMembership)
        tbiLast = item;
}

#pragma mark - Txt View functions
-(IBAction) cancelNewConfigText{
    txtNewConfigText.text = @"";
    [self doneNewConfigText];
}

-(void)doneNewConfigText{
    //bNewText = FALSE;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	viewTextNew.transform = transform;
	[UIView commitAnimations];	
	[txtNewConfigText resignFirstResponder];
    [self hideNewConfigText];
}

-(void)hideNewConfigText{
    //[textView resignFirstResponder];
}

- (IBAction)newConfigTextShow:(int)sender{
    //bNewText = YES;
    //nConfigID = sender;
    //[viewTextNew setFrame:CGRectMake(0, 120, viewTextNew.frame.size.width, viewTextNew.frame.size.height)];
    /*[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 360);
	viewTextNew.transform = transform;
	[self.view addSubview:viewTextNew];
	[UIView commitAnimations];	
	//[txtNewConfigText becomeFirstResponder];
    */
    nViewIdx = sender;
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 155);
	viewTextNew.transform = transform;
	[self.view addSubview:viewTextNew];
	[UIView commitAnimations];	
     [txtNewConfigText becomeFirstResponder]; 
    if(sender == 0){
        bbiTitleConfig.title = NSLocalizedString(@"lblMandate", @"");
        //txtNewConfigText.secureTextEntry = NO;
        [txtNewConfigText setSecureTextEntry:FALSE];
        txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterMandate", @""); 
        txtNewConfigText.text = cfgMgr.sDefaultMandate;

    }else if(sender == 1){
        bbiTitleConfig.title = NSLocalizedString(@"lblUser", @""); 
        //txtNewConfigText.secureTextEntry = NO;
        [txtNewConfigText setSecureTextEntry:FALSE];
        txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterUser", @""); 
        txtNewConfigText.text = cfgMgr.sDefaultUser;
        //txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterNewProject", @"");
    }else if(sender == 2){
        bbiTitleConfig.title = NSLocalizedString(@"lblPwd", @"");
        [txtNewConfigText resignFirstResponder];
        txtNewConfigText.enabled = NO;
        [txtNewConfigText setSecureTextEntry:TRUE];
        txtNewConfigText.text = cfgMgr.sDefaultPassword;
        txtNewConfigText.enabled = YES;

        //[txtNewConfigText becomeFirstResponder];
        txtNewConfigText.placeholder =  NSLocalizedString(@"lblEnterPassword", @"");
    }

    [txtNewConfigText becomeFirstResponder];
    //textField.secureTextEntry = YES;
    //textField.enabled = YES;

}

- (IBAction) saveNewConfigText:(id)sender{
	if([txtNewConfigText.text isEqualToString:@""]){
        NSString *sConfigType;
        if(nViewIdx == 0)
            sConfigType = NSLocalizedString(@"lblMandate", @""); 
        else if(nViewIdx == 1)
            sConfigType = NSLocalizedString(@"lblUser", @"");
        else //if(nID == 2)
            sConfigType = NSLocalizedString(@"lblPwd", @"");
        [CommonFunctions showMessageBox:NSLocalizedString(@"titMissingInput", @"") message:[NSString stringWithFormat: NSLocalizedString(@"msgPleaseEnterA", @""), sConfigType]];
	}else {
        if(nViewIdx == 0)
            cfgMgr.sDefaultMandate = txtNewConfigText.text; 
        else if(nViewIdx == 1)
            cfgMgr.sDefaultUser = txtNewConfigText.text; 
        else //if(nID == 2)
            cfgMgr.sDefaultPassword = txtNewConfigText.text; 
        //[cfgMgr saveData];
        [tbvLogin reloadData];
        [self doneNewConfigText];
	}
    
}



#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return (cfgMgr.bShowMoreInfo ? 4 : 2); // 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

//Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }/*else if(section == 1) {
        return 1;
    }*/else {
        return 1;
    }
}

//Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblMandate", @"")] : @""), cfgMgr.sDefaultMandate];// @"Mandate";
            cell.imageView.image = [UIImage imageNamed:@"certificate_2.gif"];
        }else if(indexPath.row == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblUser", @"")] : @""), cfgMgr.sDefaultUser];//NSLocalizedString(@"lblUser", @""); //@"User";
            cell.imageView.image = [UIImage imageNamed:@"user.png"];
        }else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblPwd", @"")] : @""), (![cfgMgr.sDefaultPassword isEqualToString:@""] ? @"•••••••••" : @"")];//NSLocalizedString(@"lblPwd", @"");//@"Password";
            cell.imageView.image = [UIImage imageNamed:@"password.png"];
        }
    }else if (indexPath.section == 2 && cfgMgr.bShowMoreInfo) {
        if(indexPath.row == 0){
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@", (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblWPHost", @"")] : @""), cfgMgr.sServerName];//NSLocalizedString(@"lblWPHost", @"");// @"Mandate";
            //cell.imageView.image = [UIImage imageNamed:@"server-network.png"];
        }
        //else if(indexPath.row == 1){
            //cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"lblWPservice", @""), cfgMgr.sServiceName];//NSLocalizedString(@"lblWPservice", @"");

            // add friend button
            //UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            //addFriendButton.frame = CGRectMake(200.0f, 5.0f, 75.0f, 30.0f);
            //[addFriendButton setTitle:@"Login" forState:UIControlStateNormal];   
            //[cell addSubview:addFriendButton];
            //[addFriendButton addTarget:self action:@selector(pushMyNewViewController:) forControlEvents:UIControlEventTouchUpInside];
       // }
    }else if (indexPath.section == 1 && cfgMgr.bShowMoreInfo) {
        /*cell.imageView.image = [UIImage imageNamed:@"Clock-icon.png"];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = NSLocalizedString(@"lblLogin", @"");
         */
        if(cfgMgr.bStayLoggedIn == YES)
            cell.textLabel.text = @"Stay logged in: Yes";//NSLocalizedString(@"lblLogin", @"");
        else
            cell.textLabel.text = @"Stay logged in: No";//NSLocalizedString(@"lblLogin", @"");
    }else if ((indexPath.section == 3 && cfgMgr.bShowMoreInfo) |
              (indexPath.section == 1 && !cfgMgr.bShowMoreInfo)){
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"LOGIN";//NSLocalizedString(@"lblLogin", @"");
    }/*else if (indexPath.section == 1 && !cfgMgr.bShowMoreInfo) {
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"LOGIN";//NSLocalizedString(@"lblLogin", @"");
    }*/
    
    return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!cfgMgr.bShowMoreInfo){
        if (indexPath.section == 0) {
            [self newConfigTextShow:indexPath.row];
        }else if (indexPath.section == 1) {
            [self login:NULL];
        }
    }else{
        if (indexPath.section == 0) {
            [self newConfigTextShow:indexPath.row];
        }else if (indexPath.section == 1) {
            cfgMgr.bStayLoggedIn = !cfgMgr.bStayLoggedIn;
            [tbvLogin reloadData];
        }else if (indexPath.section == 2) {
            [self openConfig];
        }else if (indexPath.section == 3) {
            [self login:NULL];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(!cfgMgr.bShowMoreInfo){
        if(indexPath.section == 0)
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        else {
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        }
    }else{
        if(indexPath.section == 0)
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        else if (indexPath.section == 1) {
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        }else if (indexPath.section == 2) {
            [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        }else {
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13.0]];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
    viewTextNew.transform = transform;
	[UIView commitAnimations];
    
    cfgMgr = [[ConfigMgr alloc] initWithName: @""];
    tabMain.selectedItem = tbiLogin;
    bErrorSessionID = FALSE;
    
    /*NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:tabMain.viewControllers];
    [viewControllers removeObjectAtIndex:indexToRemove];
    [tabMain setViewControllers:viewControllers];
    */
    
    if (cfgMgr.bStayLoggedIn /*| cfgMgr.bAutoLogin*/) {
        [self login:nil];
    }
    
    /*if(cfgMgr.bAutoLogin){
        [self login:nil];
    }*/
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
