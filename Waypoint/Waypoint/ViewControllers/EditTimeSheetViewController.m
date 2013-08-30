//
//  EditTimeSheetViewController.m
//  Waypoint
//
//  Created by Kim David Hauser on 05.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import "EditTimeSheetViewController.h"
#import "DateHelper.h"
#import "CommonFunctions.h"
#import "QuickEntry.h"

@interface EditTimeSheetViewController ()

@end

@implementation EditTimeSheetViewController
@synthesize cfgMgr;
@synthesize la;
@synthesize tse;
@synthesize dSelectedDate;
//@synthesize editTimesheetEntry;

- (void)pickerCustomCellDelegateDoButton:(int)nID{
    [self newConfigTextShow:nID];
}

- (IBAction)newConfigTextShow:(int)sender{
    bNewText = YES;
    nConfigID = sender;
    if(sender == 0){
        bbiTitleConfig.title = NSLocalizedString(@"lblNewClient", @"");//@"New client";
        txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterNewClient", @"");
    }else if(sender == 1){
        bbiTitleConfig.title = NSLocalizedString(@"lblNewProject", @"");//@"New client";
        txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterNewProject", @"");
    }else if(sender == 2){
        bbiTitleConfig.title = NSLocalizedString(@"lblNewWorkcode", @"");//@"New client";
        txtNewConfigText.placeholder = NSLocalizedString(@"lblEnterNewWorkcode", @"");
        //bbiTitleConfig.title = @"New workcode";
        //txtNewConfigText.placeholder = @"Enter a new workcode";        
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

- (IBAction)doneProject{
    if(nPickerMode == 0){
        if (![sClient isEqualToString:((ClientEntry*)[cfgMgr.aClients objectAtIndex:[projectPicker selectedRowInComponent:0]]).sClient]) {
            sClient = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:[projectPicker selectedRowInComponent:0]]).sClient;
            clientEntry = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:[projectPicker selectedRowInComponent:0]]);
            sProject = nil;
            if(tse != nil){
                tse.sClient = sClient;
                tse.sProject = nil;
            }
        }
    }else if(nPickerMode == 1){
        if (clientEntry != nil) {
            if([projectPicker selectedRowInComponent:0] <= clientEntry.aProjects.count)
                sProject = ((ProjectEntry*)[clientEntry.aProjects objectAtIndex:[projectPicker selectedRowInComponent:0]]).sProjectName;
            else
                sProject = nil;
        }else {
            sProject = nil;
        }
        
        if(tse != nil)
            tse.sProject = sProject;
    }else{
        sWorkcode = ((WorkcodeEntry*)[cfgMgr.aWorkcodes objectAtIndex:[projectPicker selectedRowInComponent:0]]).sWorkcode; 
        if(tse != nil)
            tse.sWorkcode = sWorkcode;
    }

    [self hideProjectPicker];
    
    [tbvEdit reloadData];    
}

- (IBAction)hideProjectPicker{
    [dimBackgroundView removeFromSuperview];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerProjectView.transform = transform;
	[UIView commitAnimations];	
}

- (IBAction)doneTime{
    //NSDate *dTmp = timePicker.date;
    [dimBackgroundView removeFromSuperview];
    if(nTimeMode == 0){
        //startFrom = timePicker.date;
    }else{
        //endAt = timePicker.date;
    }
    [self hideTimePicker];

    [tbvEdit reloadData];
    
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
        if(tse != nil){
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"HH:mm:ss"];          
            tse.dStartTime = [df stringFromDate:timePicker.date];
        }else{
            startFrom = [timePicker.date copy];
        }
    }else{
        if(tse != nil){
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"HH:mm:ss"];          
            tse.dEndTime = [df stringFromDate:timePicker.date];
        }else{
            endAt = [timePicker.date copy];
        }
    }
    [tbvEdit reloadData];
}

#pragma mark - Pickerview functions
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
    else 
        return 0;
    
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 
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
    }else {
        return @"";
    }
}


