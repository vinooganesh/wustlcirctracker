//
//  StopChoices.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//


#import "SelectStop.h"
#import "ShowScheduledTimes.h"
#import "StopHandler.h"

@implementation SelectStop

@synthesize selectedPeriod;
- (void)viewDidLoad
{
    [super viewDidLoad];
    so = [[StopHandler alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selection = [myTableView indexPathForSelectedRow];
    if (selection)
        [myTableView deselectRowAtIndexPath:selection animated:YES];
    locations = [self sortedLocations];
    [myTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
}

-(NSArray*) sortedLocations{
    NSArray *unsortedLocations = [NSArray arrayWithObjects:@"Lee Hall", @"Clock Tower", @"Mallinckrodt", @"Skinker Station", @"Millbrook Garage", @"Brookings",nil];
    NSMutableArray *locationNextTime = [[NSMutableArray alloc] init];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    for(NSString *loc in unsortedLocations){
        [locationNextTime addObject:[formatter dateFromString:[so getNextScheduledStopTime:loc period:selectedPeriod]]];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:locationNextTime forKeys:unsortedLocations];
    return [dict keysSortedByValueUsingSelector:@selector(compare:)];

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *sectionHeaders = [[NSArray alloc]initWithObjects:@"Circulator Schedule By Location",nil];
	return [sectionHeaders objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *curStop = [locations objectAtIndex:indexPath.row];
    NSString *tableIdentifier = @"StopCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    cell.textLabel.text = curStop;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[so getNextScheduledStopTime:curStop period:selectedPeriod]];
    
    return cell;
}

-(IBAction)refreshTableData: (id)sender{
    locations = [self sortedLocations];
    [myTableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowTimesSegue"]) {
        ShowScheduledTimes *locVC = segue.destinationViewController;
        NSIndexPath *indexPath = [myTableView indexPathForSelectedRow];
        locVC.selectedStop = [locations objectAtIndex:indexPath.row];
        locVC.selectedPeriod = selectedPeriod;
        locVC.fullSelectedOption = [selectedPeriod stringByAppendingFormat:@"%@%@",@" - ", locVC.selectedStop];
    }
    
}
@end