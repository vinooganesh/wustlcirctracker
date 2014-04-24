//
//  RouteOverlay.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "RouteOverlay.h"

@implementation RouteOverlay

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coord1 = {
        38.645296,-90.312896
    };
    
    return coord1;
}

- (MKMapRect)boundingMapRect
{
    
    MKMapPoint upperLeft = MKMapPointForCoordinate(self.coordinate);
    
    MKMapRect bounds = MKMapRectMake(upperLeft.x, upperLeft.y, 2000, 2000);
    return bounds;
}


@end