//
//  ConfigDataViewController.m
//  Waypoint
//
//  Created by Kim David Hauser on 02.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import "ConfigDataViewController.h"
#import "DataConfigMoreCustomCell.h"
#import "ConfigMainViewController.h"
#import "ClientEntry.h"
#import "WorkcodeEntry.h"
#import "WaypointInfo.h"
#import "ProjectEntry.h"
#import "CommonFunctions.h"

@interface ConfigDataViewController ()

@end

@implementation ConfigDataViewController
@synthesize objMainView;
@synthesize cfgMgr;
@synthesize la;

- (void) foundXMLElement: (NSObject*)sourceXmlReader:(NSString*)sElementName:(NSMutableString*)sValue{
    if (sourceXmlReader == xmlReaderDelete) {
        if([sElementName isEqualToString:@"return"]){
            int nRet = sValue.intValue;
            if (nRet > 0) {
                //OK
                if(nViewIdx == 1){
                    for (int i = 0; i < cfgMgr.aClients.count; i++) {
                        ClientEntry *ce = [cfgMgr.aClients objectAtIndex:i];
                        if(ce.nClientID == nRet){
                            [cfgMgr.aClients removeObjectAtIndex:i];
                            break;
                        }
                    }
                    //if (idxDelete != nil) 
                        //[tbvDataConfig2 deleteRowsAtIndexPaths:[NSArray arrayWithObject: idxDelete] withRowAnimation:UITableViewRowAnimationFade];
                    [tbvDataConfig2 reloadData];
                }else if (nViewIdx == 2) {
                    for (int i = 0; i < cfgMgr.aWorkcodes.count; i++) {
                        WorkcodeEntry *ce = [cfgMgr.aWorkcodes objectAtIndex:i];
                        if(ce.nWorkcodeID == nRet){
                            [cfgMgr.aWorkcodes removeObjectAtIndex:i];
                            break;
                        }
                    }
                    //if (idxDelete != nil) 
                        //[tbvDataConfig2 deleteRowsAtIndexPaths:[NSArray arrayWithObject: idxDelete] withRowAnimation:UITableViewRowAnimationFade];
                    [tbvDataConfig2 reloadData];
                }else {
                    for (int i = 0; i < clientEntry.aProjects.count; i++) {
                        ProjectEntry *ce = [clientEntry.aProjects objectAtIndex:i];
                        if(ce.nProjectID == nRet){
                            [clientEntry.aProjects removeObjectAtIndex:i];
                            break;
                        }
                    }
                    //if (idxDelete != nil) 
                        //[tbvDataConfig3 deleteRowsAtIndexPaths:[NSArray arrayWithObject: idxDelete] withRowAnimation:UITableViewRowAnimationFade];
                    [tbvDataConfig3 reloadData];                    
                }
            }else if (nRet == -1) {
                bErrorSessionId = TRUE;
            }else if (nRet == -2) {
                [CommonFunctions showMessageBox:NSLocalizedString(@"titDeleteError", @"") :NSLocalizedString(@"msgDeleteError", @"")];
            }
        }
    }else if (sourceXmlReader == xmlReader) {
        if([sElementName isEqualToString:@"return"]){
            int nRet = sValue.intValue;
            if (nRet <= 0) {
                bErrorSessionId = TRUE;
            }else {
                BOOL bFound = NO;
                if(nViewIdx == 1){
                    for (int i = 0; i < cfgMgr.aClients.count; i++) {
                        ClientEntry *ce = [cfgMgr.aClients objectAtIndex:i];
                        if(ce.nClientID == nRet){
                            bFound = YES;
                            break;
                        }
                    }
                    if(!bFound){
                        ClientEntry *clientEntryTmp = [[ClientEntry alloc] init];
                        clientEntryTmp.nClientID = nRet;
                        clientEntryTmp.sClient = [txtNewConfigText.text copy];
                        [cfgMgr.aClients addObject:clientEntryTmp];
                    }
                    //[tbvDataConfig2 insertRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation://<#(UITableViewRowAnimation)#>]
                    [tbvDataConfig2 reloadData];
                }else if (nViewIdx == 2) {
                    for (int i = 0; i < cfgMgr.aWorkcodes.count; i++) {
                        WorkcodeEntry *ce = [cfgMgr.aWorkcodes objectAtIndex:i];
                        if(ce.nWorkcodeID == nRet){
                            bFound = YES;
                            break;
                        }
                    }
                    if(!bFound){
                        WorkcodeEntry *clientEntryTmp = [[WorkcodeEntry alloc] init];
                        clientEntryTmp.nWorkcodeID = nRet;
                        clientEntryTmp.sWorkcode = [txtNewConfigText.text copy];
                        [cfgMgr.aWorkcodes addObject:clientEntryTmp];
                    }
                    [tbvDataConfig2 reloadData];
                }else {
                    for (int i = 0; i < clientEntry.aProjects.count; i++) {
                        ProjectEntry *ce = [clientEntry.aProjects objectAtIndex:i];
                        if(ce.nProjectID == nRet){
                            bFound = YES;
                            break;
                        }
                    }
                    if(!bFound){
                        ProjectEntry *clientEntryTmp = [[ProjectEntry alloc] init];
                        clientEntryTmp.nProjectID = nRet;
                        clientEntryTmp.sProjectName = [txtNewConfigText.text copy];
                        [clientEntry.aProjects addObject:clientEntryTmp];
                    }
                    [tbvDataConfig3 reloadData];                    
                }
            }
        }
    }
}

- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error{
    
    [actMain stopAnimating];
    [CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @"") :[error description]];
    
}

- (void) gotSOAPAnswere:(NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data{   
    
    //[actMain stopAnimating];
    if (requester == srConfigText) {
        NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"return"];
        
        xmlReader = [[XMLReader alloc] init];
        xmlReader.delegate = self;
        [xmlReader parseForElements:aElementsToFind:srConfigText.webData];
        
        if (bErrorSessionId) {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") :NSLocalizedString(@"msgSessionError", @"")];
        }
        [actMain stopAnimating];
        return;
    }else if (requester == srDeleteConfigText) {
        /*UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"SOAP Response"
                              message:sXMLAnswere 
                              delegate:self  
                              cancelButtonTitle:@"OK" 
                              otherButtonTitles:nil];
        [alert show];*/
        NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"return"];
        xmlReaderDelete = [[XMLReader alloc] init];
        xmlReaderDelete.delegate = self;
        [xmlReaderDelete parseForElements:aElementsToFind:srDeleteConfigText.webData];
        if (bErrorSessionId) {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") :NSLocalizedString(@"msgSessionError", @"")];
        }else {
            //[delegate closeQuickView:0];
        }
        [actMain stopAnimating];
    }
    /*
    if(requester == sr){
        NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"return"];
        xmlReader = [[XMLReader alloc] init];
        xmlReader.delegate = self;
        [xmlReader parseForElements:aElementsToFind:sr.webData];
        if (bErrorSessionId) {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") :NSLocalizedString(@"msgSessionError", @"")];
        }else {
            [delegate closeQuickView:0];
        }
        return;
    }*/
}

- (void)showDisabledBackground:(UIView*)superView{
    dimBackgroundView = [[UIView alloc] initWithFrame:superView.bounds];
    dimBackgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.5f];
    
    [superView addSubview:dimBackgroundView];
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
    [dimBackgroundView removeFromSuperview];
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
    [self showDisabledBackground:self.view];
	[self.view addSubview:viewTextNew];
	[UIView commitAnimations];	
    [txtNewConfigText becomeFirstResponder]; 
    if(sender == 1){
        bbiTitleConfig.title = [NSString stringWithFormat:@"Add a %@", NSLocalizedString(@"lblClient", @"")]; //NSLocalizedString(@"lblClient", @"");
        //txtNewConfigText.secureTextEntry = NO;
        [txtNewConfigText setSecureTextEntry:FALSE];
        txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterNewClient", @""); 
        //txtNewConfigText.text = cfgMgr.sDefaultMandate;
        
    }else if(sender == 2){
        bbiTitleConfig.title = [NSString stringWithFormat:@"Add a %@", NSLocalizedString(@"lblWorkcode", @"")]; //NSLocalizedString(@"lblWorkcode", @""); 
        //txtNewConfigText.secureTextEntry = NO;
        [txtNewConfigText setSecureTextEntry:FALSE];
        txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterNewWorkcode", @""); 
        //txtNewConfigText.text = cfgMgr.sDefaultUser;
        //txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterNewProject", @"");
    }else if(sender == 3){
        bbiTitleConfig.title = [NSString stringWithFormat:@"Add a %@", NSLocalizedString(@"lblProject", @"")]; //NSLocalizedString(@"lblProject", @"");
        [txtNewConfigText resignFirstResponder];
        //txtNewConfigText.enabled = NO;
        [txtNewConfigText setSecureTextEntry:FALSE];
        //txtNewConfigText.text = cfgMgr.sDefaultPassword;
        //txtNewConfigText.enabled = YES;
        
        //[txtNewConfigText becomeFirstResponder];
        txtNewConfigText.placeholder =  NSLocalizedString(@"lblEnterNewProject", @"");
    }
    
    [txtNewConfigText becomeFirstResponder];
    //textField.secureTextEntry = YES;
    //textField.enabled = YES;
    
}

