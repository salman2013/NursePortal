//
//  SSICalendarVC.h
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSICalendarView.h"

//@class  SSICalenderView;
@protocol SSICalendarViewDelegate,SSICalendarViewDataSource;


@interface SSICalendarVC : UIViewController <SSICalendarViewDelegate,SSICalendarViewDataSource> 


- (id) init;


- (id) initWithSunday:(BOOL)sundayFirst;



@property (strong,nonatomic) SSICalendarView *monthView;
@end
