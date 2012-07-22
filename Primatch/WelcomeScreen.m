//
//  WelcomeScreen.m
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

#import "WelcomeScreen.h"
#import "GameScreen1.h"


@implementation WelcomeScreen

@synthesize button = _button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.button.transform = CGAffineTransformMakeRotation(-20.0*M_PI/180.0);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)buttonSelected:(id)sender 
{
    GameScreen1 *myView = [[GameScreen1 alloc] initWithNibName:@"GameScreen1" bundle: [NSBundle mainBundle]]; 
    [self.view addSubview: myView.view];
    [UIView transitionFromView:self.view toView:myView.view  duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];

}

@end
