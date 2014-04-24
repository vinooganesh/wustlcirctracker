//
//  About.m
//  WUSTL Circulator
//
//  Created by Vinoo Ganesh.
//  Copyright (c) 2013 Vinoo Ganesh. All rights reserved.
//

#import "About.h"

@implementation About
- (void)viewDidLoad
{
    myScrollView.showsVerticalScrollIndicator = YES;
    myScrollView.scrollEnabled = YES;
    legalTextView.backgroundColor = [UIColor clearColor];
    legalTextView.textColor = [UIColor whiteColor];
    feedbackTextView.backgroundColor = [UIColor clearColor];
    feedbackTextView.textColor = [UIColor whiteColor];
    thanksTextView.backgroundColor = [UIColor clearColor];
    thanksTextView.textColor = [UIColor whiteColor];
    thanksToTextView.backgroundColor = [UIColor clearColor];
    thanksToTextView.textColor = [UIColor whiteColor];
    glyphishTextView.backgroundColor = [UIColor clearColor];
    glyphishTextView.textColor = [UIColor whiteColor];
}

-(void) viewDidAppear:(BOOL)animated{
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:DURATION];
}

-(IBAction) showDisclaimer: (id) sender{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"Disclaimer"];
    [self presentModalViewController:vc animated:YES];
}

- (BOOL)shouldAutorotate {
    return YES;
}

//Supports all orientation
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
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))  //if landscape
            myScrollView.contentSize = CGSizeMake(screenWidth,screenHeight+88);
        
        else if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) 
            myScrollView.contentSize = CGSizeMake(screenWidth,screenHeight-120);
        
    }
    
    else if (screenHeight == IPHONE5_HEIGHT)// iPhone 5
    {
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))  //if landscape
            myScrollView.contentSize = CGSizeMake(screenWidth,screenHeight);
        
        else if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) 
            myScrollView.contentSize = CGSizeMake(screenWidth,screenHeight-120);
    }
    
    else{ // other device
        //If the current view is Landscape
      	if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation))  //if landscape
            myScrollView.contentSize = CGSizeMake(screenWidth,screenHeight);
        
        //If the current view is Portrait
        else if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation)) 
            myScrollView.contentSize = CGSizeMake(screenWidth,screenHeight-120);
    }
}


@end
