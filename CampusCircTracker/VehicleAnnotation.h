//
//  VehicleAnnotation.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "VehicleObject.h"

@interface VehicleAnnotation : NSObject<MKAnnotation>

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *title, *subtitle, *heading;

-(id)initWithVehicleObj:(VehicleObject *) vehicle;

@end

