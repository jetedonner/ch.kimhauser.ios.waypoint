//
//  TimeSheetViewController.m
//  Waypoint
//
//  Created by Kim David Hauser on 02.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import "TimeSheetViewController.h"
#import "QuickViewController.h"
#import "ReportMainViewController.h"
#import "DateHelper.h"
#import "TimeSheetCustomCell.h"
#import "CommonFunctions.h"
#import "EditTimeSheetViewController.h"

@interface TimeSheetViewController ()

@end

@implementation TimeSheetViewController

@synthesize cfgMgr;
@synthesize la;
//@synthesize la;

- (void)showTimeSheetForDay:(NSString*)sDate{
    cmbSelectDate.titleLabel.text = sDate;
    [self reloadTimesheet:nil];
}
- (void)closeEditTimeSheetView:(BOOL)bReload{
    editTimeSheetView = nil;
    DateHelper *dh = [[DateHelper alloc] init];
    if (bReload) {
        [self reloadTimesheet:[dh stringFromDate:dSelectedDate :@"dd.MM.yyyy"]];
    }

}

- (void)closeConfigMainView{
    [configMainView dismissModalViewControllerAnimated:YES];
    configMainView = nil;
    [tbvTimeSheet reloadData];
    [tbvTimeSheetLeft reloadData];
    [tbvTimeSheetRight reloadData];
}

- (void)timeSheetCustomCellDelegateDoButton:(TimeSheetEntry*)tse{
    if (editTimeSheetView == nil) {
        editTimeSheetView  = [[EditTimeSheetViewController alloc] init];
    }
    editTimeSheetView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    editTimeSheetView.cfgMgr = cfgMgr;
    editTimeSheetView.la = la;
    editTimeSheetView.tse = tse;
    [editTimeSheetView setDelegate:self];
    [self presentModalViewController:editTimeSheetView animated:YES];
}

-(IBAction)newTimeSheetEntry:(id)sender{
    if (editTimeSheetView == nil) {
        editTimeSheetView  = [[EditTimeSheetViewController alloc] init];
    }
    //EditTimeSheetViewController *myNewVC = [[EditTimeSheetViewController alloc] init];
    editTimeSheetView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    editTimeSheetView.cfgMgr = cfgMgr;
    editTimeSheetView.la = la;
    editTimeSheetView.dSelectedDate = dSelectedDate;
    [editTimeSheetView setDelegate:self];
    [self presentModalViewController:editTimeSheetView animated:YES];
}

#pragma mark - Gesture recognizer delegates & funtions

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return TRUE;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return TRUE;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return TRUE;
}


