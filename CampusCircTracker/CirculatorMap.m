//
//  CirculatorMap.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "CirculatorMap.h"
#import "Reachability.h"
#import "VehicleAnnotation.h"
#import "StopAnnotation.h"
#import "StopHandler.h"

@implementation CirculatorMap

/*To Do:
 1. Fix Typos (Fill, show User location) XXXXX
 2. Add bubble around last updated XXXXX
 6. Put refresh in viewDidAppear with activity indicator surrouding XXXX
 7. Fix the white icons (rename them) XXXX
 4. Fix bug in refresh button XXXXX
 5. Reorder UITableView Cells to make more clear. XXXX
 8. Finish About Page XXXXX
 
 3. Fix bug in not showing correct next stop
 4. Fix showing tomorrow bug
 9. Fix iPad About Page


 */

@synthesize vehicleObjs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    bool runBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"Run Before"];
    if(runBefore == NO){
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Disclaimer"];
        [self presentModalViewController:vc animated:NO];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Run Before"];
    }
    [self setUpInitialMap];
    myActivityIndicatorView.hidesWhenStopped=YES;
    lastUpdatedTextField.backgroundColor = [UIColor whiteColor];
    lastUpdatedTextField.layer.cornerRadius = 6;
    lastUpdatedTextField.clipsToBounds = YES;
}

-(void) viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    /*Show User's Loc*/
    if([defaults boolForKey:@"Show My Location"] == true){
        mapView.showsUserLocation=YES;
    }
    else {
        mapView.showsUserLocation=NO;
    }
    
    /*Show Stop Location*/
    /*if display stops is set to true and showing stops is currently false*/
    if([defaults boolForKey:@"Display Stops"] && ![self isCurrentlyShowingStopAnnotations]){
        [self addStopLocations];
    }
    
    else if([defaults boolForKey:@"Display Stops"] == false){
        [self clearStopAnnotations];
    }
    
    /*Show Route Locations*/
    if([defaults boolForKey:@"Display Route"] && ![self isCurrentlyShowingRoute]){
        [self drawRoute];
    }
    
    else if([defaults boolForKey:@"Display Route"] == false){
        [mapView removeOverlays:mapView.overlays];
    }

}

/*Creates the timer every time the view appears*/
-(void) viewDidAppear:(BOOL)animated
{
    [myActivityIndicatorView startAnimating];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    /*Only refresh the annotations and start the timer if internet is present*/
    if ([self hasInternetConnection]){
        [self refreshVehicleAnnotationsOnMap];
        if([defaults boolForKey:@"Auto-Update Bus"]){
            [timer invalidate]; // Invalidate old timer
            timer = [NSTimer scheduledTimerWithTimeInterval:TIME_FOR_MAP_UPDATE target: self selector: @selector(handleTimer:) userInfo:nil repeats: AUTO_UPDATE];
        }
    }
    
    else{
        [self displayNoInternetAlert];
        }
    [myActivityIndicatorView stopAnimating];
}

/*Invalidates the timer when not on this view*/
-(void) viewDidDisappear:(BOOL)animated{
    [timer invalidate];
    timer = nil;
}

/*Update the last updated timestamp */
-(void) setLastUpdatedText{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM-dd-yyyy hh:mm:ss a"];
    [lastUpdatedTextField setText:[NSString stringWithFormat:@"Last Updated: %@",[formatter stringFromDate:[NSDate date]]]];
}

/*Clears the Vehicle Annotations on the Map every time the timer fires*/
- (void) handleTimer: (NSTimer *) passedTimer
{
    if([self hasInternetConnection]){
        [self refreshVehicleAnnotationsOnMap];
    }
    else{
        [passedTimer invalidate];
        timer = nil;
        [self displayNoInternetAlert];
    }
}

-(void) setUpInitialMap{
    [mapView setDelegate:self];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = INITIAL_MAP_LAT; zoomLocation.longitude = INITIAL_MAP_LNG;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, METERS_PER_MILE, METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
}

