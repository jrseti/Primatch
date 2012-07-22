//
//  NSString+ContainsSubstring.m
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

#import "NSString+ContainsSubstring.h"

@implementation NSString (ContainsSubstring)

- (BOOL)doesContainSubstring:(NSString *)substring
{
    //If self or substring have 0 length they cannot match
    //This can have odd results with NSRange
    if([self length] == 0 || [substring length] == 0)
        return NO;
    NSRange textRange;
    textRange = [[self lowercaseString] rangeOfString:[substring lowercaseString]];
    if(textRange.location != NSNotFound)
    {
        return YES;
    }else{
        return NO;
    }
}

-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8217;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8211;" withString:@"-"];
    string = [string stringByReplacingOccurrencesOfString:@"&#160;" withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&#8212;" withString:@"—"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8220;" withString:@"“"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8221;" withString:@"”"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8222;" withString:@"„"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8224;" withString:@"†"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8225;" withString:@"‡"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8226;" withString:@"•"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8230;" withString:@"…"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8240;" withString:@"‰"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8364;" withString:@"€"];
    string = [string stringByReplacingOccurrencesOfString:@"&#8482;" withString:@"™"];
    
    return string;
}


@end
