//
//  StopAnnotation.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "StopAnnotation.h"

@implementation StopAnnotation
@synthesize coordinate, title, subtitle;

-(id)initWithLat:(float) lat Lng:(float) lng title: (NSString *) titlePassed{
    CLLocationCoordinate2D temp;
    temp.latitude = lat;
    temp.longitude = lng;
    title = titlePassed;
	coordinate = temp;
	return self;
}
@end