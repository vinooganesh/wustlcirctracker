//
//  RouteXMLParser.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface RouteXMLParser: NSObject <NSXMLParserDelegate>
{
    NSMutableString *currentNodeContent;
    NSMutableArray *arrayOfCoords;
    NSXMLParser *parser;
    CLLocation *coord;
    CLLocationDegrees latitude,longitude;
}

@property (readonly,retain) NSMutableArray *arrayOfCoords;

-(id) loadXMLByUrl:(NSString *)urlString;

@end