#pragma mark - Tableview functions
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
    if (nMinutes > 0) {
        int n = 0;
        n = n;
    }
	if(nHours < 10){
        sAllExt = @"0";
    }
    return [NSString stringWithFormat:@"%@%d:%@%d:%@%d",sAllExt, nHours, sMinExt, nMinutes, sSecExt, nSeconds];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if(startFrom == nil)
        startFrom = [[NSDate alloc] init];
    
    if(endAt == nil)
        endAt = [[NSDate alloc] init];
    
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:(cfgMgr.bShowSeconds ? @"HH:mm:ss" : @"HH:mm")];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSString *sStartFrom = [df stringFromDate:startFrom];
    NSString *sEndAt = [df stringFromDate:endAt];
    //[df release];
    
    if(tse != nil){
        sStartFrom = tse.dStartTime;
        sEndAt = tse.dEndTime;
        if(!cfgMgr.bShowSeconds){
            DateHelper *dh = [[DateHelper alloc] init];
            sStartFrom = [[dh stringFromDate:[dh dateFromStrings:sStartFrom format:@"HH:mm:ss"] format:@"HH:mm"] copy];
            sEndAt = [[dh stringFromDate:[dh dateFromStrings:sEndAt format:@"HH:mm:ss"] format:@"HH:mm"] copy];
        }
        
        sProject = tse.sProject;
        sWorkcode = tse.sWorkcode;
        sClient = tse.sClient;
        sDescription = tse.sDescription;
        
        NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
        //[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [df2 setDateFormat:(cfgMgr.bShowSeconds ? @"dd.MM.yyyy HH:mm:ss" : @"dd.MM.yyyy HH:mm")];
        [df2 setTimeZone:[NSTimeZone systemTimeZone]];
        [df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        NSString *sTmp = [NSString stringWithFormat:@"%@ %@", @"29.02.2012", sStartFrom];
        //NSDate *theDate = [df dateFromString:@"2011-04-12 10:00:00"];
        startFrom = [df2 dateFromString:sTmp];
        
        sTmp = [NSString stringWithFormat:@"%@ %@", @"29.02.2012", sEndAt];
        //NSDate *theDate = [df dateFromString:@"2011-04-12 10:00:00"];
        endAt = [df2 dateFromString:sTmp];
    }
    
    if(indexPath.row == 0 & indexPath.section == 0){
        [cell textLabel].text = [NSString stringWithFormat:@"%@%@",(cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblStartTime", @"")] : @""), sStartFrom];
        [cell imageView].image = [UIImage imageNamed:@"start-icon.png"];
        
    }else if(indexPath.row == 1 & indexPath.section == 0){
        
        [cell textLabel].text = [NSString stringWithFormat:@"%@%@",(cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblWorkTime", @"")] : @""), [self getTimeInterval:startFrom :endAt]];
        [cell imageView].image = [UIImage imageNamed:@"Clock-icon.png"];
        
    }else if(indexPath.row == 2 & indexPath.section == 0){
        
        [cell textLabel].text = [NSString stringWithFormat:@"%@%@",(cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: ", NSLocalizedString(@"lblEndTime", @"")] : @""), sEndAt];
        [cell imageView].image = [UIImage imageNamed:@"player_stop.png"];
    }else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"PickerCustomCell";
        PickerCustomCell *cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell2 == nil){
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PickerCustomCell" owner:nil options:nil];
            for(id currentObject in topLevelObjects){
                if([currentObject isKindOfClass:[PickerCustomCell class]]){
                    cell2 = (PickerCustomCell *)currentObject;
                    break;
                }
            }
        }
        
        if(indexPath.row == 0){
            [cell2 lblTime].text = [NSString stringWithFormat:@"%@", sClient != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"lblClient", @""), sClient] : sClient) : [NSString stringWithFormat:@"<Select %@>", NSLocalizedString(@"lblClient", @"")]];
            [cell2 imgView].image = [UIImage imageNamed:@"user_business.png"];
        }else if(clientEntry != nil & indexPath.row == 1){
            [cell2 lblTime].text = [NSString stringWithFormat:@"%@", sProject != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"lblProject", @""), sProject] : sProject) : [NSString stringWithFormat:@"<Select %@>", NSLocalizedString(@"lblProject", @"")]];
            [cell2 imgView].image = [UIImage imageNamed:@"folder.png"];
        }else if((clientEntry == nil & indexPath.row == 1) | (clientEntry != nil & indexPath.row == 2)){
            [cell2 lblTime].text = [NSString stringWithFormat:@"%@", sWorkcode != nil ? (cfgMgr.bShowDescriptions ? [NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"lblWorkcode", @""), sWorkcode] : sWorkcode) : [NSString stringWithFormat:@"<Select %@>", NSLocalizedString(@"lblWorkcode", @"")]];
            [cell2 imgView].image = [UIImage imageNamed:@"workcode.gif"];
        }
        [cell2 setDelegate:self];
        cell2.nID = indexPath.row;
        return cell2;
    }else if(indexPath.section == 2){
         [cell textLabel].text = [NSString stringWithFormat:@"%@", (sDescription != nil && (![sDescription isEqualToString:@""])) ? sDescription : NSLocalizedString(@"lblEnterDescription", @"")];
         if (sDescription == nil || [sDescription isEqualToString:@""]) {
             [cell textLabel].textColor = [UIColor lightGrayColor];
         }
         [cell imageView].image = [UIImage imageNamed:@"txt.png"];    
    }else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [cell textLabel].text = [NSString stringWithFormat:@"Start WP: %@", @""];
            [cell imageView].image = [UIImage imageNamed:@"flag_green.png"];
        }else {
            [cell textLabel].text = [NSString stringWithFormat:@"Stop WP: %@", @""];
            [cell imageView].image = [UIImage imageNamed:@"flag_red.png"];            
        }


    }else if(indexPath.section == 4){
        cell.textLabel.text = @"Delete";
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        [cell imageView].image = [UIImage imageNamed:@"delete.png"];    
    }
	return cell;	
	
}

