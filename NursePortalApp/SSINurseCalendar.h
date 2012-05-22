//
//  SSINurseCalendar.h
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSICalendarTableView.h"

@interface SSINurseCalendar : SSICalendarVC <UITableViewDelegate, UITableViewDataSource>
{
    
	NSMutableArray *dataArray; 
	NSMutableDictionary *dataDictionary;
}

@property (retain,nonatomic) NSMutableArray *dataArray;
@property (retain,nonatomic) NSMutableDictionary *dataDictionary;
@property (strong,nonatomic) UITableView *tableView;


- (void) updateTableOffset:(BOOL)animated;
- (void) generateRandomDataForStartDate:(NSDate*)start endDate:(NSDate*)end;

@end
