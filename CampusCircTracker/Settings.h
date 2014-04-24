//
//  Settings.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Settings : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSArray *sectionOptions,*sectionHeaders;
    IBOutlet UITableView *myTableView;
}

@end
