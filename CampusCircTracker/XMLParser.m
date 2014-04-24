//
//  XMLParser.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "XMLParser.h"
#import "CirculatorMap.h"

@implementation XMLParser
@synthesize arrayOfVehicleObjs, stringDate, receivedData, readCompleted;

-(id) initWithString:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    readCompleted = false;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:TIMEOUT_INTERVAL];
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    if (theConnection) {
        NSString* myPrivateMode = @"fetchDataMode";
        receivedData = [NSMutableData data];
        [theConnection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:myPrivateMode];
        [theConnection start];
        initialConnectionDate = [[NSDate alloc] init];
        do {
            [[NSRunLoop currentRunLoop] runMode:myPrivateMode beforeDate:[NSDate distantFuture]];
        } while (!readCompleted);
        
    }
    
    else {
        theConnection = nil;
        NSLog(@"XMLParser connection failed.");   // The connection has failed.
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    /*if takes more than 2 seconds to hear back from server, cancel the connection */
    NSTimeInterval timeDifference = [[[NSDate alloc] init] timeIntervalSinceDate: initialConnectionDate] / 60;
    if(timeDifference >= 2.0){
        receivedData = nil;
    }
    [receivedData setLength:0];
    initialConnectionDate = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed with Error, Error: %@", [error localizedDescription]);
    /*Solves problem with lack of internet: */
    connection = nil;
    readCompleted = true;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    readCompleted = true;
    parser = [[NSXMLParser alloc] initWithData:receivedData];
    parser.delegate = self;
    arrayOfVehicleObjs = [[NSMutableArray alloc] init];
    [parser parse];
}


- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementname isEqualToString:@"marker"])
        currentVehicle = [VehicleObject alloc];
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementname isEqualToString:@"date"])
        stringDate = currentNodeContent;
    
    if ([elementname isEqualToString:@"vid"])
        currentVehicle.name = currentNodeContent;
    
    if ([elementname isEqualToString:@"lat"])
        currentVehicle.lat = currentNodeContent;
    
    if ([elementname isEqualToString:@"lng"])
        currentVehicle.lng = currentNodeContent;
    
    if ([elementname isEqualToString:@"heading"])
        currentVehicle.heading = currentNodeContent;
    
    if ([elementname isEqualToString:@"timestamp"])
        currentVehicle.timestamp = currentNodeContent;
    
    if ([elementname isEqualToString:@"marker"])
    {
        [arrayOfVehicleObjs addObject:currentVehicle];
        currentVehicle = nil;
        currentNodeContent = nil;
    }
    
    if ([elementname isEqualToString:@"markers"])
    {
        /*  //For testing purposes:
         for(VehicleObj *vo in arrayOfVehicleObjs){
         NSLog(@"ID: %@ \nLat: %@ \nLng: %@ \nHeading: %@ \nTimestamp: %@\n\n",vo.name, vo.lat, vo.lng, vo.heading, vo.timestamp);
         }*/
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
