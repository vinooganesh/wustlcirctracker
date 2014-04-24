//
//  Settings.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "Settings.h"

@implementation Settings

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *updateOptions = [NSArray arrayWithObjects:@"Auto-Update Bus", @"Show My Location",@"Display Route", @"Display Stops", @"Large Icons", nil];
    
    sectionOptions = [NSArray arrayWithObjects:updateOptions,nil];
    sectionHeaders = [[NSArray alloc] initWithObjects:@"Options",nil];
}

-(void) viewWillAppear:(BOOL)animated{
    /*If Location services are not enabled*/
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"Show My Location"]; //make the default for show user location offline
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void) viewWillAppear{
    [myTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sectionOptions objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContents = [sectionOptions objectAtIndex:[indexPath section]];
    NSString *curOption = [sectionContents objectAtIndex:[indexPath row]];
    NSString *tableIdentifier = @"OptionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
        
    }
    
    UISwitch *mySwitch = [[UISwitch alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([defaults boolForKey:curOption] == true) {
        mySwitch.on = YES;
    }
    else {
        mySwitch.on = NO;
    }
    [mySwitch addTarget:self
                 action:@selector(updateOptions:)
       forControlEvents:UIControlEventTouchUpInside];
    mySwitch.tag =[indexPath row];
    cell.accessoryView = mySwitch;
    cell.textLabel.text = curOption;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [sectionHeaders count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [sectionHeaders objectAtIndex:section];
}

-(void)updateOptions:(UISwitch *)mySwitch{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    switch(mySwitch.tag){
        case 0://Auto-Update Bus
          //If locationServices are Enabled
            mySwitch.on ?  [defaults setBool:true  forKey:@"Auto-Update Bus"] : [defaults setBool:false forKey:@"Auto-Update Bus"];
            
            break;
            
        case 1: //Show User Loc
            //If location services are disabled
            if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized){
                [defaults setBool:false forKey:@"Show My Location"]; //make the default for show user location offline
                mySwitch.on = NO;
                UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Location Services Disabled", @"Location Services Disabled") message: NSLocalizedString(@"You have not enabled location services for this application. In order to show your location, you must enable location services (which can be found in in Settings).", @"Location Services Disabled") delegate: self cancelButtonTitle: NSLocalizedString(@"Close", @"Location Services Disabled") otherButtonTitles: nil];
                [errorView show];
            }
            else{
                mySwitch.on ?  [defaults setBool:true forKey:@"Show My Location"] : [defaults setBool:false forKey:@"Show My Location"];
            }
            break;
            
        case 2://Display Route
            mySwitch.on ?  [defaults setBool:true forKey:@"Display Route"] : [defaults setBool:false forKey:@"Display Route"];
            break;
            
        case 3: //Display Stops
            mySwitch.on ?  [defaults setBool:true forKey:@"Display Stops"] : [defaults setBool:false forKey:@"Display Stops"];
            break;
            
        case 4://Large Icons
            mySwitch.on ?  [defaults setBool:true forKey:@"Large Icons"] : [defaults setBool:false forKey:@"Large Icons"];
            break;
    }
     [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationPortrait;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
   [myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


@end
