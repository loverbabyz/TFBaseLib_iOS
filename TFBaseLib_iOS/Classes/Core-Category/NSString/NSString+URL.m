//
//  NSString+URL.m
//  Treasure
//
//  Created by Daniel on 15/9/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "NSString+URL.h"
#import "NSString+Category.h"

@implementation NSString (URL)

- (NSURL *)toURL
{
    return [NSURL URLWithString:[self stringByAddingPercentEncodingWithAllowedCharacters: [[NSCharacterSet characterSetWithCharactersInString:self] invertedSet]]];
}

- (NSString *)URLEncode
{    
    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
    NSString *result = [self stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet]];
    
    return [result trim];
}

@end
