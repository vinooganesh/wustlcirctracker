//
//  RouteXMLParser.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "RouteXMLParser.h"

@implementation RouteXMLParser
@synthesize arrayOfCoords;

-(id) loadXMLByUrl:(NSString *)urlString
{
    arrayOfCoords = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return self;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementname isEqualToString:@"coordinate"])
        coord = [CLLocation alloc];
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementname isEqualToString:@"lat"]){
        if([currentNodeContent doubleValue] != 0){
            latitude = [currentNodeContent doubleValue];
        }
    }
    
    if ([elementname isEqualToString:@"lng"]){
        if([currentNodeContent doubleValue] != 0){
            longitude = [currentNodeContent doubleValue];
        }
    }
    
    if ([elementname isEqualToString:@"coordinate"])
    {
        [arrayOfCoords addObject: [coord initWithLatitude:latitude longitude:longitude]];
        coord = nil;
        currentNodeContent = nil;
    }
    
    if ([elementname isEqualToString:@"kml"])
    {
      /*  //For testing purposes:
        for(CLLocation *curCoord in arrayOfCoords)
            NSLog(@"lat: %f \n lng:%f\n",curCoord.coordinate.latitude,curCoord.coordinate.longitude);
        */
    }
    
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


@end
