//
//  VehicleAnnotation.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "VehicleAnnotation.h"
#import "VehicleObject.h"

@implementation VehicleAnnotation
@synthesize coordinate, title, subtitle, heading;

/*The basic "constructor" of a Vehicle Object */
-(id)initWithVehicleObj:(VehicleObject *) vehicle{
    CLLocationCoordinate2D loc;
    loc.latitude = [vehicle.lat floatValue];
    loc.longitude = [vehicle.lng floatValue];
    coordinate = loc;
    title = [[NSString stringWithFormat:@"Vehicle %@", vehicle.name] capitalizedString];
    heading = vehicle.heading;
	return self;
}
@end
