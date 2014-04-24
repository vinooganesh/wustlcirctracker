//
//  StopHandler.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

/*
 This file handles everything related to stops including generating the arrays of time that contain
 the times that the circulator stops at a particular stop and determining when the next stop is 
 */

#import <UIKit/UIKit.h>

#define LEE_HALL_OFFSET -1;
#define CLOCK_TOWER_OFFSET 0;
#define MALLINCROKDT_OFFSET 3;
#define SKINKER_OFFSET 6;
#define MILLBROOK_OFFSET 10;
#define BROOKINGS_OFFSET 14;
#define MALLINCROKDT_SECOND_OFFSET 17;

@interface StopHandler : NSObject 

-(id) init;
-(NSString *) getNextScheduledStopTime: (NSString *)stop period:(NSString *)period;
-(NSArray *) getTimesFor:(NSString *)stop period:(NSString *)period;

@end
