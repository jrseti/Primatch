//
//  WelcomeScreen.h
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

@interface WelcomeScreen : UIViewController
{
    UIButton *_button;
}

@property (nonatomic, retain) IBOutlet UIButton *button;

- (IBAction)buttonSelected:(id)sender;

@end