- (IBAction) swipe:(id)sender{
    if (sender == swipRec) {
        CGRect napkinTopFrame2 = tbvTimeSheet.frame;
        CGRect napkinTopFrame = tbvTimeSheet.frame;
        napkinTopFrame.origin.x = +napkinTopFrame.size.width;
        
        [UIView animateWithDuration:0.7
                              delay:0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             tbvTimeSheet.frame = napkinTopFrame;
                             tbvTimeSheetLeft.frame = napkinTopFrame2;
                         } 
                         completion:^(BOOL finished){
                             //NSLog(@"Done!");
                         }];
        
        tbvTimeSheetRight.frame = leftFrame;
        UITableView *tempSVC = tbvTimeSheet;
        tbvTimeSheet = tbvTimeSheetLeft;
        tbvTimeSheetLeft = tbvTimeSheetRight;
        tbvTimeSheetRight = tempSVC;
        
        NSMutableArray *tempArr = arrTSECenter;
        arrTSECenter = arrTSELeft;
        arrTSELeft = arrTSERight;
        arrTSERight = tempArr;        
        
        UILabel *tempLbl = lblUser;
        lblUser = lblUserLeft;
        lblUserLeft = lblUserRight;
        lblUserRight = tempLbl;
        
        tempLbl = lblDayTotal;
        lblDayTotal = lblDayTotalLeft;
        lblDayTotalLeft = lblDayTotalRight;
        lblDayTotalRight = tempLbl;
        
        DateHelper * dh = [[DateHelper alloc] init];
        NSDate *dFrom = dSelectedDate;        
        cmbSelectDate.titleLabel.text = [dh shortStringFromDate:[dh dateAddDay:dFrom:-1]];
        [cmbSelectDate setTitle:[dh shortStringFromDate:[dh dateAddDay:dFrom:-1]] forState:UIControlStateNormal];
        [cmbSelectDate setTitle:[dh shortStringFromDate:[dh dateAddDay:dFrom:-1]] forState:UIControlStateSelected];
        [cmbSelectDate setTitle:[dh shortStringFromDate:[dh dateAddDay:dFrom:-1]] forState:UIControlStateHighlighted];
        dSelectedDate = dFrom;
        //lblUserLeft.text = [NSString stringWithFormat:@"   %@", [dh shortStringFromDate:[dh dateAddDay:dFrom:-2]]];
        lblUserLeft.text = [dh longStringFromDate:[dh dateAddDay:dFrom:-2]];
        [self reloadTimesheet:[[dh shortStringFromDate:[dh dateAddDay:dFrom:-2]] copy]];
        //[dh release];
        
    }else{
        CGRect napkinTopFrame2 = tbvTimeSheet.frame;
        CGRect napkinTopFrame = tbvTimeSheet.frame;
        napkinTopFrame.origin.x = -napkinTopFrame.size.width;
        
        [UIView animateWithDuration:0.7
                              delay:0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             tbvTimeSheet.frame = napkinTopFrame;
                             tbvTimeSheetRight.frame = napkinTopFrame2;
                         } 
                         completion:^(BOOL finished){
                             //NSLog(@"Done!");
                         }];
        
        tbvTimeSheetLeft.frame = rightFrame;
        UITableView *tempSVC = tbvTimeSheet;
        tbvTimeSheet = tbvTimeSheetRight;
        tbvTimeSheetRight = tbvTimeSheetLeft;
        tbvTimeSheetLeft = tempSVC;
        
        NSMutableArray *tempArr = arrTSECenter;
        arrTSECenter = arrTSERight;
        arrTSERight = arrTSELeft;
        arrTSELeft = tempArr;        
        
        UILabel *tempLbl = lblUser;
        lblUser = lblUserRight;
        lblUserRight = lblUserLeft;
        lblUserLeft = tempLbl;
        
        tempLbl = lblDayTotal;
        lblDayTotal = lblDayTotalRight;
        lblDayTotalRight = lblDayTotalLeft;
        lblDayTotalLeft = tempLbl;
        
        DateHelper * dh = [[DateHelper alloc] init];
        NSDate *dFrom = [dh dateFromShortString:cmbSelectDate.titleLabel.text];
        cmbSelectDate.titleLabel.text = [dh shortStringFromDate:[dh dateAddDay:dFrom:1]];
        [cmbSelectDate setTitle:[dh shortStringFromDate:[dh dateAddDay:dFrom:1]] forState:UIControlStateNormal];
        [cmbSelectDate setTitle:[dh shortStringFromDate:[dh dateAddDay:dFrom:1]] forState:UIControlStateSelected];
        [cmbSelectDate setTitle:[dh shortStringFromDate:[dh dateAddDay:dFrom:1]] forState:UIControlStateHighlighted];
        
        dSelectedDate = [dh dateAddDay:dSelectedDate:2];
        lblUserRight.text = [dh longStringFromDate:dSelectedDate];
        
        
        
        //[self reloadTimesheet];   
        [self reloadTimesheet:[[dh shortStringFromDate:dSelectedDate] copy]];
        //[dh release];
    }
}

-(IBAction)pickerShow{
	NSDateFormatter * df = [[NSDateFormatter alloc] init];
	//[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	[df setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
	[df setTimeZone:[NSTimeZone systemTimeZone]];
	[df setFormatterBehavior:NSDateFormatterBehaviorDefault];
	
	NSString *sTmp = [NSString stringWithFormat:@"%@ 00:00:00", cmbSelectDate.titleLabel.text];
	//NSDate *theDate = [df dateFromString:@"2011-04-12 10:00:00"];
	datePicker.date = [df dateFromString:sTmp];
	
	//[df release];
	
	//[txtDescription resignFirstResponder];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 240);
	pickerView.transform = transform;
	[self.view addSubview:pickerView];
	[UIView commitAnimations];	
}	

-(IBAction)done{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerView.transform = transform;
	[UIView commitAnimations];	
	[self reloadTimesheet:nil];
}

