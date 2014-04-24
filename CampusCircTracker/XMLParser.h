//
//  XMLParser.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VehicleObject.h"
#define TIMEOUT_INTERVAL 5.0

@interface XMLParser : NSObject <NSXMLParserDelegate, NSURLConnectionDelegate>
{
    NSMutableString *currentNodeContent;
    NSXMLParser *parser;
    VehicleObject *currentVehicle;
    NSDate *initialConnectionDate;
}

@property(readonly,retain) NSMutableArray *arrayOfVehicleObjs;
@property(readonly,retain) NSString *stringDate;
@property(nonatomic,retain) NSMutableData *receivedData;
@property(nonatomic,assign) bool readCompleted;

-(id) initWithString:(NSString *)urlString;

@end
