//
//  NSString+SSIStringDate.m
//  NursePortalApp
//
//  Created by user on 21/05/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+SSIStringDate.h"

@implementation NSString (SSIStringDate)
- (NSDate*) getDateFromString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    //  [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    //NSDate *dateu = [dateFormatter dateFromString:@"2012-05-1600:00:00"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:self];
}

@end