-(IBAction)dateChanged{
	//Use NSDateFormatter to write out the date in a friendly format
    
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
	[df setDateFormat:@"dd.MM.yyyy"];
	//df.dateStyle = NSDateFormatterMediumStyle;
	NSString *sTmp = [NSString stringWithFormat:@"%@", [df stringFromDate:datePicker.date]];
	
	[cmbSelectDate setTitle:[NSString stringWithFormat:@"%@", sTmp] forState:UIControlStateNormal];
	[cmbSelectDate setTitle:[NSString stringWithFormat:@"%@", sTmp] forState:UIControlStateSelected];	
	[cmbSelectDate setTitle:[NSString stringWithFormat:@"%@", sTmp] forState:UIControlStateHighlighted];
	//[self calcTimeDiff];
    DateHelper * dh = [[DateHelper alloc] init];
    dSelectedDate = [dh dateAddDay:datePicker.date:1];
	//[df release];
    //[dh release];
	
}


#pragma mark - Reload functions

- (void) reloadTimesheet2:(NSString *)sDate{
    [cmbSelectDate setTitle:sDate forState:UIControlStateNormal]; 
    [cmbSelectDate setTitle:sDate forState:UIControlStateSelected];	
    [cmbSelectDate setTitle:sDate forState:UIControlStateHighlighted];
    [self reloadTimesheet:nil];
}

- (void) reloadTimesheet:(NSString *)sDate{
	[actMain startAnimating]; 
    
    OrderedDictionary *od = [[OrderedDictionary alloc] init];
    //StartViewController *daSView = (StartViewController*)startViewController;

    //[od setObject: [NSString stringWithFormat:@"%@",@""]  forKey: @"idsession" ];
    [od setObject: [NSString stringWithFormat:@"%@",la.sSessionID]  forKey: @"idsession" ];
    [od setObject: [NSString stringWithFormat:@"%d",la.nUserID]  forKey: @"iduser" ];
    
    DateHelper * dh = [[DateHelper alloc] init];
    NSDate *dFrom = [dh dateFromShortString:cmbSelectDate.titleLabel.text];
    
    sWorkDateLeft = [[dh shortStringFromDateSql:[dh dateAddDay:dFrom:-1]] copy];
    sWorkDate = [[dh shortStringFromDateSql:dFrom] copy];
    sWorkDateRight = [[dh shortStringFromDateSql:[dh dateAddDay:dFrom:1]] copy];
    sWorkDateGroup = @"";
    
    dSelectedDate = [dFrom copy];
    
    if(sDate == nil){
        sWorkDateToRequest = @"";
        [od setObject: [dh shortStringFromDateSql:[dh dateAddDay:dFrom:-1]] forKey: @"date"];
        [od setObject: [dh shortStringFromDateSql:[dh dateAddDay:dFrom:1]] forKey: @"date2"];
    }else{
        sWorkDateToRequest = sDate;
        NSDate * dTmp = [dh dateFromStrings:sDate:@"dd.MM.yyyy"];
        sDate = [dh shortStringFromDateSql:dTmp];
        sWorkDateToRequest = sDate;
        [od setObject: sDate forKey: @"date"];    
        [od setObject: @"" forKey: @"date2"];
    }
    //[dh release];
    
    //[od setObject: cmbSelectDate.titleLabel.text forKey: @"date"];
    //[od setObject: cmbSelectDate.titleLabel.text forKey: @"date2"];   
    srTimesheet = [[SOAPRequester alloc] init];
    srTimesheet.delegate = self;
    [srTimesheet sendSOAPRequest:cfgMgr:@"GetTimesheet":od];
    
    //[od release];
}

