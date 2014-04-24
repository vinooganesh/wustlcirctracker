//
//  StopHandler.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "StopHandler.h"

@implementation StopHandler

-(id) init{
    return self;
}

-(NSString *) getNextScheduledStopTime: (NSString *)stop period:(NSString *)period{
    NSArray *times = [self getTimesFor:stop period:period];
    //Formats each element in the array of times
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //Formats the timestamp now
    NSDate *now = [NSDate date];
    NSString *theStrNow = [formatter stringFromDate:now];
    NSDateFormatter* formatterGMT = [[NSDateFormatter alloc] init];
    [formatterGMT setDateFormat:@"hh:mm a"];
    [formatterGMT setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDate *correctFormatNow = [formatterGMT dateFromString:theStrNow];
    
    //Iterate through the array of times for that stop and period and see when the next one is
    for(NSString *currentStrStop in times){
        NSDate *nextBus = [formatterGMT dateFromString:currentStrStop];
        if ([nextBus compare:correctFormatNow] == NSOrderedDescending || [nextBus compare:correctFormatNow] == NSOrderedSame) {
            return currentStrStop;
        }
    }

    [formatterGMT setDateFormat:@"h:mm:ss"];
    NSDate *firstTimeTomorrow = [[formatterGMT dateFromString:[times objectAtIndex:0]] dateByAddingTimeInterval:60*60*24];
    NSLog(@"FTT:%@",[formatterGMT stringFromDate:firstTimeTomorrow]);

    return [formatterGMT stringFromDate:firstTimeTomorrow]; // return the first stop of the next morning (with 1 day added) 
}

-(NSArray *) getTimesFor:(NSString *)stop period:(NSString *)period {
    NSMutableArray *timesToReturn = [[NSMutableArray alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    NSDateComponents *offsetComponenets = [[NSDateComponents alloc] init];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm a"];
    
    int numStopsPerDay = 0;
    int startingHour = 0;
    int startingMin = 0;
    int offset = 0;
    
    //Sets up the offsets for each stop
    if([stop isEqualToString:@"Lee Hall"])
        offset = LEE_HALL_OFFSET;
    
    if([stop isEqualToString:@"Clock Tower"])
        offset = CLOCK_TOWER_OFFSET;
    
    if([stop isEqualToString:@"Mallinckrodt"])
        offset = MALLINCROKDT_OFFSET;
    
    if([stop isEqualToString:@"Skinker Station"])
        offset = SKINKER_OFFSET;
    
    if([stop isEqualToString:@"Millbrook Garage"])
        offset = MILLBROOK_OFFSET;
    
    if([stop isEqualToString:@"Brookings"])
        offset = BROOKINGS_OFFSET;
    
    /*The starting hours and number of stops for all of the different periods*/
    if([period isEqualToString:@"Weekday Academic"]){
        startingHour = 7;
        startingMin = 40;
        numStopsPerDay = 54;
    }
    
    if([period isEqualToString:@"Weekend Academic"]){
        startingHour = 12;
        startingMin = 0;
        numStopsPerDay = 41;
    }
    
    if([period isEqualToString:@"Weekday Break"]){
        startingHour = 7;
        startingMin = 40;
        numStopsPerDay = 42;
    }
    
    if([period isEqualToString:@"Weekend Break"]){
        startingHour = 12;
        startingMin = 0;
        numStopsPerDay = 29;
    }
    
    int iter=0;
    NSDateFormatter* formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateComps setHour:startingHour];
    [dateComps setDay:1];

    for(int i=0; i<=numStopsPerDay; i++){
        [dateComps setMinute:startingMin+iter];
        NSLog(@"my day is %i", [dateComps minute]);
        NSDate *dateFromComponenets = [gregorian dateFromComponents:dateComps];
        [offsetComponenets setMinute:offset];
        
        
        NSDate *curIterTime = [gregorian dateByAddingComponents:offsetComponenets toDate:dateFromComponenets options:0];
        

        
        
        
        
        NSLog(@"%@", [NSString stringWithFormat:@"%@",[formatter2 stringFromDate:curIterTime]]);
        
        [timesToReturn addObject:[NSString stringWithFormat:@"%@",[formatter stringFromDate:curIterTime]]];
        iter = iter + 20;
     
    }
    return timesToReturn;
}

@end
