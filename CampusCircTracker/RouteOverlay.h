//
//  RouteOverlay.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RouteOverlay : NSObject<MKOverlay> 

- (MKMapRect)boundingMapRect;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