- (void) foundXMLElement: (NSObject*)sourceXmlReader:(NSString*)sElementName:(NSMutableString*)sValue{
    /*UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Connection Test OK!"
                          message:[NSString stringWithFormat:@"Server says: %@", sValue] 
                          delegate:self  
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil];
    [alert show];*/
    if(sourceXmlReader == xmlReader){
        NSString *sSValue = [NSString stringWithFormat:@"%@", sValue];
        
        if ([sElementName isEqualToString:@"idtimesheet"]) {
            entry = [[TimeSheetEntry alloc] init];
            entry.nID = [NSString stringWithFormat:@"%@", sValue];
            if ([entry.nID isEqualToString:@"-1"]) {
                bErrorSessionId = TRUE;
            }
        }else if ([sElementName isEqualToString:@"timeFrom"]) {
            //NSLog(sValue);
            entry.dStartTime = [NSString stringWithFormat:@"%@", sValue];
        }else if ([sElementName isEqualToString:@"timeTo"]) {
            entry.dEndTime = [NSString stringWithFormat:@"%@", sValue];
            
            
            // TEMP Move to sWorkdate because of [NSString stringWithFormat:@"2011-04-12 %@", ..
            NSDateFormatter * df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [df setTimeZone:[NSTimeZone systemTimeZone]];
            [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
            
            NSString *sTmp = [NSString stringWithFormat:@"2011-04-12 %@", entry.dStartTime];
            NSDate *theDateFrom = [df dateFromString:sTmp];
            //NSLog(@"date: %@", theDateFrom);
            
            sTmp = [NSString stringWithFormat:@"2011-04-12 %@", entry.dEndTime];
            NSDate *theDateTo = [df dateFromString:sTmp];
            //NSLog(@"date: %@", theDateTo);
            
            NSTimeInterval timeDifference = [theDateTo timeIntervalSinceDate:theDateFrom];
            //totalTime = totalTime + (int)timeDifference;
            nTimeDifference = (int)timeDifference;
        }else if ([sElementName isEqualToString:@"timeDif"]) {
            entry.tHoursWorked = [NSString stringWithFormat:@"%@", sValue];
        }else if ([sElementName isEqualToString:@"description"]) {
            entry.sDescription = [NSString stringWithFormat:@"%@", sValue];
        }else if ([sElementName isEqualToString:@"idclient"]) {
            entry.nClientID = [NSString stringWithFormat:@"%@", sValue];
        }else if ([sElementName isEqualToString:@"client"]) {
            entry.sClient = [NSString stringWithFormat:@"%@", sValue];
        }else if ([sElementName isEqualToString:@"idproject"]) {
            entry.nProjectID = [NSString stringWithFormat:@"%@", sValue];
        }else if ([sElementName isEqualToString:@"project"]) {
            entry.sProject = [NSString stringWithFormat:@"%@", sValue];
        }else if ([sElementName isEqualToString:@"idworkcode"]) {
            entry.nWorkcodeID = [NSString stringWithFormat:@"%@", sValue];
        }else if ([sElementName isEqualToString:@"workcode"]) {
            entry.sWorkcode = [NSString stringWithFormat:@"%@", sValue];
            //[arrTimeSheetEntries addObject:entry];
        }else if ([sElementName isEqualToString:@"workdate"]) {
            entry.sWorkdate = [NSString stringWithFormat:@"%@", sValue];
            
            [arrTimeSheetEntries addObject:entry];
            
            NSTimeInterval *totalTimeToUse = totalTime;
            NSMutableArray *arrToUse = nil;
            //NSTimeInterval *tiToUse = nil;
            
            if(![sSValue isEqualToString:sWorkDateGroup]){
                totalTime = 0;
                sWorkDateGroup = sSValue;
            }
            
            totalTime += nTimeDifference;
            totalTimeToUse = totalTime;
            
            if ([sWorkDateToRequest isEqualToString:@""]) {
                if ([sWorkDateGroup isEqualToString:sWorkDateLeft]) {
                    arrToUse = arrTSELeft;
                    totalTimeLeft = totalTimeToUse;
                    //lblUserLeft.text = sWorkDateLeft;
                }else if([sWorkDateGroup isEqualToString:sWorkDate]){
                    arrToUse = arrTSECenter;
                    totalTimeCenter = totalTimeToUse;                
                    //lblUser.text = sWorkDate;
                }else if([sWorkDateGroup isEqualToString:sWorkDateRight]){
                    arrToUse = arrTSERight;
                    totalTimeRight = totalTimeToUse;
                    //lblUserRight.text = sWorkDateRight;                
                }
            }else{
                if ([sWorkDateToRequest isEqualToString:sWorkDateLeft]) {
                    arrToUse = arrTSELeft;
                    totalTimeLeft = totalTimeToUse;
                }else if([sWorkDateToRequest isEqualToString:sWorkDate]){
                    arrToUse = arrTSECenter;
                    totalTimeCenter = totalTimeToUse;                
                }else if([sWorkDateToRequest isEqualToString:sWorkDateRight]){
                    arrToUse = arrTSERight;
                    totalTimeRight = totalTimeToUse;
                }
            }
            [arrToUse addObject:entry];
            //tiToUse = totalTime
        }
        return;
    }
    if([sElementName isEqualToString:@"return"] & [sValue isEqualToString:@"1"])
        [self dismissModalViewControllerAnimated:YES];
}

- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error{
    [actMain stopAnimating];
    [CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @""): [error description]];
}

