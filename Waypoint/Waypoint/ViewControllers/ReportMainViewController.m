//
//  ReportMainViewController.m
//  Waypoint
//
//  Created by Kim David Hauser on 03.07.12.
//  Copyright (c) 2012 DaVe inc. All rights reserved.
//

#import "ReportMainViewController.h"
#import "ReportTimePerDayViewController.h"
#import "CommonFunctions.h"

@interface ReportMainViewController ()

@end

@implementation ReportMainViewController

@synthesize cfgMgr;
@synthesize la;
@synthesize dSelectedMonth;

- (void)setDelegate:(id)val{
	delegate = val;
}

- (void)showTimeSheetForDay:(NSString*)sDate{
    //[CommonFunctions showMessageBox:@"The date is:" :sDate];
    if(delegate != nil){
        if ([delegate respondsToSelector:@selector(showTimeSheetForDay:)]) {
            [delegate showTimeSheetForDay:sDate];
            [reportTimePerDay dismissModalViewControllerAnimated:NO];
            [self dismissModalViewControllerAnimated:YES];            
        }
    }
}

- (void)closeReportTimePerDayView{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)cancel:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item == tbiTimePerDay) {
        if (reportTimePerDay == nil) {
            reportTimePerDay = [[ReportTimePerDayViewController alloc] init];
        }
        reportTimePerDay.cfgMgr = cfgMgr;
        reportTimePerDay.la = la;
        reportTimePerDay.dSelectedMonth = dSelectedMonth;
        [reportTimePerDay setArrMinMax:arrMinMax];
        [reportTimePerDay setDelegate:self];
        [self presentModalViewController:reportTimePerDay animated:NO];
        [reportTimePerDay reloadViewElements];
        tabMain.selectedItem = tbiStartEndTime;
    }
}

-(IBAction)pickerShow{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 200);
	pickerView.transform = transform;
	[self.view addSubview:pickerView];
	[UIView commitAnimations];	
	
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
	NSString *sYear = [df stringFromDate:self.dSelectedMonth];
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
	//int n = 0;
	
}
-(IBAction)done{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerView.transform = transform;
	[UIView commitAnimations];
	[self reloadMinMaxData];
}

#pragma mark - PickerView delegates

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

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { // And now the final part of the UIPickerView, what happens when a row is selected.
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
	NSString *sUserNMonth = [NSString stringWithFormat:@"%@ - %@", la.sUsername, sMonth];
	lblTimePerDayTitle.text = sUserNMonth; 
}

- (void) foundXMLElement: (NSObject*)sourceXmlReader:(NSString*)sElementName:(NSMutableString*)sValue{
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
    cmdSelectMonth.enabled = YES;
    [CommonFunctions showMessageBox:NSLocalizedString(@"titConncetionError", @""): [error description]];    
}

- (void) gotSOAPAnswere:(NSObject*)requester:(NSString*)sXMLAnswere:(NSData*)data{   
    
    NSLog(@"%@", sXMLAnswere);
    arrMinMax = [[NSMutableArray alloc] init];
    
    NSMutableArray* aElementsToFind = [[NSMutableArray alloc] init];
    [aElementsToFind addObject:@"workStart"];
    [aElementsToFind addObject:@"workEnd"];
    [aElementsToFind addObject:@"workDate"];
    [aElementsToFind addObject:@"minHour"];
    [aElementsToFind addObject:@"minMinute"];
    [aElementsToFind addObject:@"maxHour"];
    [aElementsToFind addObject:@"maxMinute"];
    [aElementsToFind addObject:@"iduser"];
    [aElementsToFind addObject:@"workTime"];    
    
    xmlReader = [[XMLReader alloc] init];
    xmlReader.delegate = self;
    
    [xmlReader parseForElements:aElementsToFind:srMinMax.webData];
    if (bErrorSessionId) {
        [CommonFunctions showMessageBox:NSLocalizedString(@"titSessionError", @""):NSLocalizedString(@"msgSessionError", @"")];
        [actMain stopAnimating];
        cmdSelectMonth.enabled = YES;
        return;
    }
    [self setupChart];
    [actMain stopAnimating]; 
    cmdSelectMonth.enabled = YES;
}

