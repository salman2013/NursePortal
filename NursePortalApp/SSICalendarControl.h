//
//  SSICalendarControl.h
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSICalendarControl : UIView
{
    id target;
    SEL action;

    int firstOfPrev,lastOfPrev;
    NSArray *marks;
    int today;
    BOOL markWasOnToday;

    int selectedDay,selectedPortion;

    int firstWeekday, daysInMonth;
    UILabel *dot;
    UILabel *currentDay;
    UIImageView *selectedImageView;
    BOOL startOnSunday;
    CGRect expandButtonRect;
    NSString *strBundlePath;

    int schLastDayOfMonth ,schStartDay , schEndDay ;
}

@property (strong,nonatomic) NSDate * monthDate;
@property (strong,nonatomic) NSDate * schStartDate;
@property (strong,nonatomic) NSDate * schEndDate;
@property (strong,nonatomic) NSDate * selectedDateIY;
@property (assign,nonatomic) BOOL isMonthViewSelected;

- (id) initWithMonth:(NSDate *)tStartDate tileEndDate:(NSDate *)tEndDate marks:(NSArray*)marks startDayOnSunday:(BOOL)sunday;
- (void) setTarget:(id)target action:(SEL)action;

- (void) selectDay:(NSDate *)day;
- (NSDate*) dateSelected;

//- (void) performMonthViewModeChange;

+ (NSArray*) rangeOfDatesInMonthGrid:(NSDate*)tStartDate tileEndDate:(NSDate *)tEndDate startOnSunday:(BOOL)sunday;

@end