- (IBAction) saveNewConfigText:(id)sender{
	if([txtNewConfigText.text isEqualToString:@""]){
        NSString *sConfigType;
        if(nViewIdx == 1)
            sConfigType = NSLocalizedString(@"lblClient", @""); 
        else if(nViewIdx == 2)
            sConfigType = NSLocalizedString(@"lblWorkcode", @"");
        else //if(nID == 2)
            sConfigType = NSLocalizedString(@"lblProject", @"");
        [CommonFunctions showMessageBox:NSLocalizedString(@"titMissingInput", @"") :[NSString stringWithFormat: NSLocalizedString(@"msgPleaseEnterA", @""), sConfigType]];
	}else {
        [actMain startAnimating];
        OrderedDictionary *od = [[OrderedDictionary alloc] init];
        [od setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ]; 
        //[od setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];
        [od setObject: [NSString stringWithFormat:@"%d", clientEntry.nClientID] forKey: @"idparent" ]; 
        int nConfigID = -1;
        if(nViewIdx == 1)
            nConfigID = 0; 
        else if(nViewIdx == 3)
            nConfigID = 1;
        else //if(nID == 2)
            nConfigID = 2;
        
        [od setObject: [NSString stringWithFormat:@"%d", nConfigID] forKey: @"idconfig" ];
        [od setObject: [NSString stringWithFormat:@"%d", -1] forKey: @"idtext" ];
        [od setObject: txtNewConfigText.text forKey: @"text" ];
        ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
        
        srConfigText = [[SOAPRequester alloc] init];
        srConfigText.delegate = self;
        [srConfigText sendSOAPRequest:cfgTmp:@"UpdateConfigText":od];
        /*if(nViewIdx == 0)
            cfgMgr.sDefaultMandate = txtNewConfigText.text; 
        else if(nViewIdx == 1)
            cfgMgr.sDefaultUser = txtNewConfigText.text; 
        else //if(nID == 2)
            cfgMgr.sDefaultPassword = txtNewConfigText.text; */
        
        //[cfgMgr saveData];
        //[tbvLogin reloadData];
        [self doneNewConfigText];
	}
    
}



-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item == tbiConfigMain){
        tabMain.selectedItem = tbiConfigData;
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:NO];
    [((ConfigMainViewController *)objMainView) cancel:nil];
    
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ((tableView ==  tbvDataConfig2 | tableView == tbvDataConfig3) && nTbvMode != 3) {
        return 2;
    }else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

//Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (tableView == tbvDataConfig2) {
            if (nTbvMode > 0) {
                if (nTbvMode ==  1) {
                    return  cfgMgr.aClients.count;
                }else if (nTbvMode == 2) {
                    return cfgMgr.aWorkcodes.count;
                }else if (nTbvMode == 3) {
                    return cfgMgr.aWaypoints.count;
                }
            }else 
                return 1;
        }else if(tableView == tbvDataConfig) {
            return 3;
        }else if (tableView == tbvDataConfig3) {
            //return cfgMgr.aProjects.count;
            if (clientEntry != nil) {
                return clientEntry.aProjects.count;
            }else {
                return 0;
            }
        }
        return 3;
    }else {
        return 1;
    }
}

//Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"DataConfigMoreCustomCell";
    DataConfigMoreCustomCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell2 == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DataConfigMoreCustomCell" owner:nil options:nil];
        for(id currentObject in topLevelObjects){
            if([currentObject isKindOfClass:[DataConfigMoreCustomCell class]]){
                cell2 = (DataConfigMoreCustomCell *)currentObject;
                break;
            }
        }
    }
    if (indexPath.section == 0) {
        if (tableView == tbvDataConfig) {
            if(indexPath.row == 0){
                [cell2 lblTime].text = [NSString stringWithFormat:@"%@s", NSLocalizedString(@"lblClient", @"")];
                [cell2 imgView].image = [UIImage imageNamed:@"user_business.png"];        
                [cell2 cmdEdit].hidden = YES;
            }else if(indexPath.row == 1){
                [cell2 lblTime].text = [NSString stringWithFormat:@"%@s", NSLocalizedString(@"lblWorkcode", @"")];
                [cell2 imgView].image = [UIImage imageNamed:@"workcode.gif"];
                [cell2 cmdEdit].hidden = YES;
            }else if(indexPath.row == 2){
                [cell2 lblTime].text =[NSString stringWithFormat:@"%@s", NSLocalizedString(@"lblWaypoint", @"")];
                [cell2 imgView].image = [UIImage imageNamed:@"flag_blank.png"];
                [cell2 cmdEdit].hidden = YES;
            }
        }else if (tableView == tbvDataConfig2) {
            if (nTbvMode == 0) {
                if(indexPath.row == 0){
                    [cell2 lblTime].text = @"Projects";
                    [cell2 imgView].image = [UIImage imageNamed:@"folder.png"];   
                    [cell2 cmdEdit].hidden = YES;
                }
            }else {
                if (nTbvMode ==  1) {
                    for (int i = 0; i < cfgMgr.aClients.count; i++) {
                        if( i == indexPath.row){
                            [cell2 lblTime].text = ((ClientEntry*) [cfgMgr.aClients objectAtIndex:i]).sClient;   
                            [cell2 imgView].image = [UIImage imageNamed:@"user_business.png"];
                            [cell2 cmdEdit].hidden = NO;
                            [cell2 setDelegate:self];
                            /*UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoDark];
                            [button setBackgroundColor:[UIColor redColor]];
                            button.titleLabel.text = @"Delete";
                            [cell2.contentView addSubview:button];*/
                            break;
                        }
                    }            
                }else if (nTbvMode == 2) {
                    for (int i = 0; i < cfgMgr.aWorkcodes.count; i++) {
                        if( i == indexPath.row){
                            [cell2 lblTime].text = ((WorkcodeEntry*) [cfgMgr.aWorkcodes objectAtIndex:i]).sWorkcode;    
                            [cell2 imgView].image = [UIImage imageNamed:@"workcode.gif"];                        
                            [cell2 cmdEdit].hidden = YES;
                            break;
                        }
                    }
                }else if (nTbvMode == 3) {
                    for (int i = 0; i < cfgMgr.aWaypoints.count; i++) {
                        if( i == indexPath.row){
                            [cell2 lblTime].text = ((WaypointInfo *) [cfgMgr.aWaypoints objectAtIndex:i]).sName;    
                            [cell2 imgView].image = [UIImage imageNamed:@"flag_blank.png"];                        
                            [cell2 cmdEdit].hidden = YES;
                            break;
                        }
                    }
                }
            }
        }else if (tableView == tbvDataConfig3) {
            if (clientEntry != nil) {
                for (int i = 0; i < clientEntry.aProjects.count; i++) {
                    if( i == indexPath.row){
                        [cell2 lblTime].text = ((ProjectEntry *) [clientEntry.aProjects objectAtIndex:i]).sProjectName;    
                        [cell2 imgView].image = [UIImage imageNamed:@"folder.png"];                        
                        [cell2 cmdEdit].hidden = YES;
                        break;
                    }
                }

            }else {
                for (int i = 0; i < clientEntry.aProjects.count; i++) {
                    if( i == indexPath.row){
                        [cell2 lblTime].text = ((ProjectEntry *) [clientEntry.aProjects objectAtIndex:i]).sProjectName;    
                        [cell2 imgView].image = [UIImage imageNamed:@"folder.png"];                        
                        [cell2 cmdEdit].hidden = YES;
                        break;
                    }
                }

            }
        }
        cell2.nID = indexPath.row;        
    }else {
        NSString *sWhat = @"";
        if (tableView == tbvDataConfig3) {
                sWhat = NSLocalizedString(@"lblProject", @"");
        }else {
            if (nTbvMode == 1) {
                sWhat = NSLocalizedString(@"lblClient", @"");
            }else if (nTbvMode == 2) {
                sWhat = NSLocalizedString(@"lblWorkcode", @"");
            }
        }

        cell2.lblTime.text = [NSString stringWithFormat:@"Add a %@", sWhat];
        cell2.lblTime.textAlignment = UITextAlignmentCenter;
        [cell2.lblTime setFont:[UIFont boldSystemFontOfSize:13]];
        cell2.imgView.image = nil;                        
        cell2.cmdEdit.hidden = YES;
    }
    

    //cell2.configDataView = self;
	return cell2;	
	
}

