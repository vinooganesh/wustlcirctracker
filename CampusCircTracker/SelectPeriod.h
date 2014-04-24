//
//  SelectPeriod.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPeriod : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *myTableView;
    NSArray *periods, *periodDescriptions, *sectionHeaders;
}

@end
