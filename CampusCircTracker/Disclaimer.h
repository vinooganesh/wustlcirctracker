//
//  Disclaimer.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DURATION 0.3
#define IPHONE5_HEIGHT 568.0
#define IPHONE4_HEIGHT 480.0
#define IPHONE5_LANDSCAPE_HEIGHT_OFFSET 150
#define IPHONE5_PORTRAIT_HEIGHT_OFFSET 100
#define IPHONE4_LANDSCAPE_HEIGHT_OFFSET 238
#define IPHONE4_PORTRAIT_HEIGHT_OFFSET 0

@interface Disclaimer : UIViewController{
    IBOutlet UIScrollView *myScrollView;
}

-(IBAction)hideDisclaimer:(id)sender;
@end
