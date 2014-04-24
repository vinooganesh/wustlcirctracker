//
//  Disclaimer.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "Disclaimer.h"

@implementation Disclaimer

-(void) viewDidLoad{
    myScrollView.showsVerticalScrollIndicator = YES;
    myScrollView.showsHorizontalScrollIndicator = YES;
    myScrollView.scrollEnabled = YES;
}

//iPhone 4: Width:320, Height: 480
//iPhone 5: Width: 320, Height: 568
-(void) viewWillAppear:(BOOL)animated{
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:DURATION];
}

-(IBAction)hideDisclaimer:(id)sender {
     [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotate {
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if(screenHeight == IPHONE4_HEIGHT) //iPhone 4
    {
        //If the current view is Landscape
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            myScrollView.contentSize = CGSizeMake(screenWidth-12,screenHeight+IPHONE4_LANDSCAPE_HEIGHT_OFFSET);
        }
        
        //If the current view is Portrait
        else if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
            myScrollView.contentSize = CGSizeMake(screenWidth,screenHeight-IPHONE4_PORTRAIT_HEIGHT_OFFSET);
        }
    }
    
    else if (screenHeight == IPHONE5_HEIGHT)// iPhone 5
    {
        //If the current view is Landscape
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            myScrollView.contentSize = CGSizeMake(screenWidth-100,screenHeight+IPHONE5_LANDSCAPE_HEIGHT_OFFSET);
        }
        
        //If the current view is Portrait
        else if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
            myScrollView.contentSize = CGSizeMake(screenWidth,screenHeight-IPHONE5_PORTRAIT_HEIGHT_OFFSET);
        }
    }
    
    else{ // other device
        //If the current view is Landscape
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            myScrollView.contentSize = CGSizeMake(screenWidth-100,screenHeight+IPHONE5_LANDSCAPE_HEIGHT_OFFSET);
        }
        
        //If the current view is Portrait
        else if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) {
            myScrollView.contentSize = CGSizeMake(screenWidth,screenHeight-IPHONE5_PORTRAIT_HEIGHT_OFFSET);
        }
    }
}

@end