- (void) gotSOAPAnswere:(NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data{   
    
    if (requester == srTimesheet) {
        NSLog(@"%@", [NSString stringWithFormat:@"%@", sXMLAnswere]);
        arrTimeSheetEntries = [[NSMutableArray alloc] init];
        arrTimeSheetEntries2 = [[NSMutableArray alloc] init];
        if([sWorkDateToRequest isEqualToString:@""]){
            arrTSELeft = [[NSMutableArray alloc] init];
            arrTSECenter = [[NSMutableArray alloc] init];
            arrTSERight = [[NSMutableArray alloc] init];
            
            totalTimeLeft = 0;
            totalTimeCenter = 0;
            totalTimeRight = 0;
            
            DateHelper * dh = [[DateHelper alloc] init];
            NSDate *dFrom = [dh dateFromShortString:cmbSelectDate.titleLabel.text];
            
            lblUserLeft.text = [[dh longStringFromDate:[dh dateAddDay:dFrom:-1]] copy];
            lblUser.text =  [[dh longStringFromDate:dFrom] copy];
            lblUserRight.text = [[dh longStringFromDate:[dh dateAddDay:dFrom:1]] copy];
            //[dh release];
            
        }else{
            if ([sWorkDateToRequest isEqualToString:sWorkDateLeft]) {
                arrTSELeft = [[NSMutableArray alloc] init];
                totalTimeLeft = 0;
            }else if([sWorkDateToRequest isEqualToString:sWorkDate]){
                arrTSECenter = [[NSMutableArray alloc] init];
                totalTimeCenter = 0;
            }else if([sWorkDateToRequest isEqualToString:sWorkDateRight]){
                arrTSERight = [[NSMutableArray alloc] init];
                totalTimeRight = 0;
            }
        }
        
        NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"idtimesheet"];
        [aElementsToFind addObject:@"timeFrom"];
        [aElementsToFind addObject:@"timeTo"];
        [aElementsToFind addObject:@"timeDif"];
        [aElementsToFind addObject:@"description"];
        [aElementsToFind addObject:@"idclient"];
        [aElementsToFind addObject:@"client"];
        [aElementsToFind addObject:@"idproject"];
        [aElementsToFind addObject:@"project"];
        [aElementsToFind addObject:@"idworkcode"];
        [aElementsToFind addObject:@"workcode"];
        [aElementsToFind addObject:@"workdate"];
        
        sWorkDateGroup = [NSString stringWithFormat:@""];
        xmlReader = [[XMLReader alloc] init];
        xmlReader.delegate = self;
        
        [xmlReader parseForElements:aElementsToFind:srTimesheet.webData];
        if (bErrorSessionId) {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") :NSLocalizedString(@"msgSessionError", @"")];
            [actMain stopAnimating];  
            return;
        }
        [tbvTimeSheet reloadData];
        [tbvTimeSheetLeft reloadData];
        [tbvTimeSheetRight reloadData];
        
        NSTimeInterval *tiToUse = totalTime;
        
        if([sWorkDateToRequest isEqualToString:@""]){
            for (int i = 0; i < 3; i++) {
                if(i == 0)
                    tiToUse = totalTimeLeft;
                else if(i == 1)
                    tiToUse = totalTimeCenter;
                else
                    tiToUse = totalTimeRight;
                
                int nHours = ((int)(((int)tiToUse)/60/60))/8;
                int nMinutes = ((int)(((((int)tiToUse) / 60) - (nHours * 60 * 8))))/8;
                
                NSString *sMinExt = @"";
                NSString *sAllExt = @"";
                if(nMinutes < 10 & nMinutes >= 0)
                    sMinExt = @"0";
                else if(nMinutes < 0){
                    if(nMinutes > -10)
                        sMinExt = @"0";
                    sAllExt = @"-";
                    nMinutes *= -1;
                }
                
                if(nHours < 0){
                    sAllExt = @"-";
                    nHours *= -1; 
                }
                
                if(i == 0)
                    lblDayTotalLeft.text = [NSString stringWithFormat:@"    Total: %@%d:%@%d h",sAllExt, nHours, sMinExt, nMinutes];
                else if(i == 1)
                    lblDayTotal.text = [NSString stringWithFormat:@"    Total: %@%d:%@%d h",sAllExt, nHours, sMinExt, nMinutes];
                else
                    lblDayTotalRight.text = [NSString stringWithFormat:@"    Total: %@%d:%@%d h",sAllExt, nHours, sMinExt, nMinutes];
            }
        }else{
            if ([sWorkDateToRequest isEqualToString:sWorkDateLeft]) {
                tiToUse = totalTimeLeft;
            }else if([sWorkDateToRequest isEqualToString:sWorkDate]){
                tiToUse = totalTimeCenter;
            }else if([sWorkDateToRequest isEqualToString:sWorkDateRight]){
                tiToUse = totalTimeRight;
            }
            
            int nHours = ((int)(((int)tiToUse)/60/60))/8;
            int nMinutes = ((int)(((((int)tiToUse) / 60) - (nHours * 60 * 8))))/8;
            
            NSString *sMinExt = @"";
            NSString *sAllExt = @"";
            if(nMinutes < 10 & nMinutes >= 0)
                sMinExt = @"0";
            else if(nMinutes < 0){
                if(nMinutes > -10)
                    sMinExt = @"0";
                sAllExt = @"-";
                nMinutes *= -1;
            }
            
            if(nHours < 0){
                sAllExt = @"-";
                nHours *= -1; 
            }
            
            if ([sWorkDateToRequest isEqualToString:sWorkDateLeft]) {
                lblDayTotalLeft.text = [NSString stringWithFormat:@"    Total: %@%d:%@%d h",sAllExt, nHours, sMinExt, nMinutes];
            }else if([sWorkDateToRequest isEqualToString:sWorkDate]){
                lblDayTotal.text = [NSString stringWithFormat:@"    Total: %@%d:%@%d h",sAllExt, nHours, sMinExt, nMinutes];
            }else if([sWorkDateToRequest isEqualToString:sWorkDateRight]){
                lblDayTotalRight.text = [NSString stringWithFormat:@"    Total: %@%d:%@%d h",sAllExt, nHours, sMinExt, nMinutes];
            }
        }
        
        [actMain stopAnimating];  
        return;
    }
    NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
    [aElementsToFind addObject:@"return"];
    
    XMLReader *xmlReader2 = [[XMLReader alloc] init];
    xmlReader2.delegate = self;
    [xmlReader2 parseForElements:aElementsToFind:sr.webData];
    
    [actMain stopAnimating];
    return;
}