-(void) addStopLocations {
    NSArray *stopLats = [NSArray arrayWithObjects:@"38.645487",@"38.645296",@"38.646961",@"38.647661",@"38.650177",@"38.6479",nil];
    NSArray *stopLngs = [NSArray arrayWithObjects:@"-90.315022",@"-90.312896",@"-90.309213",@"-90.301349",@"-90.311880",@"-90.303961", nil];
    NSArray *locations = [NSArray arrayWithObjects:@"Lee Hall", @"Clock Tower", @"Mallinckrodt", @"Skinker Station", @"Millbrook Garage", @"Brookings",nil];
    
    //    StopHandler *so = [[StopHandler alloc] init];
    
    for(int i=0; i<stopLats.count; i++){
        StopAnnotation *annotationPoint = [[StopAnnotation alloc] initWithLat:[[stopLats objectAtIndex:i] floatValue] Lng:[[stopLngs objectAtIndex:i] floatValue] title:[locations objectAtIndex:i]];
        
        // annotationPoint.subtitle = [NSString stringWithFormat:@"Next Scheduled Academic: %@ Break: ",[so getNextScheduledStopTime:[locations objectAtIndex:i] period:@"Weekday Academic"]];
        [mapView addAnnotation:annotationPoint];
    }
}

-(void)refreshVehicleAnnotationsOnMap{
    //If there is internet and the timer is invalidated (meaning internet was dropped),reschedule timer
    if([self hasInternetConnection] && [timer isValid] == false  && [[NSUserDefaults standardUserDefaults] boolForKey:@"Auto-Update Bus"]){
        timer = [NSTimer scheduledTimerWithTimeInterval:TIME_FOR_MAP_UPDATE target: self selector: @selector(handleTimer:) userInfo:nil repeats: AUTO_UPDATE];
    }
    
    [self checkForServerUpdateForVehicles];
    [self clearVehicleAnnotations];
    for (VehicleObject *vo in vehicleObjs){
        VehicleAnnotation *annotation = [[VehicleAnnotation alloc] initWithVehicleObj:vo];
        [mapView addAnnotation:(id)annotation];
    }
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    //For a Bus Stop Marker
    if ([annotation isKindOfClass:[StopAnnotation class]]) {
        MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Pin"];
        customPinView.pinColor=MKPinAnnotationColorRed;
        customPinView.animatesDrop=YES;
        customPinView.canShowCallout = YES;
        return customPinView;
    }
    
    //For the Vehicle Marker
    if ([annotation isKindOfClass:[VehicleAnnotation class]]) {
        MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc ] initWithAnnotation:annotation reuseIdentifier:@"AnnView"];
        int heading = [[(VehicleAnnotation *)annotation heading] intValue];
        
        //If large icons are set to on
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Large Icons"]){
            customAnnotationView.image = [UIImage imageNamed:@"busIcon@2x.png"];
        }
        else {
            customAnnotationView.image = [UIImage imageNamed:@"busIcon.png"];
        }
        /*Calculate the amount to rotatethe icon and rotate the icon*/
        float headingRadians = ((float)heading) / 180 * M_PI;
        [customAnnotationView setTransform:CGAffineTransformIdentity];
        [customAnnotationView setTransform:CGAffineTransformMakeRotation(headingRadians)];
        
        customAnnotationView.canShowCallout = NO;
        return customAnnotationView;
    }
    
    /*No special image for the user's location. Will display blue dot by default*/
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    return nil;
}

/*Method that checks to see if the map is currently showing stops*/
-(bool) isCurrentlyShowingStopAnnotations{
    for(MKAnnotationView *annotation in mapView.annotations){
        if ([annotation isKindOfClass:[StopAnnotation class]])
            return true;
    }
    return false;
}

/*Method that checks to see if the map is currently showing the route*/
-(bool) isCurrentlyShowingRoute{
    if([mapView.overlays count] >= 1){
        return true;
    }
    return false;
}

/*Method that removes only annotations instance of VehicleAnnotation*/
-(void) clearVehicleAnnotations{
    for(MKAnnotationView *annotation in mapView.annotations){
        if ([annotation isKindOfClass:[VehicleAnnotation class]])
            [mapView removeAnnotation:(id <MKAnnotation>)annotation];
    }
}

/*Method that remove only annotations instance of BusStopAnnotation*/
-(void) clearStopAnnotations{
    for(MKAnnotationView *annotation in mapView.annotations){
        if ([annotation isKindOfClass:[StopAnnotation class]])
            [mapView removeAnnotation:(id <MKAnnotation>)annotation];
    }
}

