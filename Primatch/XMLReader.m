//
//  XMLReader.m
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

#import "XMLReader.h"
#include <stdlib.h>

@implementation XMLReader

@synthesize items = _items;
@synthesize filename = _filename;
@synthesize mainElementName = _mainElementName;
@synthesize currentElementValue = _currentElementValue;
@synthesize currentItem = _currentItem;
@synthesize delegate = _delegate;

-(id) init
{
    self = [super init];
    
    if(self)
    {        
        self.filename = nil;
        self.items = nil;
        self.mainElementName = nil;
        self.currentElementValue = nil;
        self.currentItem = nil;
    }
    
    return self;
}

-(void)loadDataFromXML:(NSString *)xmlFileName mainElement:(NSString *)theMainElement
{
    self.filename = xmlFileName;
    self.mainElementName = theMainElement;
    self.items = [[[NSMutableArray alloc] initWithCapacity:300] retain];
    self.currentElementValue = nil;
    self.currentItem = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource: self.filename ofType: @"xml"];
    NSData* data = [NSData dataWithContentsOfFile: path];
    NSXMLParser* parser = [[NSXMLParser alloc] initWithData: data];
    
    [parser setDelegate:self];
    //Start parsing, wait till finished.
    BOOL success = [parser parse];
    
    if(!success)
    {
        NSString *errStr = [[NSString alloc] initWithFormat:@"%@",
                            @"Error parsing XML Feed."];
        //Return error
        [[self delegate] XmlReaderComplete:errStr items:nil];
        [errStr release];
        
    }
    else
    {
        //Return the parsed items
        [[self delegate] XmlReaderComplete:@"OK PARSING" items:self.items];
    }

    [parser release];
    self.items = nil;


}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict 
{
	
    if ([elementName isEqualToString:self.mainElementName]) {
        //NSLog(@"user element found – create a new instance of User class...");
        self.currentItem = [[NSMutableDictionary alloc] init];
        //We do not have any attributes in the user elements, but if
        // you do, you can extract them here: 
        // user.att = [[attributeDict objectForKey:@"<att name>"] ...];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSString *trimmed =
    [string stringByTrimmingCharactersInSet:
     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (!self.currentElementValue) {
        // init the ad hoc string with the value  
        self.currentElementValue = [[NSMutableString alloc] initWithString:trimmed];
    } else {
        // append value to the ad hoc string    
        [self.currentElementValue appendString:trimmed];
    }
    
    //NSLog(@"Processing value for : %@", string);
}  

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"xml"]) {
        // We reached the end of the XML document
        return;
    }
    
    if ([elementName isEqualToString:self.mainElementName]) {
        // We are done with user entry – add the parsed user 
        // object to our user array
        [self.items addObject:self.currentItem];
        // release user object
        [self.currentItem release];
        self.currentItem = nil;
    } 
    else
    {
        NSString *existingValue = [XMLReader getValue:self.currentItem key:elementName];
        if(existingValue == nil)
        {
            [self.currentItem setObject:self.currentElementValue forKey:elementName];
        }
        else
        {
            NSString *newVlaue = [[NSString alloc] initWithFormat:@"%@:%@", existingValue, self.currentElementValue];
            [self.currentItem setObject:newVlaue forKey:elementName];
            [newVlaue release];
        }
    }
    
    [self.currentElementValue release];
    self.currentElementValue = nil;
}

+ (NSString *)getValue:(NSDictionary *)dictionary key:(NSString *)key
{
    NSString *value = (NSString *)[ dictionary objectForKey:key];
    return value;
}



@end