-(IBAction)logout:(id)sender{
    OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
    
    [mutable setObject: la.sSessionID forKey: @"idsession"];
    [mutable setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"iduser"];
    
    ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
    
    cfgTmp.sDefaultMandate = cfgMgr.sDefaultMandate;
    cfgTmp.sDefaultUser = cfgMgr.sDefaultUser;
    cfgTmp.sDefaultPassword = cfgMgr.sDefaultPassword;
    
    sr = [[SOAPRequester alloc] init];
    sr.delegate = self;
    [sr sendSOAPRequest:cfgTmp:@"Logout":mutable];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if(item == tbiConfig){
        configMainView = nil;
        if (configMainView == nil)
            configMainView = [[ConfigMainViewController alloc] init];
        
        configMainView.bOpenDataConfig = TRUE;
        configMainView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        configMainView.cfgMgr = cfgMgr;
        configMainView.la = la;
        [configMainView setDelegate:self];
        [self presentModalViewController:configMainView animated:YES];
        //[configMainView openDataConfig];
    }else if (item == tbiQuickview) {
        if (quickView == nil) {
            quickView = [[QuickViewController alloc] init];
        }
        quickView.cfgMgr = cfgMgr;
        quickView.la = la;
        quickView.sDate = cmbSelectDate.titleLabel.text;
        quickView.dSelectedDate = dSelectedDate;
        [quickView setDelegate:self];
        quickView.objRoot = self;
        [self presentModalViewController:quickView animated:NO];
    }else if (item == tbiReports) {
        if (reportMainView == nil) {
            reportMainView = [[ReportMainViewController alloc] init];
        }
        //ReportMainViewController *myNewVC = [[ReportMainViewController alloc] init];
        reportMainView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        reportMainView.cfgMgr = cfgMgr;
        reportMainView.la = la;
        reportMainView.dSelectedMonth = dSelectedDate;
        [reportMainView setDelegate:self];
        [self presentModalViewController:reportMainView animated:YES];
    }
    tabMain.selectedItem = tbiTimesheet;
}
- (void)closeQuickView:(int)nSubView{
    [quickView dismissModalViewControllerAnimated:NO];
    quickView = nil;
    if (nSubView > 0) {
        if (quickView == nil) {
            quickView = [[QuickViewController alloc] init];
        }
        quickView.cfgMgr = cfgMgr;
        quickView.la = la;
        quickView.sDate = cmbSelectDate.titleLabel.text;
        quickView.dSelectedDate = dSelectedDate;
        [quickView setDelegate:self];
        quickView.objRoot = self;
        [self presentModalViewController:quickView animated:NO];
    }else {
        [self reloadTimesheet:nil];
    }

}
- (void)loadSubView:(int)nSubView{
    int n = 0;
    n = n;
    if (nSubView == 3) {
        //[self dismissModalViewControllerAnimated:NO];
        ConfigMainViewController *myNewVC = [[ConfigMainViewController alloc] init];
        myNewVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        myNewVC.cfgMgr = cfgMgr;
        [self presentModalViewController:myNewVC animated:YES];
    }else if(nSubView == 2){
        //[self dismissModalViewControllerAnimated:NO];
        ReportMainViewController *myNewVC = [[ReportMainViewController alloc] init];
        myNewVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //myNewVC.cfgMgr = cfgMgr;
        [self presentModalViewController:myNewVC animated:YES];
    }
}
- (void)event:(int)nSubView{

}
-(void)showSubView:(int)nSubView{
    int n = 0;
    n = n;
    if (nSubView == 3) {
        ConfigMainViewController *myNewVC = [[ConfigMainViewController alloc] init];
        myNewVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        myNewVC.cfgMgr = cfgMgr;
        [self presentModalViewController:myNewVC animated:YES];
    }else if(nSubView == 2){
        ReportMainViewController *myNewVC = [[ReportMainViewController alloc] init];
        myNewVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        //myNewVC.cfgMgr = cfgMgr;
        [self presentModalViewController:myNewVC animated:YES];
    }
}

