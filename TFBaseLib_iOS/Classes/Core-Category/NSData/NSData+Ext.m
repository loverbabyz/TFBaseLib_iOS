//
//  NSData+Ext.m
//  Treasure
//
//  Created by xiayiyong on 15/3/2.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "NSData+Ext.h"

@implementation NSData (Ext)

- (NSString *)toString {
  return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

+ (NSString *)toString:(NSData *)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
