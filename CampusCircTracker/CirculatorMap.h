//
//  CirculatorMap.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "XMLParser.h"
#import "RouteXMLParser.h"

#define METERS_PER_MILE 1750
#define INITIAL_MAP_LAT 38.646757 //Update to change intial map's latitude
#define INITIAL_MAP_LNG -90.308972 //Update to change intial map's longitude
#define TIME_FOR_MAP_UPDATE 5.0 //Update to change time between each update
#define AUTO_UPDATE YES //Update to turn auto update off
#define URL_FOR_CIRC_LOCS @"http://sts.wustl.edu/apps/circulator/data.xml" //Update to change location of XML for Circ Locations
#define URL_FOR_ROUTE_LOCS @"http://sts.wustl.edu/apps/circulator/circulator_route.xml" //Update to change location of XML for the Circulator's Route

@interface CirculatorMap : UIViewController <MKMapViewDelegate>{
    IBOutlet MKMapView *mapView;
    IBOutlet UITextField *lastUpdatedTextField;
    IBOutlet UIActivityIndicatorView *myActivityIndicatorView;
    XMLParser *xmlParser;
    RouteXMLParser *routeXmlParser;
    NSArray *vehicleObjs;
    bool showingRoute;
    MKPolyline *polyLine;
    NSTimer *timer;
}

@property (nonatomic, retain) NSArray *vehicleObjs;

-(void) setUpInitialMap;
-(bool) hasInternetConnection;
-(void) clearVehicleAnnotations;
-(void) checkForServerUpdateForVehicles;
-(void) addStopLocations;
-(void) clearStopAnnotations;
-(void) setLastUpdatedText;
-(void) drawRoute;
-(bool) isCurrentlyShowingStopAnnotations;
-(bool) isCurrentlyShowingRoute;
-(void) displayNoInternetAlert;
-(void)refreshVehicleAnnotationsOnMap;
-(IBAction)changeMapType:(UISegmentedControl *)sender;
-(IBAction) refreshMapButton;
-(IBAction)showUserLocButton;

@end