- (void)setMonthToCmd{
	
	NSDateFormatter * df2 = [[NSDateFormatter alloc] init];
	[df2 setDateFormat:@"MMMM yyyy"];
	[df2 setTimeZone:[NSTimeZone systemTimeZone]];
	[df2 setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSString *sMonth = [df2 stringFromDate:dSelectedMonth]; 
    
	[cmdSelectMonth setTitle:sMonth forState:UIControlStateNormal];
	
}

- (void)setupChart{
	
	CGRect rect = [[UIScreen mainScreen] bounds];
	rect = [chartView bounds];
	rect.origin.y = 40;
	//rect.origin.x = 120;
	//rect.size.height -= 40;
	graphView = [[S7GraphView alloc] initWithFrame:rect];
	//self.view = self.graphView;
	chartView = graphView;
	graphView.dataSource = self;
	//[self.graphView.drawRect:rect];
	[self.view addSubview:chartView];

	graphView.fOverrideMax = 24.0f;
	
	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:0];
	[numberFormatter setMaximumFractionDigits:0];
	
	graphView.yValuesFormatter = numberFormatter;
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	//[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	
	graphView.xValuesFormatter = dateFormatter;
	
	graphView.backgroundColor = [UIColor blackColor];
	
    graphView.drawAxisX = YES;
	graphView.drawAxisY = YES;
	graphView.drawGridX = YES;
	graphView.drawGridY = YES;
	
	graphView.xValuesColor = [UIColor whiteColor];
	graphView.yValuesColor = [UIColor whiteColor];
	
	graphView.gridXColor = [UIColor whiteColor];
	graphView.gridYColor = [UIColor whiteColor]; //grayColor
	
	graphView.drawInfo = YES;
	graphView.info = [NSString stringWithFormat:NSLocalizedString(@"lblReportStartEnd", @""), la.sUsername];
	graphView.infoColor = [UIColor whiteColor];
	
	//[super viewDidLoad];
	
	S7GraphBand *graphBnd = [[S7GraphBand alloc] init];
	graphBnd.nStop = 90;
	graphBnd.nStart = 130;
    graphBnd.nStart2 = 7.25;
    graphBnd.nStop2 = 9.5;
	graphBnd.bandColor = [UIColor colorWithRed:150 green:150 blue:1501 alpha:1.0f].CGColor;
	S7GraphBand *graphBnd2 = [[S7GraphBand alloc] init];
	graphBnd2.nStop = 230;
	graphBnd2.nStart = 270;
    graphBnd2.nStart2 = 16.5;
    graphBnd2.nStop2 = 18.75;
	graphBnd2.bandColor = [UIColor colorWithRed:150 green:150 blue:1501 alpha:1.0f].CGColor;
	graphView.graphBand = graphBnd;
	//[graphView.arlGraphBands addObject:graphBnd];
	//[graphView.arlGraphBands addObject:graphBnd2];	
    
	//When you need to update the data, make this call:
	//[self.graphView reloadData];
	
}

#pragma mark protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	/* Return the number of plots you are going to have in the view. 1+ */
	return 2;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[arrMinMax count]];
    int i = 0;
    for ( i = 0 ; i < [arrMinMax count] ; i ++ ) {
		MinMaxDateEntry *daEntry = (MinMaxDateEntry*)[arrMinMax objectAtIndex:i];
        [array addObject:[NSString stringWithFormat: @"%@", daEntry.sDate]];
        
	}
	return array;
}

- (S7GraphBand *)graphView:(S7GraphView *)graphView getGraphBands:(NSUInteger)plotIndex{
	S7GraphBand *graphBnd = [[S7GraphBand alloc] init];
	graphBnd.nStop = 60;
	graphBnd.nStart = 80;
	graphBnd.bandColor = [UIColor colorWithRed:150 green:150 blue:1501 alpha:1.0f].CGColor;
	//graphView.graphBand = graphBnd;
	return graphBnd;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
	/* Return the values for a specific graph. Each plot is meant to have equal number of points.
	 And this amount should be equal to the amount of elements you return from graphViewXValues: method. */
	//NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:101];
	NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[arrMinMax count]];
	switch (plotIndex) {
		default:
		case 0:
            for ( int i = 0 ; i < [arrMinMax count] ; i ++ ) {
				MinMaxDateEntry *daEntry = (MinMaxDateEntry*)[arrMinMax objectAtIndex:i];
                double dTmp = 1.0 / 60 * daEntry.nMinMinute;
                [array addObject:[NSNumber numberWithDouble:(dTmp + daEntry.nMinHour)]];	                
			}
			break;
		case 1:
            for ( int i = 0 ; i < [arrMinMax count] ; i ++ ) {
                MinMaxDateEntry *daEntry = (MinMaxDateEntry*)[arrMinMax objectAtIndex:i];
                double dTmp = 1.0 / 60 * daEntry.nMaxMinute;
                [array addObject:[NSNumber numberWithDouble:(dTmp + daEntry.nMaxHour)]];
			}
			break;
	}
	
	return array;
}

- (void)reloadMinMaxData{
    
	[actMain startAnimating];
    cmdSelectMonth.enabled = NO;
    
	//NSDateComponents *components = [[NSDateComponents alloc] init];
	NSCalendarUnit unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:unitFlags fromDate:dSelectedMonth];
	
	components.month = components.month + 1;
    
    NSDateFormatter * df3 = [[NSDateFormatter alloc] init];
	[df3 setDateFormat:@"yyyy-MM"];
	[df3 setTimeZone:[NSTimeZone systemTimeZone]];
	[df3 setFormatterBehavior:NSDateFormatterBehaviorDefault];
	NSString *sDateFrom2 = [df3 stringFromDate:dSelectedMonth];	
    
    OrderedDictionary *mutable = [[OrderedDictionary alloc] init];
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
    //[mutable setObject: @"2012-05-31" forKey: @"dateTo" ];
    
    srMinMax = [[SOAPRequester alloc] init];
    srMinMax.delegate = self;
    [srMinMax sendSOAPRequest:cfgMgr:@"GetWorkStartEnd":mutable];
    
    //[mutable release];
    
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
   	graphView.fOverrideMax = 24;
	[self setMonthToCmd];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	pickerView.transform = transform;
	[UIView commitAnimations];
	arrMinMax = [[NSMutableArray alloc] initWithCapacity:0];
	[self reloadMinMaxData];
	nViewIdx = 0;
    tabMain.selectedItem = tbiStartEndTime;
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
