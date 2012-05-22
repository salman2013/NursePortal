//
//  SSICalendarTableView.h
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSICalendarVC.h"

@interface SSICalendarTableView : SSICalendarVC <UITableViewDelegate, UITableViewDataSource>


@property (strong,nonatomic) UITableView *tableView;


- (void) updateTableOffset:(BOOL)animated;

@end
