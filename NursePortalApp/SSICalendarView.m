//
//  SSICalendarView.m
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSICalendarView.h"
#import "SSICalendarControl.h"
#import "NSDate+SSIDate.h"
#import "NSString+SSIStringDate.h"



@interface SSICalendarView (private)
@property (strong,nonatomic) UIScrollView *tileBox;
@property (strong,nonatomic) UIImageView *topBackground;
@property (strong,nonatomic) UILabel *monthYear;
@property (strong,nonatomic) UIButton *leftArrow;
@property (strong,nonatomic) UIButton *rightArrow;
@property (strong,nonatomic) UIImageView *shadow;

@end

#pragma mark -
@implementation SSICalendarView
@synthesize delegate,dataSource,calScheduals ,schWeeks;


- (id) init{
    NSDate *date =[NSDate date];
    isScheduleInWeekMode = NO;
    schViewIndex = 0;
	self = [self initWithSundayAsFirst:YES calendarStartDate:[date firstOfMonth] calendarEndDate:[date lastOfMonthDate] scheduleDictionary:nil];
	return self;
}
- (id) initWithSundayAsFirst:(BOOL)s calendarStartDate:(NSDate *) calStartDate calendarEndDate:(NSDate *)calEndDate
          scheduleDictionary:(NSDictionary *) schDictionary{
	if (!(self = [super initWithFrame:CGRectZero])) return nil;
    
    strBundlePath = [[NSBundle mainBundle] bundlePath];
    
	self.backgroundColor = [UIColor grayColor];
    
    // calScheduals = schDictionary;
    /* 
     NSDateFormatter *df = [[NSDateFormatter alloc] init];
     [df setDateStyle:NSDateFormatterMediumStyle];
     [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
     
     NSArray *dates1 = [[NSArray alloc] initWithObjects:[df dateFromString:@"2012-05-06 00:00:00"],[df dateFromString:@"2012-06-03 00:00:00"], nil];
     NSArray *dates2 = [[NSArray alloc] initWithObjects:[df dateFromString:@"2012-06-03 00:00:00"],[df dateFromString:@"2012-07-01 00:00:00"], nil];
     NSArray *dates3 = [[NSArray alloc] initWithObjects:[df dateFromString:@"2012-07-01 00:00:00"],[df dateFromString:@"2012-08-05 00:00:00"], nil];
     */
    
    
    NSArray *dates1 = [[NSArray alloc] initWithObjects:[@"2012-05-06" getDateFromString],[@"2012-06-03" getDateFromString], nil];
    NSArray *dates2 = [[NSArray alloc] initWithObjects:[@"2012-06-03" getDateFromString],[@"2012-07-01" getDateFromString], nil];
    NSArray *dates3 = [[NSArray alloc] initWithObjects:[@"2012-07-01" getDateFromString],[@"2012-08-05" getDateFromString], nil];
    
    
    NSArray *myObjects = [[NSArray alloc] initWithObjects:dates1,dates2,dates3, nil]; 
    NSArray *myKeys = [[NSArray alloc] initWithObjects:@"Key1",@"Key2",@"Key3", nil]; 
    
	calScheduals = [[NSDictionary alloc] initWithObjects:myObjects forKeys:myKeys];
    schWeeks = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:4],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5], nil ];
    totalWeeks = 13;
	sunday = s;
	currentTile = [[SSICalendarControl alloc] initWithMonth:[[calScheduals objectForKey:@"Key1"] objectAtIndex:0]
                                                  tileEndDate:[[calScheduals objectForKey:@"Key1"] objectAtIndex:1]
                                                        marks:nil startDayOnSunday:sunday];
	[currentTile setTarget:self action:@selector(tile:monthViewModeAction:)];
    
    schViewIndex++;
    schWeekIndex++;
	
	CGRect r = CGRectMake(0, 0, self.tileBox.bounds.size.width, self.tileBox.bounds.size.height + self.tileBox.frame.origin.y);
	self.frame = r;
	
	[self addSubview:self.topBackground];
	[self.tileBox addSubview:currentTile];
	[self addSubview:self.tileBox];
	
	//NSDate *date = [NSDate date];
	//self.monthYear.text = [NSString stringWithFormat:@"%@ %@",[date monthString],[date yearString]];
    self.monthYear.text = [NSString stringWithFormat:@"Schedual %i" ,schViewIndex];
	[self addSubview:self.monthYear];
	
	
	[self addSubview:self.leftArrow];
	[self addSubview:self.rightArrow];
	[self addSubview:self.shadow];
	self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
	
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"eee"];
	[dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	
	
	SSIDateInfo sund;
	sund.day = 5;
	sund.month = 12;
	sund.year = 2010;
	sund.hour = 0;
	sund.minute = 0;
	sund.second = 0;
	sund.weekday = 0;
	
	
	NSTimeZone *tz = [NSTimeZone timeZoneForSecondsFromGMT:0];
	NSString * sun = [dateFormat stringFromDate:[NSDate dateFromDateInfo:sund timeZone:tz]];
	
	sund.day = 6;
	NSString *mon = [dateFormat stringFromDate:[NSDate dateFromDateInfo:sund timeZone:tz]];
	
	sund.day = 7;
	NSString *tue = [dateFormat stringFromDate:[NSDate dateFromDateInfo:sund timeZone:tz]];
	
	sund.day = 8;
	NSString *wed = [dateFormat stringFromDate:[NSDate dateFromDateInfo:sund timeZone:tz]];
	
	sund.day = 9;
	NSString *thu = [dateFormat stringFromDate:[NSDate dateFromDateInfo:sund timeZone:tz]];
	
	sund.day = 10;
	NSString *fri = [dateFormat stringFromDate:[NSDate dateFromDateInfo:sund timeZone:tz]];
	
	sund.day = 11;
	NSString *sat = [dateFormat stringFromDate:[NSDate dateFromDateInfo:sund timeZone:tz]];
	
	NSArray *ar;
	if(sunday) ar = [NSArray arrayWithObjects:sun,mon,tue,wed,thu,fri,sat,nil];
	else ar = [NSArray arrayWithObjects:mon,tue,wed,thu,fri,sat,sun,nil];
	
	int i = 0;
	for(NSString *s in ar){
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(46 * i, 29, 46, 15)];
		[self addSubview:label];
		label.text = s;
		label.textAlignment = UITextAlignmentCenter;
		label.shadowColor = [UIColor whiteColor];
		label.shadowOffset = CGSizeMake(0, 1);
		label.font = [UIFont systemFontOfSize:11];
		label.backgroundColor = [UIColor clearColor];
		label.textColor = [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1];
		i++;
	}
	
	return self;
}


