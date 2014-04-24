//
//  About.h
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IPHONE5_HEIGHT 568.0
#define IPHONE4_HEIGHT 480.0
#define DURATION 0.3

@interface About : UIViewController
{
    IBOutlet UITextView *feedbackTextView,*legalTextView,*thanksTextView,*thanksToTextView, *glyphishTextView;
    IBOutlet UIScrollView *myScrollView;
}
-(IBAction) showDisclaimer: (id) sender;
@end
