//
//  GameScreen1.m
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

#import "GameScreen1.h"
#import "XMLReader.h"
#import "NSString+ContainsSubstring.h"
#import <QuartzCore/QuartzCore.h>
#import "CardImageView.h"

#define IMAGE_INDEX_OFFSET_FOR_TAG 1000
#define IMAGE_INDEX_OFFSET_FOR_LARGE_IMAGE 2000
#define WEBVIEW_LARGE_TAG 3000

@implementation GameScreen1

@synthesize primateItems = _primateItems;
@synthesize webView = _webView;
@synthesize cardItems = _cardItems;
@synthesize background = _background;
@synthesize cardFlipTimer = _cardFlipTimer;
@synthesize currentlySelectedImageViewTag;
@synthesize numCardsSelected;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
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
    
    self.numCardsSelected = 0;
    
    XMLReader *xmlReader = [[XMLReader alloc] init];
    xmlReader.delegate = self;
    [xmlReader loadDataFromXML:@"primates" mainElement:@"primate"];
    
    CALayer * l = [self.webView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor blackColor] CGColor]]; 
    [[self.webView layer] setCornerRadius:12.0];
    
    NSString *htmlString = @"<html>";
    
    htmlString = [htmlString stringByAppendingString:@"<h1><center>Select a card<br>....Any Card...<br>Try to find a match"];
    htmlString = [htmlString stringByAppendingString:@"</center></h1>"];

    
    htmlString = [htmlString stringByAppendingString:@"</html>"];
    
    [self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];

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

- (void)XmlReaderComplete:(NSString *)status items:(NSArray *)feedItems 
{
    NSLog(@"status: %@\n", status);
    
    
    if([status doesContainSubstring:@"ERROR"])
    {
        self.primateItems = nil;
        
        //Get the error message (After ERROR: )
        NSString *message;
        message = [status substringFromIndex:7];
        
        //Create and display the loading progress dialog
        UIAlertView *loadingAlert = [[[UIAlertView alloc] initWithTitle:message message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil, nil] autorelease];
        [loadingAlert show];
        
        return;
    }
    
    self.primateItems = feedItems;
    
    [self makeCards];
    
}


-(NSArray *)getRandItems: (int)numItems
{
    NSMutableArray *_mutableArray = [[NSMutableArray alloc] initWithCapacity:4];

    while([_mutableArray count] < (numItems-1))
    {
        int randIndex = arc4random_uniform(self.primateItems.count);
        if(![_mutableArray containsObject:[self.primateItems objectAtIndex:(NSUInteger)randIndex]])
        {
            [_mutableArray addObject:[self.primateItems objectAtIndex:(NSUInteger)randIndex]];
        }
        
    }
    //Pick one of the random items an
    int randIndex = arc4random_uniform(_mutableArray.count);
    int indexToInsert = arc4random_uniform(_mutableArray.count);
    [_mutableArray insertObject:[_mutableArray objectAtIndex:(NSUInteger)randIndex] atIndex:(NSUInteger)indexToInsert];
    
    
    NSArray *result = [[[NSArray alloc] initWithArray:_mutableArray] autorelease];
    
    return result;
    
}

-(void)makeCards
{    
    self.cardItems = [self getRandItems:4];
    
    for(int i = 0; i<self.cardItems.count; i++)
    {
        NSMutableDictionary *primate = [self.cardItems objectAtIndex:i];
        NSLog(@"Name: %@\n", [XMLReader getValue:primate key:@"pic"]);
        CGRect frame = [self getCardRect: i :4];
        
        float areaWidth = [[UIScreen mainScreen] bounds].size.width;
        float areaHeight = self.webView.frame.origin.y;
        float borderWidth = 5.0;
        CGRect lgFrame = CGRectMake(borderWidth, borderWidth, 
                                  (areaWidth - 2.0*borderWidth), (areaHeight - 2.0*borderWidth));

        
        CardImageView *imageView = [[CardImageView alloc] initWithFramesAndImageAndTag:frame: lgFrame: 
        @"card-front.png": [XMLReader getValue:primate key:@"pic"]: [XMLReader getValue:primate key:@"pic"]: (int)(i + IMAGE_INDEX_OFFSET_FOR_TAG)];
        imageView.delegate = self;
        [self.background addSubview:imageView];
        [imageView release];
    }
    
    return;
}

-(void)cardClicked:(id)sender {
	NSLog(@"See a tap gesture");
}


