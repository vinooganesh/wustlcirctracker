//
//  SelectPeriod.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "SelectPeriod.h"
#import "SelectStop.h"

@implementation SelectPeriod

- (void)viewDidLoad
{
    [super viewDidLoad];
    periods = [NSArray arrayWithObjects:@"Weekday Academic", @"Weekend Academic", @"Weekday Break", @"Weekend Break", nil];
    
    periodDescriptions = [NSArray arrayWithObjects:@"In-Session School Week", @"In-Session School Weekend", @"School Holiday (ex. Winter/Spring Break)", @"School Holiday (ex. Winter/Spring Break)", nil];
    
    sectionHeaders = [[NSArray alloc]initWithObjects:@"Circulator Schedule By Period", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selection = [myTableView indexPathForSelectedRow];
    if (selection)
        [myTableView deselectRowAtIndexPath:selection animated:YES];
    
    [myTableView reloadData];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [sectionHeaders objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [periods count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *curLoc = [periods objectAtIndex:indexPath.row];
    NSString *curDesc = [periodDescriptions objectAtIndex:indexPath.row];

    NSString *tableIdentifier = @"TimePeriodCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIdentifier];
    }
    
    cell.textLabel.text = curLoc;
    cell.detailTextLabel.text = curDesc;
    
    return cell;
}

        
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowStopsSegue"]) {
        SelectStop *stopsVC = segue.destinationViewController;
        NSIndexPath *indexPath = [myTableView indexPathForSelectedRow];
        stopsVC.selectedPeriod=[periods objectAtIndex:indexPath.row];
    }
}

@end
