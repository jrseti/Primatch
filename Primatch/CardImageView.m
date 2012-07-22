//
//  CardImageView.m
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

#import "CardImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CardImageView

@synthesize delegate = _delegate;
@synthesize backImageName = _backImageName;
@synthesize frontSmallImageName = _secondImageName;
@synthesize frontLargeImageName = _frontLargeImageName;
@synthesize smallFrame;
@synthesize largeFrame;
@synthesize cardState;
@synthesize cardLargeToSmallTimer = _cardLargeToSmallTimer;
@synthesize keepDisplayed = _keepDisplayed;
@synthesize listIndex;

-(CardImageView *)initWithFramesAndImageAndTag:(CGRect)smFrame: (CGRect)lgFrame: 
(NSString *)bImageName: (NSString *)fsImageName: (NSString *)flImageName: (int)tag
{
    self = [super init];

    if(self)
    {        
        self.backImageName = bImageName;
        self.frontSmallImageName = fsImageName;
        self.frontLargeImageName = flImageName;
        self.frame = smFrame;
        self.smallFrame = smFrame;
        self.largeFrame = lgFrame;
        self.tag = tag;
        self.image = [UIImage imageNamed:self.backImageName];
        self.userInteractionEnabled = YES;
        self.cardState = CARD_STATE_BACK;
        CALayer * l = [self layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:10.0];
        [[self layer] setCornerRadius:12.0];
        [l setBorderWidth:2.0];
        [l setBorderColor:[[UIColor whiteColor] CGColor]]; 
        self.cardState = CARD_STATE_BACK;
        self.keepDisplayed = NO;
    }

    return self;
}

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event 
{
    [self.delegate CardImageTouched:(int)self.tag];
}

-(void)displayNextState
{
    //Progress to the next state.
    if(self.cardState == CARD_STATE_BACK)
        [self displayState:CARD_STATE_FRONT_SMALL_1];
    else if(self.cardState == CARD_STATE_FRONT_SMALL_1)
        [self displayState:CARD_STATE_FRONT_LARGE];
    else if(self.cardState == CARD_STATE_FRONT_LARGE)
        [self displayState:CARD_STATE_FRONT_SMALL_2];
    else if(self.cardState == CARD_STATE_FRONT_SMALL_2)
        [self displayState:CARD_STATE_BACK];
}

- (void)displayState:(int)state
{
    if(state == CARD_STATE_BACK)
    {
        self.image = [UIImage imageNamed:self.backImageName];
        self.frame = self.smallFrame; 
    }
    else if(state == CARD_STATE_FRONT_SMALL_1)
    {
        self.image = [UIImage imageNamed:self.frontSmallImageName];
        self.frame = self.smallFrame; 
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 
                                         target:self 
                                       selector:@selector(cardLargeToSmallTimerFinished) 
                                       userInfo:nil
                                        repeats:NO];
    }
    else if(state == CARD_STATE_FRONT_LARGE)
    {
        self.image = [UIImage imageNamed:self.frontLargeImageName];
        self.frame = self.largeFrame; 
        
        [NSTimer scheduledTimerWithTimeInterval:4.0 
                                         target:self 
                                       selector:@selector(cardLargeToSmallAutoTimerFinished) 
                                       userInfo:nil
                                        repeats:NO];
    }
    else if(state == CARD_STATE_FRONT_SMALL_2)
    {
        self.image = [UIImage imageNamed:self.frontSmallImageName];
        self.frame = self.smallFrame; 
        
        if(self.keepDisplayed == NO)
        {
            [NSTimer scheduledTimerWithTimeInterval:2.0 
                                         target:self 
                                       selector:@selector(cardLargeToSmallTimerFinished) 
                                       userInfo:nil
                                        repeats:NO];
        }
        else
        {
            self.keepDisplayed = NO; //Reset, only need once
        }
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self cache:YES];
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];

    self.cardState = state;
}

-(void)resetCard
{
    self.keepDisplayed = NO;
    [self displayState:CARD_STATE_BACK];
}

-(void) cardLargeToSmallTimerFinished
{
    [self displayNextState];
}

-(void) cardLargeToSmallAutoTimerFinished
{
    if(self.cardState == CARD_STATE_FRONT_LARGE) [self displayNextState];
}


@end
