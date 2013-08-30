//
//  ReportTimePerDayViewController.m
//  Waypoint
//
//  Created by Kim David Hauser on 05.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import "ReportTimePerDayViewController.h"
#import "TimePerDayCustomCell.h"
#import "CommonFunctions.h"

@interface ReportTimePerDayViewController ()

@end

@implementation ReportTimePerDayViewController

@synthesize cfgMgr;
@synthesize la;
@synthesize dSelectedMonth;
@synthesize arrMinMax;

- (void)timePerDayCustomCellDelegateDoButton:(NSString*)sDate{
    if(delegate != nil){
        if ([delegate respondsToSelector:@selector(showTimeSheetForDay:)]) {
            [delegate showTimeSheetForDay:sDate];
            //[self dismissModalViewControllerAnimated:YES];
        }
    }
}

-(IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:NO];
    if(sender != self)
        [delegate closeReportTimePerDayView];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item == tbiStartEndTime) {
        tabMain.selectedItem = tbiTimePerDay;
        [self cancel:self];
    }
}

- (void)setDelegate:(id)val{
	delegate = val;
}

- (void) reloadTimesheet:(NSString *)sDate{
    //[chartView reloadTimesheet:sDate];
}

/*- (void)closeView{
    [chartView cancel:nil];
	[self.view removeFromSuperview];
}

- (IBAction) cancel:(id)sender;{
	[self closeView];
}*/

- (void) foundXMLElement: (NSObject*)sourceXmlReader:(NSString*)sElementName:(NSMutableString*)sValue{
    /*UIAlertView *alert = [[UIAlertView alloc] 
     initWithTitle:@"XMLReader Test"
     message:[NSString stringWithFormat:@"FOUND Element %@:%@", sElementName, sValue] 
     delegate:self  
     cancelButtonTitle:@"OK" 
     otherButtonTitles:nil];*/
    if ([sElementName isEqualToString:@"workStart"]) {
         entry = [[MinMaxDateEntry alloc] init];
         entry.sMin = [NSString stringWithFormat:@"%@", sValue];
        if([entry.sMin isEqualToString:@"-1"])
            bErrorSessionId = TRUE;
     }else if ([sElementName isEqualToString:@"workEnd"]) {
         entry.sMax = [NSString stringWithFormat:@"%@", sValue];
     }else if ([sElementName isEqualToString:@"workDate"]) {
         entry.sDate = [NSString stringWithFormat:@"%@", sValue];
     }else if ([sElementName isEqualToString:@"minHour"]) {
         entry.nMinHour = [sValue intValue];
     }else if ([sElementName isEqualToString:@"minMinute"]) {
         entry.nMinMinute = [sValue intValue];
     }else if ([sElementName isEqualToString:@"minSecond"]) {
         entry.nMinSecond = [sValue intValue];
     }else if ([sElementName isEqualToString:@"maxHour"]) {
         entry.nMaxHour = [sValue intValue];
     }else if ([sElementName isEqualToString:@"maxMinute"]) {
         entry.nMaxMinute = [sValue intValue];
     }else if ([sElementName isEqualToString:@"maxSecond"]) {
         entry.nMaxSecond = [sValue intValue];
     }else if ([sElementName isEqualToString:@"iduser"]) {
         //entry. = [NSString stringWithFormat:@"%@", sValue];
         //[arrMinMax addObject:entry];
     }else if ([sElementName isEqualToString:@"workTime"]) {
         entry.sWorkTime = [NSString stringWithFormat:@"%@", sValue];
         [arrMinMax addObject:entry];
     }
}

- (void) errorSOAPRequest: (NSObject*)requester:(NSError*)error{
    
    [actMain stopAnimating];
    
    [CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @"") message:[error description]];
    /*UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"Connection Error!"
                          message:[NSString stringWithFormat:@"%@", [error description]] 
                          delegate:self  
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles:nil];
    [alert show];*/
    //[alert release];
    
}

