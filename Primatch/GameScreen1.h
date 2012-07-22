//
//  GameScreen1.h
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLReader.h"
#import "CardImageView.h"

@interface GameScreen1 : UIViewController <XMLReaderCompleteDelegate, UIGestureRecognizerDelegate,CardImageTouchedDelegate>
{
    NSArray *_primateItems;
    NSArray *_cardItems;
    UIWebView *_webView;
    UIImageView *_background;
    NSTimer *_cardFlipTimer;
    int currentlySelectedImageViewTag;
    int numCardsSelected;
}

@property (atomic, retain) NSArray *primateItems;
@property (atomic, retain) NSArray *cardItems;
@property (atomic, retain) IBOutlet UIWebView *webView;
@property (atomic, retain) IBOutlet UIImageView *background;
@property (atomic, retain) NSTimer *cardFlipTimer;
@property (atomic, assign) int currentlySelectedImageViewTag;
@property (atomic, assign) int numCardsSelected;

-(NSArray *)getRandItems: (int)numItems;
-(void)makeCards;
-(CGRect)getCardRect: (int)cardNum :(int)numCards;
-(NSMutableDictionary *)getMatch:(NSString *)picToMatch;

-(void)cardClicked:(id)sender;
-(void) cardFlipTimerFinished;
-(void) resetAllCardsTimeFinished;
-(void)displayMatch:(NSMutableDictionary *)imageName;
-(void)displaySelectedInfo;
-(void)webViewBack:(id)sender ;
-(void)displayInfo:(NSMutableDictionary *)primate;

@end