- (void)dataConfigMoreCustomCellDelegateDoButton:(int)nID{
    //nTbvMode = 3;
    clientEntry = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:nID]);
    nViewIdx = 3;
    [self swipe2:nID];
    UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
    //[backButton addTarget:self action:@selector(swipeBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(swipeBack2) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:[NSString stringWithFormat:@"%@s", NSLocalizedString(@"lblClient", @"")] forState:UIControlStateNormal];
    
    // create button item -- possible because UIButton subclasses UIView!
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    // add to toolbar, or to a navbar (you should only have one of these!)
    //[toolbar setItems:[NSArray arrayWithObject:backItem]];
    bbiCancel2 = nviMain.leftBarButtonItem;
    nviMain.leftBarButtonItem = backItem;
    [nviMain setTitle:[NSString stringWithFormat:@"%@s", NSLocalizedString(@"lblProject", @"")]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (tableView == tbvDataConfig) {
            if(indexPath.row <= 2){
                nTbvMode = indexPath.row + 1;
                [self swipe:indexPath.row];
                
                UIButton* backButton = [UIButton buttonWithType:101]; // left-pointing shape!
                //[backButton addTarget:self action:@selector(swipeBack) forControlEvents:UIControlEventTouchUpInside];
                [backButton addTarget:self action:@selector(swipeBack) forControlEvents:UIControlEventTouchUpInside];
                [backButton setTitle:NSLocalizedString(@"lblData", @"") forState:UIControlStateNormal];
                
                // create button item -- possible because UIButton subclasses UIView!
                UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                
                // add to toolbar, or to a navbar (you should only have one of these!)
                //[toolbar setItems:[NSArray arrayWithObject:backItem]];
                bbiCancel = nviMain.leftBarButtonItem;
                nviMain.leftBarButtonItem = backItem;
                if(nTbvMode == 1){
                    //nviMain.title = @"Clients";
                    [nviMain setTitle:[NSString stringWithFormat:@"%@s", NSLocalizedString(@"lblClient", @"")]];
                }else if (nTbvMode == 2){
                    //nviMain.title = @"Workcodes";
                    [nviMain setTitle:[NSString stringWithFormat:@"%@s", NSLocalizedString(@"lblWorkcode", @"")]];
                    //[nviMain setTitle:NSLocalizedString(@"lblWorkcodes", @"")];
                }else if (nTbvMode == 3){
                    //nviMain.title = @"Waypoints";
                    [nviMain setTitle:[NSString stringWithFormat:@"%@s", NSLocalizedString(@"lblWaypoint", @"")]];                
                    //[nviMain setTitle:NSLocalizedString(@"lblWaypoints", @"")];
                }
            }
        }
    }else {
        if (tableView == tbvDataConfig3) {
            [self newConfigTextShow:3];
        }else
            [self newConfigTextShow:nTbvMode];
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

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
// Return YES if you want the specified item to be editable.
    if (indexPath.section == 0) {
        if (tableView == tbvDataConfig) {
            return NO;
        }else {
            return YES;
        }
    }else {
        return NO;
    }
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [actMain startAnimating];
        idxDelete = [indexPath copy];
        OrderedDictionary *od = [[OrderedDictionary alloc] init];
        [od setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ]; 
        //[od setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];
        //[od setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"idparent" ]; 
        int nTextID;
        int nConfigID = -1;
        if (tableView == tbvDataConfig3) {
            nConfigID = 1;
            for (int i = 0; i < clientEntry.aProjects.count; i++) {
                if (i == indexPath.row) {
                    nTextID = ((ProjectEntry*)[clientEntry.aProjects objectAtIndex:i]).nProjectID;
                }
            }
        }else {
            if (nTbvMode == 1) {
                nConfigID = 0;
                for (int i = 0; i < cfgMgr.aClients.count; i++) {
                    if (i == indexPath.row) {
                        nTextID = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:i]).nClientID;
                    }
                }
            }else {
                nConfigID = 2;
                for (int i = 0; i < cfgMgr.aWorkcodes.count; i++) {
                    if (i == indexPath.row) {
                        nTextID = ((WorkcodeEntry*)[cfgMgr.aWorkcodes objectAtIndex:i]).nWorkcodeID;
                    }
                }
            }
        }

        [od setObject: [NSString stringWithFormat:@"%d", nConfigID] forKey: @"idconfig" ];
        [od setObject: [NSString stringWithFormat:@"%d", nTextID] forKey: @"idtext" ];
        //[od setObject: txtNewConfigText.text forKey: @"text" ];
        ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
        
        srDeleteConfigText = [[SOAPRequester alloc] init];
        srDeleteConfigText.delegate = self;
        [srDeleteConfigText sendSOAPRequest:cfgTmp:@"DeleteConfigText":od];
    }    
}