- (NSDate*) dateForMonthChange:(UIView*)sender {
	/*BOOL isNext = (sender.tag == 1);
     NSDate *nextMonth = isNext ? [currentTile.monthDate nextMonth] : [currentTile.monthDate previousMonth];
     
     SSIDateInfo nextInfo = [nextMonth dateInfoWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
     NSDate *localNextMonth = [NSDate dateFromDateInfo:nextInfo];
     
     return localNextMonth;
     */
    
    
    /*
     
     BOOL isNext = (sender.tag == 1);
     int k = 0;
     
     if(isNext && schViewIndex == 3)
     return nil;
     
     //First Page -- raise some notification to user
     if(!isNext && schViewIndex == 1)
     return nil;
     
     
     if(!isNext)
     {
     k = schViewIndex - 1;
     }
     else 
     {
     k = schViewIndex + 1;
     }
     
     NSString *key = [[NSString alloc] initWithFormat:@"Key%i",k];
     
     
     NSDate *localNextMonth = [[calScheduals objectForKey:key] objectAtIndex:0];
     
     
     return localNextMonth;
     
     */
    
    return nil;
}

- (NSDate *) getTheStartDateofTileViewinWeekAndMonthMode
{
    
    //NSString *key = [[NSString alloc] initWithFormat:@"Key%i",schViewIndex];
    NSDate *date , *vStartDate , *calStartDate;
    
    calStartDate = [[calScheduals objectForKey:@"Key1"] objectAtIndex:0];
    
    if(currentTile.selectedDateIY == nil)
    {
        // if no date is selected , selecte the first weeks start date of the current schedul
        if(schViewIndex == 1)
        {
            
            date = [NSDate date]; // if its first schedul then today date week will be selected
            
        }
        else 
        {
            date = calStartDate;
        }
        
        
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
        date= [gregorian dateFromComponents:comp];
        
        date=[date dateByAddingDays: 7 ];
        
        SSIDateInfo info = [date dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSLog(@"%i",info.weekday );
        if(info.weekday == 1)
        {
            vStartDate = date;  
        }
        else 
        {
            vStartDate = [date dateByAddingDays:(1 - info.weekday)];    
        }
        
    }
    else
    {
        SSIDateInfo info = [currentTile.selectedDateIY dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSLog(@"%i",info.weekday );
        if(info.weekday == 1)
        {
            vStartDate = currentTile.selectedDateIY;  
        }
        else 
        {
            vStartDate = [currentTile.selectedDateIY dateByAddingDays:(1 - info.weekday)];    
        }
        
        vStartDate=[vStartDate dateByAddingDays:7];
        
    }
    
    
    int diff = [calStartDate daysBetweenDate:vStartDate];
    schWeekIndex = diff / 7;
    return vStartDate;
    
    
}
- (void) changeMonthAnimation:(UIView*)sender{
	
    NSDate *vStartDate , *vEndDate;
    BOOL isNext = (sender.tag == 1);
    NSString *calendarTitle;
    int posWeekIndex , negWeekIndex;;
    
    if(isScheduleInWeekMode)
    {
        NSDate *calStartDate , *calEndDate , *datex , *datey;
        datex = [currentTile schStartDate];
        datey = [currentTile schEndDate];
        
        calStartDate = [[calScheduals objectForKey:@"Key1"] objectAtIndex:0];
        calEndDate = [[calScheduals objectForKey:@"Key3"] objectAtIndex:1];
        
        int totdays = [calStartDate daysBetweenDate:[datex dateByAddingDays:7]]  ;
        posWeekIndex = totdays /7 ;
        
        totdays = [calStartDate daysBetweenDate:[datex dateByAddingDays:-7]]  ;
        negWeekIndex = totdays /7 ;
        
        
        //Last Week -- raise some notification to user
        if(isNext && [calEndDate isEqualToDate:datey])
            return;
        
        //First Week -- raise some notification to user
        if(!isNext && [calStartDate isEqualToDate:datex])
            return;
        
        
        if(!isNext)
        {      
            
            for( int i = 0 ; i < schWeeks.count ; i++)
            {
                if([[schWeeks objectAtIndex:i] intValue] == negWeekIndex)
                {
                    schViewIndex--; // subtract month view if weeks count has passed the a schedul unit index.
                    break;
                }
            }
            
            vStartDate = [datex dateByAddingDays:-7];
            calendarTitle = [NSString stringWithFormat:@"Week %i",negWeekIndex +1];
        }
        else 
        {
            
            for( int i = 0 ; i < schWeeks.count ; i++)
            {
                if([[schWeeks objectAtIndex:i] intValue] == posWeekIndex)
                {
                    schViewIndex++; // plus month view if weeks count has passed the a schedul unit index.
                    break;
                }
            }
            
            vStartDate = [datex dateByAddingDays:7];
            calendarTitle = [NSString stringWithFormat:@"Week %i",posWeekIndex +1];
            
        }
        
        
        vEndDate = [vStartDate dateByAddingDays:7];
        
        
        
        
        
    }
    else 
    {
        //Last Page -- raise some notification to user
        if(isNext && schViewIndex == 3)
            return;
        
        //First Page -- raise some notification to user
        if(!isNext && schViewIndex == 1)
            return;
        
        if(!isNext)
        {      
            schViewIndex--;
            // schWeekIndex -= [[schWeeks objectAtIndex:schViewIndex] intValue];
            
        }
        else 
        {
            schViewIndex++;
            
            // schWeekIndex += [[schWeeks objectAtIndex:schViewIndex] intValue];
        }
        
        NSString *key = [[NSString alloc] initWithFormat:@"Key%i",schViewIndex];
        vStartDate = [[calScheduals objectForKey:key] objectAtIndex:0];
        vEndDate = [[calScheduals objectForKey:key] objectAtIndex:1];
        
        calendarTitle = [NSString stringWithFormat:@"Schedul %i" , schViewIndex];
    }
    
    
    
    
    NSArray *dates = [SSICalendarControl rangeOfDatesInMonthGrid:vStartDate
                                                       tileEndDate:vEndDate startOnSunday:sunday];
    
    
	NSArray *ar = [self.dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
    
	SSICalendarControl *newTile = [[SSICalendarControl alloc] 
                                     initWithMonth:vStartDate
                                     tileEndDate:vEndDate 
                                     marks:ar startDayOnSunday:sunday];
    
	[newTile setTarget:self action:@selector(tile:monthViewModeAction:)];
	
	
	
	int overlap =  0;
	
	if(isNext){
		overlap = [newTile.monthDate isEqualToDate:[dates objectAtIndex:0]] ? 0 : 44;
	}else{
		overlap = [currentTile.monthDate compare:[dates lastObject]] !=  NSOrderedDescending ? 44 : 0;
	}
	
	float y = isNext ? currentTile.bounds.size.height - overlap : newTile.bounds.size.height * -1 + overlap +2;
	
	newTile.frame = CGRectMake(0, y, newTile.frame.size.width, newTile.frame.size.height);
	newTile.alpha = 0;
	[self.tileBox addSubview:newTile];
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	newTile.alpha = 1;
    
	[UIView commitAnimations];
	
	
	
	self.userInteractionEnabled = NO;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(animationEnded)];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDuration:0.4];
	
	
	
	if(isNext){
		
		currentTile.frame = CGRectMake(0, -1 * currentTile.bounds.size.height + overlap + 2, currentTile.frame.size.width, currentTile.frame.size.height);
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(self.tileBox.frame.origin.x, self.tileBox.frame.origin.y, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
		
		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
		
		
	}else{
		
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(self.tileBox.frame.origin.x, self.tileBox.frame.origin.y, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
		currentTile.frame = CGRectMake(0,  newTile.frame.size.height - overlap, currentTile.frame.size.width, currentTile.frame.size.height);
		
		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
		
	}
	
	
	[UIView commitAnimations];
	
	oldTile = currentTile;
	currentTile = newTile;
	
	
	
	monthYear.text = calendarTitle ;//[NSString stringWithFormat:@"Schedual %i" ,schViewIndex];
}

- (void) changeMonth:(UIButton *)sender{
	
	NSDate *newDate = [self dateForMonthChange:sender];
    
    //if(newDate == nil)
    //  return;
    
	if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![self.delegate calendarMonthView:self monthShouldChange:newDate animated:YES] ) 
		return;
	
	
	if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] ) 
		[self.delegate calendarMonthView:self monthWillChange:newDate animated:YES];
	
    
	
	
	[self changeMonthAnimation:sender];
	if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
		[self.delegate calendarMonthView:self monthDidChange:currentTile.monthDate animated:YES];
    
}


