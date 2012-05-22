//
//  SSICalendarVC.m
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSICalendarVC.h"

#import "SSICalendarView.h"



@interface SSICalendarVC () {
	BOOL _sundayFirst;
}

@end

@implementation SSICalendarVC
@synthesize monthView = _monthView;

- (id) init{
	return [self initWithSunday:YES];
}
- (id) initWithSunday:(BOOL)sundayFirst{
	if(!(self = [super init])) return nil;
	_sundayFirst = sundayFirst;
	return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}

- (void) viewDidUnload {
	self.monthView = nil;
}


- (void) loadView{
	[super loadView];
	
	_monthView = [[SSICalendarView alloc] initWithSundayAsFirst:_sundayFirst calendarStartDate:nil calendarEndDate:nil
                                                 scheduleDictionary:nil];
	_monthView.delegate = self;
	_monthView.dataSource = self;
	[self.view addSubview:_monthView];
	[_monthView reload];
	
}


- (NSArray*) calendarMonthView:(SSICalendarView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	return nil;
}
@end

