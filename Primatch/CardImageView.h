//
//  CardImageView.h
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

#import <Foundation/Foundation.h>

//Define the various state of a card
#define CARD_STATE_BACK          0 //Back showing
#define CARD_STATE_FRONT_SMALL_1  1  //Switched from back to front
#define CARD_STATE_FRONT_LARGE 2  //Large view showing
#define CARD_STATE_FRONT_SMALL_2 3  //Switched from large to small - next is CARD_BACK

@protocol CardImageTouchedDelegate
- (void)CardImageTouched:(int)imageIndex;
@end

@interface CardImageView : UIImageView 
{
    id <CardImageTouchedDelegate> _delegate;
    NSString *_backImageName;
    NSString *_frontSmallImageName;
    NSString *_frontLargeImageName;
    NSTimer *_cardLargeToSmallTimer;
    BOOL _keepDisplayed;
    int listIndex;
}

-(CardImageView *)initWithFramesAndImageAndTag:(CGRect)smFrame: (CGRect)lgFrame: 
(NSString *)bImageName: (NSString *)fsImageName: (NSString *)flImageName: (int)tag;

- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
-(void)displayNextState;
- (void)displayState:(int)state;
-(void) cardLargeToSmallTimerFinished;
-(void)resetCard;
-(void) cardLargeToSmallAutoTimerFinished;

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSString *backImageName;
@property (nonatomic, assign) NSString *frontSmallImageName;
@property (nonatomic, assign) NSString *frontLargeImageName;
@property (nonatomic, assign) CGRect smallFrame;
@property (nonatomic, assign) CGRect largeFrame;
@property (nonatomic, assign) int cardState;
@property (nonatomic, retain) NSTimer *cardLargeToSmallTimer;
@property (nonatomic, assign) BOOL keepDisplayed;
@property (nonatomic, assign) int listIndex;

@end