- (void) changeMonthViewMode:(BOOL) monthViewMode{
	
    
    NSDate *vStartDate , *vEndDate, *newSelectedDate;
    NSString *key = [[NSString alloc] initWithFormat:@"Key%i",schViewIndex];
    NSString *calendarTitle;
    
    if(!monthViewMode)
    {
        isScheduleInWeekMode = YES;
        
        if(currentTile.selectedDateIY == nil)
        {
            NSDate *currDate = nil;
            
            // if no date is selected , selecte the first weeks start date of the current schedul
            if(schViewIndex > 1)
            {
                currDate = [[calScheduals objectForKey:key] objectAtIndex:0];
                
            }
            else 
            {
                currDate = [NSDate date];
            }
            
            
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currDate];
            currDate= [gregorian dateFromComponents:comp];
            
            SSIDateInfo info = [currDate dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSLog(@"%i",info.weekday );
            if(info.weekday == 1)
            {
                vStartDate = currDate;  
            }
            else 
            {
                vStartDate = [currDate dateByAddingDays:(1 - info.weekday)];    
            }
            
            
            
        }
        else
        {
            SSIDateInfo info = [currentTile.selectedDateIY dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
            NSLog(@"%i",info.weekday );
            if(info.weekday == 1)
            {
                vStartDate = currentTile.selectedDateIY;  
            }
            else 
            {
                vStartDate = [currentTile.selectedDateIY dateByAddingDays:(1 - info.weekday)];    
            }
            
            
            
        }
        
        vEndDate = [vStartDate dateByAddingDays:7];
        
        
        
        int index = [vStartDate daysBetweenDate:[[calScheduals objectForKey:@"Key1"] objectAtIndex:0]] / 7 ;
        calendarTitle = [NSString stringWithFormat:@"Week %i" , index + 1];
        
    }
    else 
    {
        isScheduleInWeekMode = NO;
        vStartDate = [[calScheduals objectForKey:key] objectAtIndex:0];
        vEndDate = [[calScheduals objectForKey:key] objectAtIndex:1];
        
        calendarTitle = [NSString stringWithFormat:@"Schedul %i" , schViewIndex];
    }
    
    
    //new tile's selected date
    newSelectedDate = currentTile.selectedDateIY;
    
    
    NSArray *dates = [SSICalendarControl rangeOfDatesInMonthGrid:vStartDate
                                                       tileEndDate:vEndDate  
                                                     startOnSunday:sunday];
    
    
	NSArray *ar = [self.dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
    
	SSICalendarControl *newTile = [[SSICalendarControl alloc] 
                                     initWithMonth:vStartDate
                                     tileEndDate:vEndDate
                                     marks:ar startDayOnSunday:sunday];
    
    
    
    
	[newTile setTarget:self action:@selector(tile:monthViewModeAction:)];
	
	
	
	int overlap =  0;
	
	if(monthViewMode){
		overlap = [newTile.monthDate isEqualToDate:[dates objectAtIndex:0]] ? 0 : 44;
	}else{
		overlap = [currentTile.monthDate compare:[dates lastObject]] !=  NSOrderedDescending ? 44 : 0;
	}
	
	float y = monthViewMode ? currentTile.bounds.size.height - overlap : newTile.bounds.size.height * -1 + overlap +2;
	
	newTile.frame = CGRectMake(0, y, newTile.frame.size.width, newTile.frame.size.height);
	newTile.alpha = 0;
	[self.tileBox addSubview:newTile];
	
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.1];
	newTile.alpha = 1;
    
	[UIView commitAnimations];
	
	
	
	self.userInteractionEnabled = NO;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDidStopSelector:@selector(animationEnded)];
	[UIView setAnimationDelay:0.1];
	[UIView setAnimationDuration:0.4];
	
	
	
	if(monthViewMode){
		
		currentTile.frame = CGRectMake(0, -1 * currentTile.bounds.size.height + overlap + 2, currentTile.frame.size.width, currentTile.frame.size.height);
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(self.tileBox.frame.origin.x, self.tileBox.frame.origin.y, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
		
		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
		
		
	}else{
		
		newTile.frame = CGRectMake(0, 1, newTile.frame.size.width, newTile.frame.size.height);
		self.tileBox.frame = CGRectMake(self.tileBox.frame.origin.x, self.tileBox.frame.origin.y, self.tileBox.frame.size.width, newTile.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
		currentTile.frame = CGRectMake(0,  newTile.frame.size.height - overlap, currentTile.frame.size.width, currentTile.frame.size.height);
		
		self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
		
	}
	
	
	[UIView commitAnimations];
	
	oldTile = currentTile;
	currentTile = newTile;
	
    //mark selected the selected date in previous tile
    if(newSelectedDate != nil)
        [self selectDate:newSelectedDate];
    newSelectedDate = nil;
	
	
	monthYear.text = calendarTitle ; //[NSString stringWithFormat:@"Schedual %i" ,schViewIndex];
    
	
	
    
}

-(void) performMonthViewModeChange:(BOOL)monthViewMode{
    
    
    
	if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![self.delegate calendarMonthView:self monthShouldChange:nil animated:YES] ) 
		return;
	
	
	if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] ) 
		[self.delegate calendarMonthView:self monthWillChange:nil animated:YES];
	
    
	
	
	[self changeMonthViewMode:[currentTile isMonthViewSelected]];
	if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
		[self.delegate calendarMonthView:self monthDidChange:nil animated:YES];
}

