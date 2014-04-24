//
//  LocationTimes.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "ShowScheduledTimes.h"

@implementation ShowScheduledTimes
@synthesize fullSelectedOption, selectedStop, selectedPeriod;

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*Section Headers*/
    sectionHeaders = [[NSArray alloc]initWithObjects:@"Period - Location", @"Next Scheduled Stop", @"Full List of Stop Times", nil];

    option = [[NSArray alloc]initWithObjects: fullSelectedOption, nil];
    so = [[StopHandler alloc] init];
    times = [so getTimesFor:selectedStop period:selectedPeriod];
    
    nextStopTime = [[NSArray alloc]initWithObjects:[so getNextScheduledStopTime:selectedStop period:selectedPeriod],  nil];
    sectionOptions = [NSArray arrayWithObjects:option, nextStopTime, times, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selection = [myTableView indexPathForSelectedRow];
    if (selection)
        [myTableView deselectRowAtIndexPath:selection animated:YES];
    [myTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [sectionHeaders objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [sectionHeaders count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sectionOptions objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContents = [sectionOptions objectAtIndex:[indexPath section]];
    NSString *curOption = [sectionContents objectAtIndex:[indexPath row]];
    NSString *tableIdentifier = @"TimeSlotTableCell";
    
    //Option for which schedule/Loc
    if([indexPath section] == 0 && [indexPath row] == 0){
        tableIdentifier = @"OptionSelectedTableCell";
    }
    
    //For Next Stop
    if([indexPath section] == 1 && [indexPath row] == 0){
        tableIdentifier=@"NextScheduledStopTableCell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableIdentifier];
    }
    
    cell.textLabel.text = curOption;
   
    return cell;
}

-(IBAction)refreshTableData: (id)sender{
    nextStopTime = [[NSArray alloc]initWithObjects:[so getNextScheduledStopTime:selectedStop period:selectedPeriod], nil];
    sectionOptions = [NSArray arrayWithObjects:option, nextStopTime, times, nil];
    [myTableView reloadData];
}

@end
