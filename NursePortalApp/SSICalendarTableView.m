//
//  SSICalendarTableView.m
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSICalendarTableView.h"

#import "SSICalendarVC.h"
#import "NSDate+SSIDate.h"

@implementation SSICalendarTableView
@synthesize tableView = _tableView;

- (void) viewDidUnload {
	self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	self.tableView = nil;
}

- (void) loadView{
	[super loadView];
	self.tableView.backgroundColor = [UIColor whiteColor];
	
	float y,height;
	y = self.monthView.frame.origin.y + self.monthView.frame.size.height;
	height = self.view.frame.size.height - y;
    
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, height) style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	_tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:_tableView];
	[self.view sendSubviewToBack:_tableView];
}



#pragma mark - TableView Delegate & Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 0;	
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
	
    return cell;
}

#pragma mark - Month View Delegate & Data Source
- (void) calendarMonthView:(SSICalendarView*)monthView didSelectDate:(NSDate*)d{
}
- (void) calendarMonthView:(SSICalendarView*)monthView monthDidChange:(NSDate*)month animated:(BOOL)animated{
	[self updateTableOffset:animated];
}

- (void) updateTableOffset:(BOOL)animated{
	
	
	if(animated){
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.4];
		[UIView setAnimationDelay:0.1];
	}
    
	
	float y = self.monthView.frame.origin.y + self.monthView.frame.size.height;
	self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, y, self.tableView.frame.size.width, self.view.frame.size.height - y );
	
	if(animated) [UIView commitAnimations];
}
@end