- (void) animationEnded{
	self.userInteractionEnabled = YES;
	[oldTile removeFromSuperview];
	oldTile = nil;
}

- (NSDate*) dateSelected{
	return [currentTile dateSelected];
}
- (NSDate*) monthDate{
	return [currentTile monthDate];
}
- (void) selectDate:(NSDate*)date{
    
    [currentTile selectDay:date];
    return;
    
	/*SSIDateInfo info = [date dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
     NSDate *month = [date firstOfMonth];
     
     if([month isEqualToDate:[currentTile monthDate]]){
     [currentTile selectDay:info.day];
     return;
     
     }else {
     */
    
    /*
     if ([delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![self.delegate calendarMonthView:self monthShouldChange:month animated:YES] ) 
     return;
     
     if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)] )
     [self.delegate calendarMonthView:self monthWillChange:month animated:YES];
     
     
     NSArray *dates = [SSICalendarControl rangeOfDatesInMonthGrid:month startOnSunday:sunday];
     NSArray *data = [self.dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
     SSICalendarControl *newTile = [[SSICalendarControl alloc] initWithMonth:month 
     marks:data 
     startDayOnSunday:sunday];
     [newTile setTarget:self action:@selector(tile:)];
     [currentTile removeFromSuperview];
     currentTile = newTile;
     [self.tileBox addSubview:currentTile];
     self.tileBox.frame = CGRectMake(0, 44, newTile.frame.size.width, newTile.frame.size.height);
     self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.bounds.size.width, self.tileBox.frame.size.height+self.tileBox.frame.origin.y);
     
     self.shadow.frame = CGRectMake(0, self.frame.size.height-self.shadow.frame.size.height+21, self.shadow.frame.size.width, self.shadow.frame.size.height);
     self.monthYear.text = [NSString stringWithFormat:@"%@ %@",[date monthString],[date yearString]];
     [currentTile selectDay:info.day];
     
     if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
     [self.delegate calendarMonthView:self monthDidChange:date animated:NO];
     
     
     
     }
     */
    
    
}
- (void) reload{
    
    NSString *key = [[NSString alloc] initWithFormat:@"Key%i",schViewIndex];
    
    
    NSArray *dates = [SSICalendarControl rangeOfDatesInMonthGrid:[[calScheduals objectForKey:key] objectAtIndex:0]
                                                       tileEndDate:[[calScheduals objectForKey:key] objectAtIndex:1]  startOnSunday:sunday];
    
    
	NSArray *ar = [self.dataSource calendarMonthView:self marksFromDate:[dates objectAtIndex:0] toDate:[dates lastObject]];
    
	SSICalendarControl *refresh = [[SSICalendarControl alloc] 
                                     initWithMonth:[[calScheduals objectForKey:key] objectAtIndex:0]
                                     tileEndDate:[[calScheduals objectForKey:key] objectAtIndex:1] 
                                     marks:ar startDayOnSunday:sunday];
    
	
    
	[refresh setTarget:self action:@selector(tile:monthViewModeAction:)];
	
	[self.tileBox addSubview:refresh];
	[currentTile removeFromSuperview];
	currentTile = refresh;
	
}