-(CGRect)getCardRect: (int)cardNum :(int)numCards
{
    CGRect cardRect;
    
        if(numCards == 4)
        {
            int areaWidth = [[UIScreen mainScreen] bounds].size.width;
            //int areaHeight = [[UIScreen mainScreen] bounds].size.height - self.webView.frame.size.height;
            int areaHeight = self.webView.frame.origin.y;
            
            int cardHeight = (areaHeight - 20.0)/2.0;
            int cardWidth  = cardHeight *(2.5/3.5);
            cardRect.size.width = cardWidth;
            cardRect.size.height = cardHeight;
            
            float widthGap = (areaWidth - cardWidth*2.0)/3.0;
            float heightGap = (areaHeight - cardHeight*2.0)/3.0;
            
            if(cardNum == 0)
            {
                cardRect.origin.x = widthGap;
                cardRect.origin.y = heightGap;
            } 
            else if(cardNum == 1)
            {
                cardRect.origin.x = cardWidth + 2.0*widthGap;
                cardRect.origin.y = heightGap;
            } 
            else if(cardNum == 2)
            {
                cardRect.origin.x = widthGap;
                cardRect.origin.y = cardHeight + 2.0*heightGap;
            } 
            else if(cardNum == 3)
            {
                cardRect.origin.x = cardWidth  + 2.0*widthGap;
                cardRect.origin.y = cardHeight + 2.0*heightGap;
            } 
        }

    
    return cardRect;
    
}

- (void)CardImageTouched:(int)imageIndex
{
    CardImageView *view = (CardImageView *)[self.background viewWithTag:imageIndex];
    if(view != nil)
    {
        if(view.cardState == CARD_STATE_BACK)
        {
            if(self.numCardsSelected == 0)
                view.keepDisplayed = YES;
             
            self.numCardsSelected++;
        }
        
        currentlySelectedImageViewTag = imageIndex;
        //[view displayNextState];
        //[self.background bringSubviewToFront:view];
        
        NSMutableDictionary *primate = [self.cardItems objectAtIndex:(view.tag - IMAGE_INDEX_OFFSET_FOR_TAG)];
        NSString *thisPic = [XMLReader getValue:primate key:@"pic"];
        NSMutableDictionary *match = nil;
        if(view.cardState == CARD_STATE_BACK)
            match = [self getMatch:thisPic];
        
        if(match == nil && self.numCardsSelected == 2)
        {
            [NSTimer scheduledTimerWithTimeInterval:2.0 
                                             target:self 
                                           selector:@selector(resetAllCardsTimeFinished) 
                                           userInfo:nil
                                            repeats:NO];
            self.numCardsSelected = 0;
            [view displayNextState];
            [self.background bringSubviewToFront:view];
            [self displayInfo:primate];
        }
        else if(match != nil)
        {
            [self displayMatch:match];
            self.numCardsSelected = 0;
        }
        else
        {
            [view displayNextState];
            [self.background bringSubviewToFront:view];
            [self displayInfo:primate];
        }
    }
}

-(void) cardFlipTimerFinished
{
    CardImageView *view = (CardImageView *)[self.background viewWithTag:currentlySelectedImageViewTag];
    if(view != nil)
    {
        [view displayNextState];
        [self.background bringSubviewToFront:view];
    }
}

-(void) resetAllCardsTimeFinished
{
    for(int i = 0; i<self.cardItems.count; i++)
    {
        CardImageView *view = (CardImageView *)[self.background viewWithTag:(int)(i + IMAGE_INDEX_OFFSET_FOR_TAG)];
        if(view != nil)
        {
            [view resetCard];
        }
    }
}

-(NSMutableDictionary *)getMatch:(NSString *)picToMatch
{
    for(int i = 0; i<self.cardItems.count; i++)
    {
        CardImageView *view = (CardImageView *)[self.background viewWithTag:(int)(i + IMAGE_INDEX_OFFSET_FOR_TAG)];
        if(view != nil)
        {
            NSMutableDictionary *primate = [self.cardItems objectAtIndex:(i)];
            NSString *thisPic = [XMLReader getValue:primate key:@"pic"];
            
            //NSLog(@"%d: %d, %@\n",i,  view.cardState, thisPic);
            
            if(view.cardState > CARD_STATE_BACK)
            {
                if([picToMatch isEqualToString:thisPic])
                {
                    return primate;
                }
            }
        }
    }

    return nil;
}

