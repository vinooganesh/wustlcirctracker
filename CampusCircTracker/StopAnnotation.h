//
//  StopAnnotation.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface StopAnnotation : NSObject<MKAnnotation> {
    CLLocationCoordinate2D coordinate;
}

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *title, *subtitle;

-(id)initWithLat:(float) lat Lng:(float) lng title: (NSString *) title;

@end