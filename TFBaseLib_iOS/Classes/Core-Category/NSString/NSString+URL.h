//
//  NSString+URL.h
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 * 转换成URL
 */
- (NSURL *)toURL;

/**
 *  把URL进行UTF8转码
 *
 *  @return 转码后的
 */
- (NSString *)URLEncode;

@end
