//
//  NSString+ContainsSubstring.h
//  Primatch
//
//  Created by Jon Richards on 7/21/12.
//  Copyright (c) 2012 SETI INSTITUTE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ContainsSubstring)
- (BOOL)doesContainSubstring:(NSString *)substring;
-(NSString *)htmlEntityDecode:(NSString *)string;
@end