- (void) gotSOAPAnswere:(NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data{   
    
    /*UIAlertView *alert = [[UIAlertView alloc] 
     initWithTitle:@"Connection OK!"
     message:[NSString stringWithFormat:@"%@", sXMLAnswere] 
     delegate:self  
     cancelButtonTitle:@"OK" 
     otherButtonTitles:nil];
     [alert show];
     [alert release];*/
    
    arrMinMax = [[NSMutableArray alloc] init];
    
    NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
    [aElementsToFind addObject:@"workStart"];
    [aElementsToFind addObject:@"workEnd"];
    [aElementsToFind addObject:@"workDate"];
    [aElementsToFind addObject:@"minHour"];
    [aElementsToFind addObject:@"minMinute"];
    [aElementsToFind addObject:@"minSecond"];
    [aElementsToFind addObject:@"maxHour"];
    [aElementsToFind addObject:@"maxMinute"];
    [aElementsToFind addObject:@"maxSecond"];
    [aElementsToFind addObject:@"iduser"];
    [aElementsToFind addObject:@"workTime"];
    
    xmlReader = [[XMLReader alloc] init];
    xmlReader.delegate = self;
    
    [xmlReader parseForElements:aElementsToFind data:srTimePerDay.webData];
    if (bErrorSessionId) {
        [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @"") message:NSLocalizedString(@"msgSessionError", @"")];
        [actMain stopAnimating];  
        return;
    }
    
    [tbvTimePerDay reloadData];
    
    [actMain stopAnimating]; 
}

- (void)reloadTimePerDayData{
    
	[actMain startAnimating];
    
	//NSDateComponents *components = [[NSDateComponents alloc] init];
	/*NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
     NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
     NSDateComponents *components = [gregorian components:unitFlags fromDate:self.dSelectedMonth];
     
     components.month = components.month + 1;
     NSDate *dTo = [gregorian dateFromComponents:components];
     */
	/*NSDateFormatter * df = [[NSDateFormatter alloc] init];
     [df setDateFormat:@"MM.dd.yyyy 00:00:00"];
     [df setTimeZone:[NSTimeZone systemTimeZone]];
     [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
     NSString *sDateTo = [df stringFromDate:dTo];	
     [df release];
     
     
     //NSDate *date = [gregorian dateFromComponents:components];
     NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
     [df2 setDateFormat:@"MM.dd.yyyy 00:00:00"];
     [df2 setTimeZone:[NSTimeZone systemTimeZone]];
     [df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
     NSString *sDateFrom = [df2 stringFromDate:self.dSelectedMonth];	
     [df2 release];
     */
    /*UIAlertView *alert = [[UIAlertView alloc] 
     initWithTitle:@"Connection OK"
     message:[NSString stringWithFormat:@"%@ - %@", sDateFrom, sDateTo] 
     delegate:self  
     cancelButtonTitle:@"OK" 
     otherButtonTitles:nil];
     [alert show];
     [alert release];*/
    
    /*OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
     //StartViewController S*daSView = (StartViewController*)startViewController;
     [mutable setObject: [NSString stringWithFormat:@"%d", 3]  forKey: @"iduser" ];
     [mutable setObject: @"2012-05-01" forKey: @"date" ];
     [mutable setObject: @"2012-05-31" forKey: @"dateTo" ];
     */
    NSDateFormatter * df3 = [[NSDateFormatter alloc] init];
	[df3 setDateFormat:@"yyyy-MM"];
	[df3 setTimeZone:[NSTimeZone systemTimeZone]];
	[df3 setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSString *sDateFrom2 = [df3 stringFromDate:dSelectedMonth];	
	//[df3 release];
    
    OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
    //StartViewController *daSView = (StartViewController*)startViewController;
    [mutable setObject: [NSString stringWithFormat:@"%@", la.sSessionID] forKey: @"idsession" ];
    //[mutable setObject: [NSString stringWithFormat:@"%@", @""] forKey: @"idsession" ];
    [mutable setObject: [NSString stringWithFormat:@"%d", la.nUserID] forKey: @"iduser" ];
    [mutable setObject: [NSString stringWithFormat:@"%@-01", sDateFrom2] forKey: @"date" ];
    
    //NSDate *today = [NSDate date]; //Get a date object for today's date
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit 
                           inUnit:NSMonthCalendarUnit 
                          forDate:dSelectedMonth];
    
    [mutable setObject: [NSString stringWithFormat:@"%@-%d", sDateFrom2, days.length] forKey: @"dateTo" ];
    
    srTimePerDay = [[SOAPRequester alloc] init];
    srTimePerDay.delegate = self;
    [srTimePerDay sendSOAPRequest:cfgMgr message:@"GetWorkStartEnd" od:mutable];
}


