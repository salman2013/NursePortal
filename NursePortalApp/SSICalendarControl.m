//
//  SSICalendarControl.m
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SSICalendarControl.h"
#import "NSDate+SSIDate.h"

#define dotFontSize 18.0
#define dateFontSize 22.0
@interface SSICalendarControl (private)
@property (strong,nonatomic) UIImageView *selectedImageView;
@property (strong,nonatomic) UILabel *currentDay;
@property (strong,nonatomic) UILabel *dot;
@end

@implementation SSICalendarControl

@synthesize monthDate,schStartDate,schEndDate,selectedDateIY ,isMonthViewSelected;


+ (NSArray*) rangeOfDatesInMonthGrid:(NSDate *)tStartDate tileEndDate:(NSDate *)tEndDate startOnSunday:(BOOL)sunday{
	
	
	
	return [NSArray arrayWithObjects:tStartDate,tEndDate,nil];
}

- (id) initWithMonth:(NSDate*)tStartDate tileEndDate:(NSDate *)tEndDate marks:(NSArray*)markArray                                                                               startDayOnSunday:(BOOL)sunday{
    
	if(!(self=[super initWithFrame:CGRectZero])) return nil;
    
    strBundlePath = [[NSBundle mainBundle] bundlePath];
    
    marks = markArray;
	monthDate = tStartDate;
	startOnSunday = sunday;
	
    schStartDate = tStartDate;
    schEndDate =  tEndDate;
    
    schLastDayOfMonth=  [[tStartDate lastOfMonthDate] dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]].day;
    schStartDay=[tStartDate dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]].day;
    schEndDay=[schEndDate dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]].day;
    
    
    
	SSIDateInfo dateInfo = [monthDate dateInfoWithTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
	firstWeekday = dateInfo.weekday;
	
	
	
	daysInMonth = [tStartDate daysBetweenDate:tEndDate];
	
    
    if(daysInMonth == 7)
    {
        isMonthViewSelected = NO;
    }
    else {
        isMonthViewSelected = YES;
    }
    
	NSUInteger scale = (daysInMonth / 7) + 1; // 1 for compact/expand button of calendar view
	CGFloat h = 44.0f * scale;
	
	
	SSIDateInfo todayInfo = [[NSDate date] dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	today = dateInfo.month == todayInfo.month && dateInfo.year == todayInfo.year ? todayInfo.day : -5;
	
	
	self.frame = CGRectMake(0, 1.0, 320.0f, h+1);
	
	[self.selectedImageView addSubview:self.currentDay];
	[self.selectedImageView addSubview:self.dot];
	self.multipleTouchEnabled = NO;
	
	return self;
}

- (void) setTarget:(id)t action:(SEL)a{
	target = t;
	action = a;
}


- (CGRect) rectForCellAtIndex:(int)index{
	
	int row = index / 7;
	int col = index % 7;
	
	return CGRectMake(col*46, row*44+6, 47, 45);
}
- (void) drawTileInRect:(CGRect)r day:(int)day mark:(BOOL)mark font:(UIFont*)f1 font2:(UIFont*)f2{
	
	NSString *str = [NSString stringWithFormat:@"%d",day];
	
    
	//[[UIColor grayColor]set];
	r.size.height -= 2;
	[str drawInRect: r
		   withFont: f1
	  lineBreakMode: UILineBreakModeWordWrap 
		  alignment: UITextAlignmentCenter];
	
	if(mark){
        
        [[UIColor redColor] set];
		r.size.height = 10;
		r.origin.y += 18;
		
		[@"." drawInRect: r
				withFont: f2 
		   lineBreakMode: UILineBreakModeWordWrap 
			   alignment: UITextAlignmentCenter];
	}
	
	
}

- (void) drawRect:(CGRect)rect {
	
    CGRect r = CGRectMake(0, 0, 46, 44);
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIImage *tile = [UIImage imageWithContentsOfFile: [strBundlePath stringByAppendingString:@"/Month Calendar Date Tile.png"]];
	
	CGContextDrawTiledImage(context, r, tile.CGImage);
    
	
	if(today > 0){
		int pre = firstOfPrev > 0 ? lastOfPrev - firstOfPrev + 1 : 0;
		int index = today +  pre-1;
        NSDate *currDate = [NSDate date];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currDate];
        currDate= [gregorian dateFromComponents:comp];
        
        NSComparisonResult r1 = [currDate compare:schStartDate] ;
        NSComparisonResult r2 = [currDate compare:schEndDate] ;
        
        
        if( (r2==NSOrderedAscending || r2 == NSOrderedSame)  && (r1==NSOrderedDescending || r1 == NSOrderedSame))
        {
            
            index = [schStartDate daysBetweenDate:currDate];
            CGRect r =[self rectForCellAtIndex:index];
            r.origin.y -= 7;
            [[UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Calendar Today Tile.png"]] drawInRect:r];
        }
	}
	
	int index = 0;
	
	UIFont *font = [UIFont boldSystemFontOfSize:dateFontSize];
	UIFont *font2 =[UIFont boldSystemFontOfSize:dotFontSize];
	UIColor *color = [UIColor grayColor];
	
    
	
	color = [UIColor colorWithRed:59/255. green:73/255. blue:88/255. alpha:1];
	[color set];
    int iday = 0;
	for(int i=0; i < daysInMonth; i++){
		
        iday = i + schStartDay;
        //if iday is 32
        if(iday > schLastDayOfMonth)
        {
            iday -= schLastDayOfMonth;
        }
        
		r = [self rectForCellAtIndex:index];
		if(today == iday) 
        {
            [[UIColor whiteColor] set];
        }
		
		if ([marks count] > 0) 
			[self drawTileInRect:r day:iday mark:[[marks objectAtIndex:index] boolValue] font:font font2:font2];
		else
			[self drawTileInRect:r day:iday mark:NO font:font font2:font2];
		//if(today == i) 
        [color set];
		index++;
	}
	
    // draw expand/compact button
    r= [self rectForCellAtIndex:index +3];// to add it to the fourth cell of calendar
    //[[UIColor grayColor]set];
	r.size.height -= 2;
	[@"^" drawInRect: r
            withFont: font
       lineBreakMode: UILineBreakModeWordWrap 
           alignment: UITextAlignmentCenter];
    expandButtonRect = r;
	
	
}

- (void) selectDay:(NSDate *)day{
	
    
    NSDate *currDate = [NSDate date];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:currDate];
    currDate= [gregorian dateFromComponents:comp];
    
    NSComparisonResult r1 = [currDate compare:day] ;
    
    
    int tot = [schStartDate daysBetweenDate:day] ;
    
    SSIDateInfo info = [day dateInfoWithTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
	int row = tot / 7;
	int column = (tot % 7);
    
    
	
	selectedDay = info.day;
    selectedDateIY = day;
	selectedPortion = 1;
	
	// if day is today
	if(r1 == NSOrderedSame){
		self.currentDay.shadowOffset = CGSizeMake(0, 1);
		self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Calendar Today Selected Tile.png"]];
		markWasOnToday = YES;
	}else if(markWasOnToday){
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Calendar Date Tile Selected.png"]];
		markWasOnToday = NO;
	}
	
	
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%d",info.day];
	
	if ([marks count] > 0) {
		
		if([[marks objectAtIndex: row * 7 + column ] boolValue]){
			[self.selectedImageView addSubview:self.dot];
		}else{
			[self.dot removeFromSuperview];
		}
		
		
	}else{
		[self.dot removeFromSuperview];
	}
	
	if(column < 0){
		column = 6;
		row--;
	}
	
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column*46);
	r.origin.y = (row*44)-1;
	self.selectedImageView.frame = r;
	
	
    
	
	
}
- (NSDate*) dateSelected{
    
	return selectedDateIY;
}



- (void) reactToTouch:(UITouch*)touch down:(BOOL)down{
	
	CGPoint p = [touch locationInView:self];
	if(p.y > self.bounds.size.height || p.y < 0) return;
	
	int column = p.x / 46, row = p.y / 44;
	int day = 1, portion = 1;
	
	if(row == (int) (self.bounds.size.height / 44)) row --;
	
    day = ((row *7 ) + (column));
    NSLog(@"total days in month %i", daysInMonth);
    if(daysInMonth + 3 == day)
    {
        NSLog(@"expanded button clicked");
        isMonthViewSelected = !isMonthViewSelected;
        [target performSelector:action withObject:nil withObject:[NSNumber numberWithBool:YES]];
        return;
    }
    selectedDateIY = [schStartDate dateByAddingDays:day ];
    day = [[schStartDate dateByAddingDays:day]  dateInfo].day;
	
	
	if(portion != 1){
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Calendar Date Tile Gray.png"]];
		markWasOnToday = YES;
	}else if(portion==1 && day == today){
		self.currentDay.shadowOffset = CGSizeMake(0, 1);
		self.dot.shadowOffset = CGSizeMake(0, 1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Calendar Today Selected Tile.png"]];
		markWasOnToday = YES;
	}else if(markWasOnToday){
		self.dot.shadowOffset = CGSizeMake(0, -1);
		self.currentDay.shadowOffset = CGSizeMake(0, -1);
		self.selectedImageView.image = [UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Calendar Date Tile Selected.png"]];
		markWasOnToday = NO;
	}
	
	[self addSubview:self.selectedImageView];
	self.currentDay.text = [NSString stringWithFormat:@"%d",day];
	
	if ([marks count] > 0) {
		if([[marks objectAtIndex: row * 7 + column] boolValue])
			[self.selectedImageView addSubview:self.dot];
		else
			[self.dot removeFromSuperview];
	}else{
		[self.dot removeFromSuperview];
	}
	
	CGRect r = self.selectedImageView.frame;
	r.origin.x = (column*46);
	r.origin.y = (row*44)-1;
	self.selectedImageView.frame = r;
	
	if(day == selectedDay && selectedPortion == portion) return;
	
	
	
	if(portion == 1){
		selectedDay = day;
		selectedPortion = portion;
        
    
		[target performSelector:action withObject:[NSArray arrayWithObject:[NSNumber numberWithInt:day]] withObject:[NSNumber numberWithBool:NO]];
		
	}else if(down){
		[target performSelector:action withObject:[NSArray arrayWithObjects:[NSNumber numberWithInt:day],[NSNumber numberWithInt:portion],nil] withObject:[NSNumber numberWithBool:NO]];
		selectedDay = day;
		selectedPortion = portion;
	}
	
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//[super touchesBegan:touches withEvent:event];
	//[self reactToTouch:[touches anyObject] down:NO];
} 
- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	//[self reactToTouch:[touches anyObject] down:NO];
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[self reactToTouch:[touches anyObject] down:YES];
}

- (UILabel *) currentDay{
	if(currentDay==nil){
		CGRect r = self.selectedImageView.bounds;
		r.origin.y -= 2;
		currentDay = [[UILabel alloc] initWithFrame:r];
		currentDay.text = @"1";
		currentDay.textColor = [UIColor whiteColor];
		currentDay.backgroundColor = [UIColor clearColor];
		currentDay.font = [UIFont boldSystemFontOfSize:dateFontSize];
		currentDay.textAlignment = UITextAlignmentCenter;
		currentDay.shadowColor = [UIColor darkGrayColor];
		currentDay.shadowOffset = CGSizeMake(0, -1);
	}
	return currentDay;
}
- (UILabel *) dot{
	if(dot==nil){
		CGRect r = self.selectedImageView.bounds;
		r.origin.y += 29;
		r.size.height -= 31;
		dot = [[UILabel alloc] initWithFrame:r];
		
		dot.text = @".";
		dot.textColor = [UIColor whiteColor];
		dot.backgroundColor = [UIColor clearColor];
		dot.font = [UIFont boldSystemFontOfSize:dotFontSize];
		dot.textAlignment = UITextAlignmentCenter;
		dot.shadowColor = [UIColor darkGrayColor];
		dot.shadowOffset = CGSizeMake(0, -1);
	}
	return dot;
}
- (UIImageView *) selectedImageView{
	if(selectedImageView==nil){
		selectedImageView = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile:[strBundlePath stringByAppendingString:@"/Month Calendar Date Tile Selected.png"]]];
                             
                      
	}
	return selectedImageView;
}



@end
