//
//  LocationTimes.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopHandler.h"

@interface ShowScheduledTimes : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray *sectionHeaders, *sectionOptions, *times, *nextStopTime, *option ;
    IBOutlet UITableView *myTableView;
    StopHandler *so;
}

@property (nonatomic, retain) NSString *fullSelectedOption;
@property (nonatomic, retain) NSString *selectedStop;
@property (nonatomic, retain) NSString *selectedPeriod;

-(IBAction)refreshTableData: (id)sender;


@end