-(IBAction)pickerShow{
	//[txtDescription resignFirstResponder];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 200);
	pickerView.transform = transform;
	[self.view addSubview:pickerView];
	[UIView commitAnimations];	
	
	//NSDate *dNew = dSelectedMonth;
	NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
	[df2 setDateFormat:@"M"];
	[df2 setTimeZone:[NSTimeZone systemTimeZone]];
	[df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSString *sMonth = [df2 stringFromDate:dSelectedMonth];
	int nMonth = [sMonth intValue];
	nMonth--;
	//[df2 release];
	[monthYearPicker selectRow:nMonth inComponent:0 animated:YES];
	
	NSDateFormatter * df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy"];
	[df setTimeZone:[NSTimeZone systemTimeZone]];
	[df setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSString *sYear = [df stringFromDate:dSelectedMonth];
	int nYear = [sYear intValue];
    
	//[df release];
	
	NSDateFormatter * df3 = [[NSDateFormatter alloc] init];
	[df3 setDateFormat:@"yyyy"];
	[df3 setTimeZone:[NSTimeZone systemTimeZone]];
	[df3 setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSString *sThisYear = [df3 stringFromDate:[[NSDate alloc] init]];
	int nThisYear = [sThisYear intValue];
	//[df3 release];
	
	int nYRow = 5 - (nThisYear - nYear);
	[monthYearPicker selectRow:nYRow inComponent:1 animated:YES];	
	
}	

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { 
    //final part of the UIPickerView, what happens when a row is selected.
	//txtMandate.text = ((NSString*)[arrMandates objectAtIndex:[mandatePicker selectedRowInComponent:0]]);
    
	int nMonth = [monthYearPicker selectedRowInComponent:0];
	int nYear = [monthYearPicker selectedRowInComponent:1];
	
	NSDate *dThisYear = [[NSDate alloc] init];
	
	NSDateFormatter * df3 = [[NSDateFormatter alloc] init];
	[df3 setDateFormat:@"yyyy"];
	[df3 setTimeZone:[NSTimeZone systemTimeZone]];
	[df3 setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSString *sYear = [df3 stringFromDate:dThisYear];
	//[df3 release];
	int nThisYear = [sYear intValue];
	
	nYear = nThisYear - 5 + nYear;
	/*
     NSDateFormatter * df = [[NSDateFormatter alloc] init];
     [df setDateFormat:@"yyyy-MM-dd"];
     [df setTimeZone:[NSTimeZone systemTimeZone]];
     [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
     
     NSString *sTmp = [NSString stringWithFormat:@"%d-%d-01 00:00:01", nYear, (nMonth+1)];
     NSDate *theDateFrom = [df dateFromString:sTmp];
     [df release];
     self.dSelectedMonth = theDateFrom;
     //dSelectedMonth = theDateFrom;
     
     NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
     [df2 setDateFormat:@"MMMM yyyy"];
     [df2 setTimeZone:[NSTimeZone systemTimeZone]];
     [df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
     NSString *sMonth = [df2 stringFromDate:theDateFrom];
     //NSLog(@"date: %@", theDateFrom);
     
     [df2 release];
     */
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
	[df setDateFormat:@"yyyy-MM-dd"];
	[df setTimeZone:[NSTimeZone systemTimeZone]];
	[df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSString *sTmp = [NSString stringWithFormat:@"%d-%@%d-01", nYear, (nMonth+1 > 9 ? @"" : @"0"), nMonth+1];
    NSDate *dDate = [df dateFromString:sTmp];
    
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
	[df2 setDateFormat:@"MMMM yyyy"];
	[df2 setTimeZone:[NSTimeZone systemTimeZone]];
	[df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSString *sMonth = [df2 stringFromDate:dDate];
    
    dSelectedMonth = [dDate copy];
	[cmdSelectMonth setTitle:sMonth forState:UIControlStateNormal];
	//NSString *sUserNMonth = [NSString stringWithFormat:@"%@ - %@", self.sUserName, sMonth];
	//lblTimePerDayTitle.text = sUserNMonth; 
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { // This method needs to be used. It asks how many columns will be used in the UIPickerView
	return 2; // We only need one column so we will return 1.
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	if(component == 0)
		return 12;
	else {
		return 6;
	}
    
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	if(component == 0){
		NSDateFormatter * df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd"];
		[df setTimeZone:[NSTimeZone systemTimeZone]];
		[df setFormatterBehavior:NSDateFormatterBehaviorDefault];
		
		NSString *sTmp = [NSString stringWithFormat:@"2011-%d-01", (row+1)];
		NSDate *theDateFrom = [df dateFromString:sTmp];
		
		NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
		[df2 setDateFormat:@"MMMM"];
		[df2 setTimeZone:[NSTimeZone systemTimeZone]];
		[df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSString *sMonth = [df2 stringFromDate:theDateFrom];
		//NSLog(@"date: %@", theDateFrom);
		//[df release];
		//[df2 release];
		return sMonth;
		
	}else if(component == 1){
		NSDate *dThisYear = [[NSDate alloc] init];
		
		NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
		[df2 setDateFormat:@"yyyy"];
		[df2 setTimeZone:[NSTimeZone systemTimeZone]];
		[df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
		NSString *sYear = [df2 stringFromDate:dThisYear];
		//[df2 release];
		int nYear = [sYear intValue];
		nYear = nYear - 5 + row;
		
		return [NSString stringWithFormat:@"%d", nYear];
	}
	else
		return @"2011";
}

-(IBAction)done{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerView.transform = transform;
	[UIView commitAnimations];
	//BOOL bShowSec = FALSE;
	//if(timePerDayView.hidden == FALSE)
	//	bShowSec = TRUE;
    
	//[self reloadMinMaxData];
	[self reloadTimePerDayData];
	/*if(bShowSec){
     timePerDayView.hidden = FALSE;
     chartView.hidden = TRUE;
     }*/
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadViewElements];
}

- (void) reloadViewElements{
    
    lblMonthTitle.text = @"";
    lblMonthTotal.text = @"";
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerView.transform = transform;
	
	//[self.view addSubview:pickerView];
	[UIView commitAnimations];
    // Do any additional setup after loading the view from its nib.
    //dSelectedMonth = [[NSDate alloc] init];
    
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:unitFlags fromDate:dSelectedMonth];
	
	//[components setWeekday:2]; // Monday
	//[components setWeekdayOrdinal:1]; // The first day in the month
	//[components setMonth:5]; // May
	//[components setYear:2008];
	[components setDay:1];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:1];
	
	dSelectedMonth = [gregorian dateFromComponents:components];
    
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
	[df2 setDateFormat:@"MMMM yyyy"];
	[df2 setTimeZone:[NSTimeZone systemTimeZone]];
	[df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSString *sMonth = [df2 stringFromDate:dSelectedMonth];
	//[df2 release];
	
	[cmdSelectMonth setTitle:sMonth forState:UIControlStateNormal];
	//[self setMonthToCmd];
    
    //[tbvTimePerDay reloadData];//
    tabMain.selectedItem = tbiTimePerDay;
    if (arrMinMax != nil) {
        [tbvTimePerDay reloadData];
    }else {
        [self reloadTimePerDayData];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Table view methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	nHourMonthTot = 0;
    nMinMonthTot = 0;
    
    if(arrMinMax.count == 0){
        return 0;
    }else{
        arrWeeks = [[NSMutableArray alloc] init];
        arrWeekTotals = [[NSMutableArray alloc] init];
        int nWeeks = 0;
        NSString* sWeek = @"";
        
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM"];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
        [df2 setDateFormat:@"yyyy-MM-dd"];
        [df2 setTimeZone:[NSTimeZone systemTimeZone]];
        [df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        NSDateFormatter * df3 = [[NSDateFormatter alloc] init];
        [df3 setDateFormat:@"w"];
        [df3 setTimeZone:[NSTimeZone systemTimeZone]];
        [df3 setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        int nHourTot = 0;        
        int nMinTot = 0;
        for (int j = 0; j < arrMinMax.count; j++) {
            MinMaxDateEntry* daEntry = [arrMinMax objectAtIndex:j];
            
            if(![sWeek isEqualToString:[df3 stringFromDate:[df2 dateFromString:daEntry.sDate]]]){
                nWeeks++;
                sWeek = [df3 stringFromDate:[df2 dateFromString:daEntry.sDate]];
                [arrWeeks addObject:[sWeek copy]];
                if(nWeeks > 1)
                    [arrWeekTotals addObject:[NSString stringWithFormat:@"%@%d:%@%d", (nHourTot > 9 ? @"" : @"0"), nHourTot, (nMinTot > 9 ? @"" : @"0"), nMinTot]];
                nHourTot = 0;
                nMinTot = 0;
            }
            nHourTot += (daEntry.nMaxHour - daEntry.nMinHour); 
            nMinTot += (daEntry.nMaxMinute - daEntry.nMinMinute);
            nHourMonthTot += (daEntry.nMaxHour - daEntry.nMinHour);
            nMinMonthTot += (daEntry.nMaxMinute - daEntry.nMinMinute);
            
        }
        [arrWeekTotals addObject:[NSString stringWithFormat:@"%@%d:%@%d", (nHourTot > 9 ? @"" : @"0"), nHourTot, (nMinTot > 9 ? @"" : @"0"), nMinTot]];
        lblMonthTotal.text = [NSString stringWithFormat:@"   Month Total: %@%d:%@%d h", (nHourMonthTot > 9 ? @"" : @"0"), nHourMonthTot, (nMinMonthTot > 9 ? @"" : @"0"), nMinMonthTot];
        lblMonthTitle.text = [NSString stringWithFormat:@"   %@: %@%d:%@%d h", la.sUsername, (nHourMonthTot > 9 ? @"" : @"0"), nHourMonthTot, (nMinMonthTot > 9 ? @"" : @"0"), nMinMonthTot];

        return nWeeks;
        
    }
}


//Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(arrMinMax.count == 0){
        return 0;
    }else{
        int nWeeks = 0;
        NSString* sWeek = @"";
        int nDaysInWeek = 0;
        
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM"];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
        [df2 setDateFormat:@"yyyy-MM-dd"];
        [df2 setTimeZone:[NSTimeZone systemTimeZone]];
        [df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        NSDateFormatter * df3 = [[NSDateFormatter alloc] init];
        [df3 setDateFormat:@"w"];
        [df3 setTimeZone:[NSTimeZone systemTimeZone]];
        [df3 setFormatterBehavior:NSDateFormatterBehaviorDefault];
        
        for (int j = 0; j < arrMinMax.count; j++) {
            MinMaxDateEntry* daEntry = [arrMinMax objectAtIndex:j];
            if(![sWeek isEqualToString:[df3 stringFromDate:[df2 dateFromString:daEntry.sDate]]]){
                sWeek = [df3 stringFromDate:[df2 dateFromString:daEntry.sDate]];
                if(nWeeks == section){
                    int nCount = 0; 
                    nCount = nCount;
                    for (int y = j; y < arrMinMax.count; y++) {
                        MinMaxDateEntry* daEntry2 = [arrMinMax objectAtIndex:y];
                        
                        if(![sWeek isEqualToString:[df3 stringFromDate:[df2 dateFromString:daEntry2.sDate]]]){
                            break;
                        }
                        nDaysInWeek++;
                        nCount++;
                    }
                    return nDaysInWeek;
                    //break;
                }
                nWeeks++;
            }
        }
        
        return nDaysInWeek;
    }
}

//Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init]; 
    
    NSDateFormatter * df4 = [[NSDateFormatter alloc] init];
	//[df4 setDateFormat:@"EEE (e/w) dd.MM.\t\tHH:mm:ss"];
    [df4 setDateFormat:@"EEE dd.MM.\t\tHH:mm:ss"];
	[df4 setTimeZone:[NSTimeZone systemTimeZone]];
	[df4 setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    
    NSDateFormatter * df7 = [[NSDateFormatter alloc] init];
	//[df4 setDateFormat:@"EEE (e/w) dd.MM.\t\tHH:mm:ss"];
    [df7 setDateFormat:@"EEE dd.MM."];
	[df7 setTimeZone:[NSTimeZone systemTimeZone]];
	[df7 setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDateFormatter * df8 = [[NSDateFormatter alloc] init];
	//[df4 setDateFormat:@"EEE (e/w) dd.MM.\t\tHH:mm:ss"];
    [df8 setDateFormat:(cfgMgr.bShowSeconds ? @"HH:mm:ss" : @"HH:mm")];
	[df8 setTimeZone:[NSTimeZone systemTimeZone]];
	[df8 setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDateFormatter * df9 = [[NSDateFormatter alloc] init];
    [df9 setDateFormat:@"dd.MM.yyyy"];
    [df9 setTimeZone:[NSTimeZone systemTimeZone]];
    [df9 setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDateFormatter * df5 = [[NSDateFormatter alloc] init];
	[df5 setDateFormat:@"dd. MMMM yyyy"];
	[df5 setTimeZone:[NSTimeZone systemTimeZone]];
	[df5 setFormatterBehavior:NSDateFormatterBehaviorDefault];
	
    
    int nWeeks = 0;
    NSString* sWeek = @"";
    
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:@"yyyy-MM-dd"];
    [df2 setTimeZone:[NSTimeZone systemTimeZone]];
    [df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDateFormatter * df6 = [[NSDateFormatter alloc] init];
    [df6 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df6 setTimeZone:[NSTimeZone systemTimeZone]];
    [df6 setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    NSDateFormatter * df3 = [[NSDateFormatter alloc] init];
    [df3 setDateFormat:@"w"];
    [df3 setTimeZone:[NSTimeZone systemTimeZone]];
    [df3 setFormatterBehavior:NSDateFormatterBehaviorDefault];
    
    for (int j = 0; j < arrMinMax.count; j++) {
        MinMaxDateEntry* daEntry = [arrMinMax objectAtIndex:j];
        
        if(![sWeek isEqualToString:[df3 stringFromDate:[df2 dateFromString:daEntry.sDate]]]){
            sWeek = [df3 stringFromDate:[df2 dateFromString:daEntry.sDate]];
            if(nWeeks == indexPath.section){
                int nCount = 0; 
                for (int y = j; y < arrMinMax.count; y++) {
                    if(nCount == indexPath.row){
                        MinMaxDateEntry* de = [arrMinMax objectAtIndex:y];
                        NSDate *dDay;
                        
                        int nHours = 0, nMinutes = 0, nSeconds = 0;
                        nHours = de.nMaxHour - de.nMinHour;
                        
                        nMinutes = de.nMaxMinute - de.nMinMinute;
                        if(nMinutes < 0){
                            nMinutes = (60 - de.nMinMinute) + de.nMaxMinute;
                            nHours--;
                        }
                        nSeconds = de.nMaxSecond - de.nMinSecond;
                        if(nSeconds < 0){
                            nSeconds = (60 - de.nMinSecond) + de.nMaxSecond;
                            nMinutes--;
                        }
                        NSString *sWorkTime = 
                        [NSString stringWithFormat:@"%@%d:%@%d:%@%d", 
                         (nHours > 9 ? @"": @"0"), 
                         (nHours),
                         (nMinutes> 9 ? @"": @"0"), 
                         (nMinutes),
                         (nSeconds > 9 ? @"": @"0") , 
                         (nSeconds)];
                        
                        dDay = [df6 dateFromString:[NSString stringWithFormat:@"%@ %@", de.sDate, sWorkTime]];
                        //cell.
                        cell.textLabel.text = [df4 stringFromDate:dDay];
                        //return cell;
                        /////
                        static NSString *CellIdentifier = @"TimePerDayCustomCell";
                        TimePerDayCustomCell*  cell2 = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (cell2 == nil) {
                            // Load the top-level objects from the custom cell XIB.
                            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TimePerDayCustomCell" owner:self options:nil];
                            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
                            cell2 = [topLevelObjects objectAtIndex:0];
                        }
                        //cell2.timePerDayView = self;
                        cell2.sDate = [df9 stringFromDate:dDay];
                        cell2.lblTime.text = [df7 stringFromDate:dDay];
                        cell2.lblText.text = [df8 stringFromDate:dDay];
                        [cell2 setDelegate:self];
                        return cell2;
                    }
                    nCount++;
                }
            }
            nWeeks++;
        }
    }
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    //if(arrWeeks == nil)
    //    return [NSString stringWithFormat:@"Week %d", arrWeeks.count];
    //else
    return [NSString stringWithFormat:@"Week (%@): %@h",[arrWeeks objectAtIndex:section], [arrWeekTotals objectAtIndex:section]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


/*
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
    tabMain.selectedItem = tbiTimePerDay;
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
}*/

@end