- (void) tile:(NSArray*)ar monthViewModeAction:(NSNumber *)monthViewAction{
	
    NSLog(@"%i" , [monthViewAction boolValue]);
    if([monthViewAction boolValue])
    {
        
        [self  performMonthViewModeChange:[currentTile isMonthViewSelected]];
        
        if([self.delegate respondsToSelector:@selector(calendarMonthView:monthChangetoWeek:animated:)])
			[self.delegate calendarMonthView:self monthChangetoWeek:[currentTile isMonthViewSelected]  animated:YES];
        
        return;
    }
    
	if([ar count] < 2){
		
		if([self.delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)])
			[self.delegate calendarMonthView:self didSelectDate:[self dateSelected]];
        
	}else{
		/*
         int direction = [[ar lastObject] intValue];
         UIButton *b = direction > 1 ? self.rightArrow : self.leftArrow;
         
         NSDate* newMonth = [self dateForMonthChange:b];
         if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthShouldChange:animated:)] && ![delegate calendarMonthView:self monthShouldChange:newMonth animated:YES])
         return;
         
         if ([self.delegate respondsToSelector:@selector(calendarMonthView:monthWillChange:animated:)])					
         [self.delegate calendarMonthView:self monthWillChange:newMonth animated:YES];
         
         
         
         [self changeMonthAnimation:b];
         
         int day = [[ar objectAtIndex:0] intValue];
         
         
         // thanks rafael
         SSIDateInfo info = [[currentTile monthDate] dateInfoWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
         info.day = day;
         
         NSDate *dateForMonth = [NSDate dateFromDateInfo:info  timeZone:[NSTimeZone timeZoneWithName:@"GMT"]]; 
         [currentTile selectDay:day];
         
         
         if([self.delegate respondsToSelector:@selector(calendarMonthView:didSelectDate:)])
         [self.delegate calendarMonthView:self didSelectDate:dateForMonth];
         
         if([self.delegate respondsToSelector:@selector(calendarMonthView:monthDidChange:animated:)])
         [self.delegate calendarMonthView:self monthDidChange:dateForMonth animated:YES];
         */
		
	}
	
}