- (void)showDisabledBackground:(UIView*)superView{
    dimBackgroundView = [[UIView alloc] initWithFrame:superView.bounds];
    dimBackgroundView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:.5f];
    
    [superView addSubview:dimBackgroundView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DateHelper *dh = [[DateHelper alloc] init];
    if (indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 2)) { 
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
            bbiTitleTime.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblStartTime", @"")];
            NSDate *dTmp = (tse != nil ? [dh dateFromStrings:[NSString stringWithFormat:@"%@ %@", tse.sWorkdate, tse.dStartTime] format:@"dd.MM.yyyy HH:mm:ss"]:  startFrom);
            timePicker.date = dTmp;
            nTimeMode = 0;
        }else if(indexPath.row == 2){
            bbiTitleTime.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblEndTime", @"")];
            NSDate *dTmp = (tse != nil ? [dh dateFromStrings:[NSString stringWithFormat:@"%@ %@", tse.sWorkdate, tse.dEndTime] format:@"dd.MM.yyyy HH:mm:ss"]:  endAt);
            timePicker.date = dTmp;
            nTimeMode = 1;
        }
        
    }
    else if(indexPath.section == 1 ){
        if(indexPath.row == 0){
            nPickerMode = 0;
            bProject = TRUE;
            bbiTitle.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblClient", @"")];
        }else if(indexPath.row == 1){
            nPickerMode = 1;
            bbiTitle.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblProject", @"")];
            bProject = FALSE;
        }else if(indexPath.row == 2){
            nPickerMode = 2;
            bbiTitle.title = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"lblSelect", @"") , NSLocalizedString(@"lblWorkcode", @"")];
            bProject = FALSE;
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
        
        [projectPicker reloadComponent:0];
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
            if(![sProject isEqualToString:@""]){
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
        /*}*/
    }else if(indexPath.section == 2 ){
        [self hideProjectPicker];
        [self hideTimePicker];
        
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
        //
        [containerView addSubview:imageView];
        [containerView addSubview:textView];
        [containerView addSubview:entryImageView];
        
        UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
        doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        [doneBtn setTitle:NSLocalizedString(@"lblDone", @"") forState:UIControlStateNormal];
        
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
        
    }else if (indexPath.section == 4) {
        [CommonFunctions showYesNoBox:@"Delete?" message:@"In Delete Function!" delegate:self];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 0)
    {
        //NSLog(@"No");
        bShowMore = FALSE;
        // Do any additional setup after loading the view from its nib.
        /*[UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
        //pickerView.transform = transform;
        
        moreView.transform = transform;
        //pickerTimeView.transform = transform;
        //pickerProjectView.transform = transform;
        //newWorkcodeView.transform = transform;
        //newProjectView.transform = transform;
        //[self.view addSubview:pickerView];
        [UIView commitAnimations];*/
    }
    else
    {
        OrderedDictionary *mutable = [[OrderedDictionary alloc] init];

        [mutable setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession"];
        //[mutable setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession"];
        [mutable setObject: [NSString stringWithFormat:@"%@", tse.nID] forKey: @"idtimesheet"];
        
        ConfigMgr *cfgTmp = [[ConfigMgr alloc] initWithName: @""];
        
        srDelete = [[SOAPRequester alloc] init];
        srDelete.delegate = self; 
        [srDelete sendSOAPRequest:cfgTmp message:@"DeleteTimesheetEntry" od:mutable];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tse != nil)
        return 5;
    else 
        return 4;
}

//Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
        return 3;
    else if(section == 1)
        if (clientEntry != nil) {
            return 3;
        }else {
            return 2;
        }
    else if(section == 3)
        return 2;
    else {
        return 1;
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

#pragma mark - HPGrowingTextView functions

-(void)resignTextView
{
    [dimBackgroundView removeFromSuperview];
	[textView resignFirstResponder];
}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
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
	
    if(tse != nil)
        tse.sDescription = [textView.text copy];
    else 
        sDescription = [textView.text copy];
    [UIView commitAnimations];
	
    
    //NSLog(sDescription);

    @try
    {
        //ERROR OF DEATH
        //[tbvEdit reloadData];
    }
    @catch (NSException *ex) {
        
    }
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



-(IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    [delegate closeEditTimeSheetView:FALSE];
}

- (IBAction) save:(id)sender{
    
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
    
    int nClient = 0;
    if(![sClient isEqualToString:@""]){
        for (NSUInteger i = 0; i < [cfgMgr.aClients count]; i++) {
            ClientEntry *cliEntry = [cfgMgr.aClients objectAtIndex:i]; 
            if([cliEntry.sClient isEqualToString:sClient]){
                nClient = cliEntry.nClientID;
                break;
            }
        }
    }
    int nProject= 0;
    if(![sProject isEqualToString:@""]){
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
	[df setDateFormat:@"dd.MM.yyyy HH:mm:ss"]; //ss
    
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
	[df2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *df3 = [[NSDateFormatter alloc] init];
	[df3 setDateFormat:@"HH:mm:ss"];//ss
    
    DateHelper *dh = [[DateHelper alloc] init];
    NSString *sTmp = [NSString stringWithFormat:@"%@ %@", (tse != nil ? tse.sWorkdate :[dh stringFromDate:dSelectedDate format:@"dd.MM.yyyy"]), (tse != nil ? tse.dStartTime : [df3 stringFromDate: startFrom])];
    NSDate * dTmp = [df dateFromString:sTmp];
    
    NSString *sTmp2 = [NSString stringWithFormat:@"%@ %@", (tse != nil ? tse.sWorkdate : [dh stringFromDate:dSelectedDate format:@"dd.MM.yyyy"]), (tse != nil ? tse.dEndTime : [df3 stringFromDate:endAt])];
    NSDate * dTmp2 = [df dateFromString:sTmp2];
    
	//[self closeView];
    OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
    
    NSString* sID = @"-1";
    if(tse != nil)
        sID = tse.nID;
    
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

- (void)setDelegate:(id)val{
	delegate = val;
}

- (void) foundXMLElement: (NSObject*)sourceXmlReader:(NSString*)sElementName:(NSMutableString*)sValue{
    //NSLog(sValue);
    if(sourceXmlReader == xmlReaderConfig){
        if([sElementName isEqualToString:@"return"]){
            //wpiStart.nClientId = sValue.intValue;
            //NSLog(sValue);
            int nRet = sValue.intValue;
            
            if(nRet <= 0){
                //Error
                nRet = nRet;
                if (nRet == -1 | nRet == -5) {
                    bErrorSessionId = TRUE;
                    return;
                }
            }else {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1.0];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
                viewTextNew.transform = transform;
                [UIView commitAnimations];
                [txtNewConfigText resignFirstResponder];
                [dimBackgroundView removeFromSuperview];
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
                    if(tse != nil){
                        tse.sClient = [txtNewConfigText.text copy];
                        tse.nClientID = [sValue copy];
                        tse.sProject = nil;
                    }
                }else if (nConfigID == 1) {
                    if (clientEntry != nil) {
                        for (int i = 0; i < clientEntry.aProjects.count; i++) {
                            ProjectEntry *ce = [clientEntry.aProjects objectAtIndex:i];
                            if(ce.nProjectID == nRet){
                                bFound = YES;
                                break;
                            }
                        }
                    }
                    if(!bFound){
                        ProjectEntry *projectEntry = [[ProjectEntry alloc] init];
                        projectEntry.nProjectID = nRet;
                        projectEntry.sProjectName = [txtNewConfigText.text copy];
                        if (clientEntry != nil){
                            if (clientEntry.aProjects == nil)  
                                clientEntry.aProjects = [[NSMutableArray alloc] init];
                            [clientEntry.aProjects addObject:projectEntry];
                        }
                    }
                    sProject = [txtNewConfigText.text copy];
                    if(tse != nil){
                        tse.sProject = [txtNewConfigText.text copy];
                        tse.nProjectID = [sValue copy];
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
                    if(tse != nil){
                        tse.sWorkcode = [txtNewConfigText.text copy];
                        tse.nWorkcodeID = [sValue copy];
                    }
                }
                [tbvEdit reloadData];
            }
        }
    }else {
        if([sElementName isEqualToString:@"return"]){
            if([sValue isEqualToString:@"-1"]){
                bErrorSessionId = TRUE;
            }
        }
    }
}

- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error{
    
    //[actMain stopAnimating];
    [CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @"") message:[error description]];
}

- (void) gotSOAPAnswere:(NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data{   
    
    //[actMain stopAnimating];
    
    if (requester == srDelete) {
        NSLog(@"%@", sXMLAnswere);
        NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"return"];
        
        xmlReaderConfig = [[XMLReader alloc] init];
        xmlReaderConfig.delegate = self;
        [xmlReaderConfig parseForElements:aElementsToFind data:srDelete.webData];
        if (bErrorSessionId) {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];
        }else {
            [self dismissModalViewControllerAnimated:YES];
            [delegate closeEditTimeSheetView:TRUE];
        }
        return;
    }else if (requester == srConfigText) {
        NSLog(@"%@", sXMLAnswere);
        NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
        [aElementsToFind addObject:@"return"];
        
        xmlReaderConfig = [[XMLReader alloc] init];
        xmlReaderConfig.delegate = self;
        [xmlReaderConfig parseForElements:aElementsToFind data:srConfigText.webData];
        if (bErrorSessionId) {
            [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];
        }
        return;
    }
    
    NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
    [aElementsToFind addObject:@"return"];
    
    xmlReader = [[XMLReader alloc] init];
    xmlReader.delegate = self;
     
    [xmlReader parseForElements:aElementsToFind data:sr.webData];
    if (bErrorSessionId) {
        [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];
    }else {
        [self dismissModalViewControllerAnimated:YES];
        [delegate closeEditTimeSheetView:TRUE];
    }
    
}

#pragma mark - New config text

- (IBAction) cancelNewConfigText{
	txtNewConfigText.text = @"";
	[self doneNewConfigText];
}

-(void)doneNewConfigText{
    [self hideNewConfigText];
}

-(void)hideNewConfigText{
    bNewText = FALSE;
    [dimBackgroundView removeFromSuperview];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	viewTextNew.transform = transform;
	[UIView commitAnimations];	
	[txtNewConfigText resignFirstResponder];
    [textView resignFirstResponder];
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
        if(nConfigID == 1)
            nParentID = clientEntry.nClientID;
        else        
            nParentID = la.nUserID;
        
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
    bShowMore = FALSE;
    // Do any additional setup after loading the view from its nib.
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	//pickerView.transform = transform;
	
    moreView.transform = transform;
	pickerTimeView.transform = transform;
	pickerProjectView.transform = transform;
    viewTextNew.transform = transform;
	//newWorkcodeView.transform = transform;
	//newProjectView.transform = transform;
	//[self.view addSubview:pickerView];
	[UIView commitAnimations];
    if (tse != nil) {
        //DateHelper *dh = [[DateHelper alloc] init];
        niTitle.title = [NSString stringWithFormat:@"%@ (Edit)",tse.sWorkdate];
        for (int i = 0; i < cfgMgr.aClients.count; i++) {
            //NSString *sTmp = ;
            if ([[NSString stringWithFormat:@"%d", ((ClientEntry*)[cfgMgr.aClients objectAtIndex:i]).nClientID] isEqualToString:tse.nClientID]) {
                clientEntry = ((ClientEntry*)[cfgMgr.aClients objectAtIndex:i]);
                break;
            }
        }

    }else {
        DateHelper *dh = [[DateHelper alloc] init];
        niTitle.title = [NSString stringWithFormat:@"%@ (New)", [dh stringFromDate:dSelectedDate format:@"dd.MM.yyyy"]];
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
