//
//  XMLReader.h
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XMLReaderCompleteDelegate
- (void)XmlReaderComplete:(NSString *)status items:(NSArray *)parsedItems;
@end

@interface XMLReader : NSObject <NSXMLParserDelegate> 
{
    id <XMLReaderCompleteDelegate> _delegate;
    NSString *_mainElementName;
    NSString *_filename; 
    NSMutableString *_currentElementValue;
    NSMutableDictionary *_currentItem;
    NSMutableArray *_items;
}

@property (atomic, retain) NSMutableArray *items;
@property (atomic, retain) NSString *filename;
@property (atomic, retain) NSString *mainElementName;
@property (atomic, retain) NSMutableString *currentElementValue;
@property (atomic, retain) NSMutableDictionary *currentItem;

-(void)loadDataFromXML:(NSString *)xmlFileName mainElement:(NSString *)theMainElement;

+ (NSString *)getValue:(NSDictionary *)dictionary key:(NSString *)key;

@property (nonatomic, assign) id delegate; 


@end