-(void)displayMatch:(NSMutableDictionary *)primate
{
    NSLog(@"MATCH! %@", [XMLReader getValue:primate key:@"pic"]);
    
    [self resetAllCardsTimeFinished];
    
    float areaWidth = [[UIScreen mainScreen] bounds].size.width;
    float areaHeight = [[UIScreen mainScreen] bounds].size.height - 20.0;
    float borderWidth = 5.0;
    CGRect frame = CGRectMake(borderWidth, borderWidth, 
                                (areaWidth - 2.0*borderWidth), (areaHeight - 2.0*borderWidth));
    UIWebView *view = [[UIWebView alloc] initWithFrame:frame];
    
    CALayer * l = [view layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:10.0];
    [l setBorderWidth:2.0];
    [l setBorderColor:[[UIColor blackColor] CGColor]]; 
    [[view layer] setCornerRadius:12.0];
    
    NSString *htmlString = @"<html>";
    
    htmlString = [htmlString stringByAppendingString:@"<h1><center>You Matched!</center></h1><hr>"];
    htmlString = [htmlString stringByAppendingString:@"<h1><center>"];
    htmlString = [htmlString stringByAppendingString:[XMLReader getValue:primate key:@"name"]];
    htmlString = [htmlString stringByAppendingString:@"</center></h1>"];
    
    htmlString = [htmlString stringByAppendingString:@"<center><img src=\""];
    htmlString = [htmlString stringByAppendingString:[XMLReader getValue:primate key:@"pic"]];
    htmlString = [htmlString stringByAppendingString:@"\" width=160></center>"];
    
    htmlString = [htmlString stringByAppendingString:@"<center>"];
    htmlString = [htmlString stringByAppendingString:[XMLReader getValue:primate key:@"description"]];
    htmlString = [htmlString stringByAppendingString:@"</center>"];
    
    htmlString = [htmlString stringByAppendingString:@"<center><h2>Location</h2></center><center><img src=\""];
    htmlString = [htmlString stringByAppendingString:[XMLReader getValue:primate key:@"location_pic"]];
    htmlString = [htmlString stringByAppendingString:@"\" width=260></center>"];
    
    htmlString = [htmlString stringByAppendingString:@"<center>"];
    htmlString = [htmlString stringByAppendingString:[XMLReader getValue:primate key:@"location"]];
    htmlString = [htmlString stringByAppendingString:@"</center>"];
    
    htmlString = [htmlString stringByAppendingString:@"</html>"];
    
    [view loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
    
    UIButton *helpButton =  [UIButton buttonWithType:UIButtonTypeDetailDisclosure ] ;
    CGRect buttonRect = helpButton.frame;
    buttonRect.origin.x = 4;
    buttonRect.origin.y = 4;
    [helpButton setFrame:buttonRect];
    
    [helpButton addTarget:self action:@selector(webViewBack:) forControlEvents:UIControlEventTouchUpInside];
    [helpButton setEnabled:TRUE];
    helpButton.transform = CGAffineTransformMakeRotation(-180*M_PI/180.0);
    view.tag = WEBVIEW_LARGE_TAG;
    [view addSubview:helpButton];
    
    
    [self.background addSubview:view];
    [self.view sendSubviewToBack:self.webView];
    [self.background bringSubviewToFront:view];
    [view release];
    
    //http://tinyurl.com/submityourapp
}

- (void)webViewBack:(id)sender 
{
    UIWebView *view = (UIWebView *)[self.background viewWithTag:(int)(WEBVIEW_LARGE_TAG)];
    if(view != nil) [view removeFromSuperview];
    [self.view bringSubviewToFront:self.webView];
}

-(void)displayInfo:(NSMutableDictionary *)primate
{
    NSString *htmlString = @"<html>";
    
    htmlString = [htmlString stringByAppendingString:@"<h2><center>"];
    htmlString = [htmlString stringByAppendingString:[XMLReader getValue:primate key:@"name"]];
    htmlString = [htmlString stringByAppendingString:@"</center></h2>"];
    
    htmlString = [htmlString stringByAppendingString:@"<center><b>Family: </b>"];
    htmlString = [htmlString stringByAppendingString:[XMLReader getValue:primate key:@"family"]];
    htmlString = [htmlString stringByAppendingString:@"</center>"];
    
    htmlString = [htmlString stringByAppendingString:@"<center><b>Genus: </b>"];
    htmlString = [htmlString stringByAppendingString:[XMLReader getValue:primate key:@"genus"]];
    htmlString = [htmlString stringByAppendingString:@"</center>"];
    
    htmlString = [htmlString stringByAppendingString:@"<center><b>Location: </b>"];
    htmlString = [htmlString stringByAppendingString:[XMLReader getValue:primate key:@"location"]];
    htmlString = [htmlString stringByAppendingString:@"</center></center>"];
    
    htmlString = [htmlString stringByAppendingString:@"</html>"];
    
    [self.webView loadHTMLString:htmlString baseURL:[[NSBundle mainBundle] bundleURL]];
}
 

-(void)displaySelectedInfo
{
    
}


@end
