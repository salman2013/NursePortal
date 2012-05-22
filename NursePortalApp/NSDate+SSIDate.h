//
//  NSDate+SSIDate.h
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

struct SSIDateInfo {
	int day;
	int month;
	int year;
	
	int weekday;
	
	int minute;
	int hour;
	int second;
	
};
typedef struct SSIDateInfo SSIDateInfo;

@interface NSDate (SSIDate)


- (NSDate *) monthDate;



- (BOOL) isSameDay:(NSDate*)anotherDate;
- (int) monthsBetweenDate:(NSDate *)toDate;
- (NSInteger) daysBetweenDate:(NSDate*)date;


- (BOOL) isToday;


- (NSDate *) dateByAddingDays:(NSUInteger)days;


- (NSString *) monthString;
- (NSString *) yearString;

- (NSDate*) firstOfMonth;
- (NSDate*) nextMonth;
- (NSDate*) previousMonth;


- (NSDate*) lastOfMonthDate;

- (SSIDateInfo) dateInfo;
- (SSIDateInfo) dateInfoWithTimeZone:(NSTimeZone*)tz;

+ (NSDate*) dateFromDateInfo:(SSIDateInfo)info;
+ (NSDate*) dateFromDateInfo:(SSIDateInfo)info timeZone:(NSTimeZone*)tz;
+ (NSString*) dateInfoDescriptionWithInformation:(SSIDateInfo)info;

@end
