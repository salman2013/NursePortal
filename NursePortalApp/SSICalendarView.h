//
//  SSICalendarView.h
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSICalendarControl;
@protocol SSICalendarViewDelegate, SSICalendarViewDataSource;

@interface SSICalendarView : UIView
{
   SSICalendarControl *currentTile,*oldTile;
	UIButton *leftArrow, *rightArrow;
	UIImageView *topBackground, *shadow;
	UILabel *monthYear;
	UIScrollView *tileBox;
	BOOL sunday;
    NSString *strBundlePath;
    
    int totalWeeks;
    int schViewIndex;
    int schWeekIndex;
    BOOL isScheduleInWeekMode;
}


@property (strong,nonatomic) NSArray *schWeeks;
@property (nonatomic,retain) NSDictionary *calScheduals;


- (id) initWithSundayAsFirst:(BOOL)sunday calendarStartDate:(NSDate *) calStartDate calendarEndDate:(NSDate *)calEndDate
          scheduleDictionary:(NSDictionary *) schDictionary; // or Monday

@property (nonatomic,assign) id <SSICalendarViewDelegate> delegate;


@property (nonatomic,assign) id <SSICalendarViewDataSource> dataSource;


- (NSDate*) dateSelected;


- (NSDate*) monthDate;

- (void) selectDate:(NSDate*)date;


- (void) reload;

@end

//*************** DELEGATE *******************

@protocol SSICalendarViewDelegate <NSObject>
@optional


- (void) calendarMonthView:(SSICalendarView*)monthView didSelectDate:(NSDate*)date;


- (BOOL) calendarMonthView:(SSICalendarView*)monthView monthShouldChange:(NSDate*)month animated:(BOOL)animated;


- (void) calendarMonthView:(SSICalendarView*)monthView monthWillChange:(NSDate*)month animated:(BOOL)animated;

- (void) calendarMonthView:(SSICalendarView*)monthView monthDidChange:(NSDate*)month animated:(BOOL)animated;


- (void) calendarMonthView:(SSICalendarView*)monthView monthChangetoWeek:(BOOL)monthMode animated:(BOOL)animated;

@end


//*************** DATASOURCE *******************
@protocol SSICalendarViewDataSource <NSObject>

- (NSArray*) calendarMonthView:(SSICalendarView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate;

@end