-(NSString *) dateInFormat:(NSString*) stringFormat {
	char buffer[80];
	const char *format = [stringFormat UTF8String];
	time_t rawtime;
	struct tm * timeinfo;
	time(&rawtime);
	timeinfo = localtime(&rawtime);
	strftime(buffer, 80, format, timeinfo);
	return [NSString  stringWithCString:buffer encoding:NSUTF8StringEncoding];
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
    dSelectedDate = [[NSDate alloc] init];
	//arrData = [[NSArray alloc] initWithObjects: @"04:15h (08:00 - 12:15)", @"04:00h (13:00 - 17:00)", nil];
    
    centerFrame = tbvTimeSheet.frame;
    leftFrame = CGRectMake(centerFrame.origin.x-centerFrame.size.width, centerFrame.origin.y, centerFrame.size.width, centerFrame.size.height);
    rightFrame = CGRectMake(centerFrame.origin.x+centerFrame.size.width, centerFrame.origin.y, centerFrame.size.width, centerFrame.size.height);
    
    tbvTimeSheetLeft.frame = leftFrame;
    tbvTimeSheetRight.frame = rightFrame;
    
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerView.transform = transform;
	
	//pickerProjectView.transform = transform;
	//pickerWorkcodeView.transform = transform;
	//[self.view addSubview:pickerView];
	[UIView commitAnimations];
    
	//niDate.title = [self dateInFormat:@"%d.%m.%Y"];
	[cmbSelectDate setTitle:[self dateInFormat:@"%d.%m.%Y"] forState:UIControlStateNormal];
	[cmbSelectDate setTitle:[self dateInFormat:@"%d.%m.%Y"] forState:UIControlStateSelected];
    [cmbSelectDate setTitle:[self dateInFormat:@"%d.%m.%Y"] forState:UIControlStateHighlighted];
    [self reloadTimesheet:nil];
	lblUser.text = [NSString stringWithFormat:@"   %@", cfgMgr.sDefaultUser]; //sUsername;
    lblUserLeft.text = lblUser.text;
    lblUserRight.text = lblUser.text;
    lblDayTotal.text = [NSString stringWithFormat:@"    Total: 00:00h"]; //
    sWorkDateToRequest = @"";

    tabMain.selectedItem = tbiTimesheet;
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


#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // How to get the UITableViewCell associated with this indexPath?
    //UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //return [cell ];
    NSMutableArray *arrToUse;
    if (tableView == tbvTimeSheet)
        arrToUse = arrTSECenter;
    else if(tableView == tbvTimeSheetLeft)
        arrToUse = arrTSELeft;
    else if(tableView == tbvTimeSheetRight)
        arrToUse = arrTSERight;
    TimeSheetEntry *tseToUse = [arrToUse objectAtIndex:indexPath.row];
    if ([tseToUse.sDescription isEqualToString:@""]) {
        return 55;
    }else {
        return 80;
    }

}

//Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	//int n = [arrTimeSheetEntries  count];
    //totalTime = 0;
    //return [arrTimeSheetEntries  count];
    if (tableView == tbvTimeSheet)
        return [arrTSECenter count];
    else if(tableView == tbvTimeSheetLeft)
        return [arrTSELeft count];
    else if(tableView == tbvTimeSheetRight)
        return [arrTSERight count];
    else {
        return 0;
    }
}

//Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
	static NSString *CellIdentifier = @"TimeSheetCustomCell";
	TimeSheetCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if(cell == nil){
		//NSLog(@"New cell made");
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TimeSheetCustomCell" owner:nil options:nil];
		for(id currentObject in topLevelObjects){
			if([currentObject isKindOfClass:[TimeSheetCustomCell class]]){
				cell = (TimeSheetCustomCell *)currentObject;
				break;
			}
		}
	}
    
	NSMutableArray *arrToUse = nil;
    if (tableView == tbvTimeSheet)
        arrToUse = arrTSECenter;
    else if(tableView == tbvTimeSheetLeft)
        arrToUse = arrTSELeft;
    else if(tableView == tbvTimeSheetRight)
        arrToUse = arrTSERight;
    
    //TimeSheetEntry *tse = [arrTimeSheetEntries objectAtIndex:indexPath.row];
    TimeSheetEntry *tse = [arrToUse objectAtIndex:indexPath.row];
    DateHelper *dh = [[DateHelper alloc] init];
    NSString *sHoursWorked = [tse.tHoursWorked copy];
    NSString *sStartTime = [tse.dStartTime copy];
    NSString *sEndTime = [tse.dEndTime copy];
    cell.tse = tse;
    
    if(!cfgMgr.bShowSeconds){
        sHoursWorked = [[dh stringFromDate:[dh dateFromStrings:sHoursWorked :@"HH:mm:ss"]:@"HH:mm"] copy];
        sStartTime = [[dh stringFromDate:[dh dateFromStrings:sStartTime :@"HH:mm:ss"]:@"HH:mm"] copy];
        sEndTime = [[dh stringFromDate:[dh dateFromStrings:sEndTime :@"HH:mm:ss"]:@"HH:mm"] copy];
    }
    
	NSString *sTimeText1 = [NSString stringWithFormat:@"%@ h", sHoursWorked];
    
    NSString *sTimeText2 = [NSString stringWithFormat:@"(%@ - %@)", sStartTime, sEndTime];
    
    NSString *sProjectWorkcode = [NSString stringWithFormat:@"%@, %@ (%@)", tse.sClient, tse.sProject, tse.sWorkcode];
    
	[[cell lblTime] setText:sTimeText1];
	[[cell lblTime2] setText:sTimeText2];
	[[cell lblProjectWorkcode] setText:sProjectWorkcode];
    if ([tse.sDescription isEqualToString:@""]) {
        //[cell lblText].frame = CGRectMake(cell.lblText.frame.origin.x, cell.lblText.frame.origin.y, cell.lblText.frame.size.width, 10);
        cell.viewForBackground.frame = CGRectMake(cell.viewForBackground.frame.origin.x, cell.viewForBackground.frame.origin.y, cell.viewForBackground.frame.size.width, 60);
        
        cell.cmdEdit.frame = CGRectMake(cell.cmdEdit.frame.origin.x, 13, cell.cmdEdit.frame.size.width, cell.cmdEdit.frame.size.height);
    }
	[[cell lblText] setText:tse.sDescription];
	//cell.timesheetView = self;
    [cell setDelegate:self];
	cell.nRowIdx = indexPath.row;
	
	return cell;	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
