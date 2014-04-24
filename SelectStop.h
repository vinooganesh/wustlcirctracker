//
//  StopChoices.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StopHandler.h"

@interface SelectStop : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *myTableView;
    NSArray *locations;
    StopHandler *so;
}

@property (nonatomic, retain) NSString *selectedPeriod;
-(IBAction)refreshTableData: (id)sender;
-(NSArray*) sortedLocations;

@end