#pragma mark Properties
- (UIImageView *) topBackground{
	if(topBackground==nil){
		topBackground = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Grid Top Bar.png"]]];
	}
	return topBackground;
}
- (UILabel *) monthYear{
	if(monthYear==nil){
		monthYear = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tileBox.frame.size.width, 38)];
		
		monthYear.textAlignment = UITextAlignmentCenter;
		monthYear.backgroundColor = [UIColor clearColor];
		monthYear.font = [UIFont boldSystemFontOfSize:22];
		monthYear.textColor = [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1];
	}
	return monthYear;
}
- (UIButton *) leftArrow{
	if(leftArrow==nil){
		leftArrow = [UIButton buttonWithType:UIButtonTypeCustom];
		leftArrow.tag = 0;
		[leftArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
		[leftArrow setImage:[UIImage imageNamed:@"/Month Calendar Left Arrow"] forState:0];
		leftArrow.frame = CGRectMake(0, 0, 48, 38);
	}
	return leftArrow;
}
- (UIButton *) rightArrow{
	if(rightArrow==nil){
		rightArrow = [UIButton buttonWithType:UIButtonTypeCustom];
		rightArrow.tag = 1;
		[rightArrow addTarget:self action:@selector(changeMonth:) forControlEvents:UIControlEventTouchUpInside];
		rightArrow.frame = CGRectMake(320-45, 0, 48, 38);
		//[rightArrow setImage:[UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Calendar Right Arrow"]] forState:0];
        
        [rightArrow setImage:[UIImage imageNamed: @"Month Calendar Right Arrow"] forState:0];
	}
	return rightArrow;
}
- (UIScrollView *) tileBox{
	if(tileBox==nil){
		tileBox = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, currentTile.frame.size.height)];
	}
	return tileBox;
}
- (UIImageView *) shadow{
	if(shadow==nil){
		shadow = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Calendar Shadow.png"]]];
	}
	return shadow;
}
@end