- (IBAction)swipe2:(int)sender{
    CGRect napkinTopFrame2 = tbvDataConfig2.frame;
    CGRect napkinTopFrame = tbvDataConfig2.frame;
    napkinTopFrame.origin.x = -napkinTopFrame.size.width;
    
    [UIView animateWithDuration:0.7
                          delay:0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         tbvDataConfig2.frame = napkinTopFrame;
                         tbvDataConfig3.frame = napkinTopFrame2;
                     } 
                     completion:^(BOOL finished){
                         //NSLog(@"Done!");
                     }];
    [tbvDataConfig3 reloadData];
}

- (IBAction)swipe:(int)sender{
    CGRect napkinTopFrame2 = tbvDataConfig.frame;
    CGRect napkinTopFrame = tbvDataConfig.frame;
    napkinTopFrame.origin.x = -napkinTopFrame.size.width;
    
    [UIView animateWithDuration:0.7
                          delay:0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         tbvDataConfig.frame = napkinTopFrame;
                         tbvDataConfig2.frame = napkinTopFrame2;
                     } 
                     completion:^(BOOL finished){
                         //NSLog(@"Done!");
                     }];
    //nviMain.rightBarButtonItem = editBa
    [tbvDataConfig2 reloadData];
}

- (IBAction)swipeBack{
    CGRect napkinTopFrame2 = tbvDataConfig2.frame;
    CGRect napkinTopFrame = tbvDataConfig2.frame;
    napkinTopFrame.origin.x = +napkinTopFrame.size.width;
    
    [UIView animateWithDuration:0.7
                          delay:0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         tbvDataConfig2.frame = napkinTopFrame;
                         tbvDataConfig.frame = napkinTopFrame2;
                     }
                     completion:^(BOOL finished){
                         //NSLog(@"Done!");
                     }];
    [self cancelNewConfigText];
    nviMain.leftBarButtonItem = bbiCancel;
    [nviMain setTitle:NSLocalizedString(@"lblConfigData", @"")];
}

- (IBAction)swipeBack2{
    CGRect napkinTopFrame2 = tbvDataConfig3.frame;
    CGRect napkinTopFrame = tbvDataConfig3.frame;
    napkinTopFrame.origin.x = +napkinTopFrame.size.width;
    
    [UIView animateWithDuration:0.7
                          delay:0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         tbvDataConfig3.frame = napkinTopFrame;
                         tbvDataConfig2.frame = napkinTopFrame2;
                     }
                     completion:^(BOOL finished){
                         //NSLog(@"Done!");
                     }];
    
    //nTbvMode = 0;
    [self cancelNewConfigText];
    nviMain.leftBarButtonItem = bbiCancel2;
    [nviMain setTitle:[NSString stringWithFormat:@"%@s", NSLocalizedString(@"lblClient", @"")]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)enterEditMode:(id)sender{
    if ([bbi2.title isEqualToString:@"Edit"]) {
        [tbvDataConfig2 setEditing: YES animated: YES];
        [tbvDataConfig3 setEditing: YES animated: YES];
        bbi2.title = @"Abort";
    }else {
        [tbvDataConfig2 setEditing: NO animated: YES];
        [tbvDataConfig3 setEditing: NO animated: YES];
        bbi2.title = @"Edit";
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
    
    tabMain.selectedItem = tbiConfigData;
    centerFrame = tbvDataConfig.frame;
    rightFrame = CGRectMake(centerFrame.origin.x+centerFrame.size.width, centerFrame.origin.y, centerFrame.size.width, centerFrame.size.height);
    
    tbvDataConfig2.frame = rightFrame;
    tbvDataConfig3.frame = rightFrame;
    //bbi2.enabled = NO;
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