/* Method to parse the XML file for the location of the busses and modify the array of objects*/
-(void) checkForServerUpdateForVehicles{
    if([self hasInternetConnection])
    {
        [myActivityIndicatorView startAnimating];
        xmlParser = [[XMLParser alloc] initWithString:URL_FOR_CIRC_LOCS];
        vehicleObjs = xmlParser.arrayOfVehicleObjs;
        if([vehicleObjs count] == 0) {
            [lastUpdatedTextField setText:@"Circulator Offline!"];
        }
        else{
            [self setLastUpdatedText];
        }
        [myActivityIndicatorView stopAnimating];
    }
    else{
        [timer invalidate];
        [self clearVehicleAnnotations];
    }
}

//Checks to make sure the application is connected to the Internet
-(bool) hasInternetConnection
{
    NetworkStatus internetStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    return !(internetStatus == NotReachable);
}

-(void) displayNoInternetAlert{
    UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Network Error", @"Network Error") message: NSLocalizedString(@"No internet connection found. This application requires an internet connection to function properly. If you have just connected to the internet, press the Refresh button in the upper right hand corner to start.", @"Network error") delegate: self cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
    [errorView show];
}

/*Reads the XML file to draw the route of the Campus Circ*/
-(void) drawRoute{
    if([self hasInternetConnection]){
        [myActivityIndicatorView startAnimating];
        //If the route has not been initilized yet.
        if(routeXmlParser == nil){
            routeXmlParser = [[RouteXMLParser alloc] loadXMLByUrl:URL_FOR_ROUTE_LOCS];
            CLLocationCoordinate2D coordinatesCL[routeXmlParser.arrayOfCoords.count];
            
            /* Go through the coordinates and put them into an array */
            for (NSInteger index = 0; index < routeXmlParser.arrayOfCoords.count; index++) {
                CLLocation *location = [routeXmlParser.arrayOfCoords objectAtIndex:index];
                CLLocationCoordinate2D coordinate = location.coordinate;
                coordinatesCL[index] = coordinate;
            }
            
            /* Draw the Actal Line on the Map */
            polyLine = [MKPolyline polylineWithCoordinates:coordinatesCL count:routeXmlParser.arrayOfCoords.count];
        }
        
        [mapView addOverlay:polyLine];
        [myActivityIndicatorView stopAnimating];
    }
}

/*The View for how the overlay is displayed on the map*/
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
    polylineView.strokeColor = [UIColor colorWithRed:73.0/255.0 green:144.0/255.0 blue: 210.0/255.0 alpha:0.80];
    polylineView.lineWidth = 5.0;
    return polylineView;
}

/*Behavior for buttons below*/
- (IBAction)changeMapType:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex){
        case 1:
            mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            mapView.mapType = MKMapTypeHybrid;
            break;
        default:
            mapView.mapType = MKMapTypeStandard;
            break;
    }
}

-(IBAction) refreshMapButton{
    /*If there is internet connection */
    if([self hasInternetConnection]){
        [self refreshVehicleAnnotationsOnMap];
    }
    
    /*If there is no internet connection*/
    else{
        [self displayNoInternetAlert];
        [self clearVehicleAnnotations];
       
    }
}

-(IBAction)showUserLocButton{
    /*If they have disabled showing their location in settings, they will get an alert*/
    if([mapView showsUserLocation] == NO){
        UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Users Location Disabled", @"Users Location Disabled") message: NSLocalizedString(@"You have disabled showing your location in the applications Settings. If you would like to enable this feature, please turn it on in Settings.", @"Users Location Disabled") delegate: self cancelButtonTitle: NSLocalizedString(@"Close", @"Users Location Disabled") otherButtonTitles: nil];
        [errorView show];
    }
    
    /*If they have showing their location enabled*/
    else{
        if ([CLLocationManager locationServicesEnabled]) {
            CLLocationManager *clManager = [[CLLocationManager alloc] init];
            [clManager setDesiredAccuracy:kCLLocationAccuracyBest];
            [clManager startUpdatingLocation]; //Will start tracking the user
            MKCoordinateRegion mapRegion;
            mapRegion.center = mapView.userLocation.coordinate;
            mapRegion.span = MKCoordinateSpanMake(0.009, 0.009);
            [mapView setRegion:mapRegion animated: YES]; //Will zoom to their location
            
        }
    }
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

@end
