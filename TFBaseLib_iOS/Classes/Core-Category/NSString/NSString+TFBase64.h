//
//  NSString+TFBase64.h
//  Treasure
//
//  Created by xiayiyong on 15/9/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TFBase64)

/**
 *  base64编码
 *
 *  @return 编码后的
 */
- (NSString *)base64Encoding;

/**
 *  base64编码
 *
 *  @param text 需要编码的字符串
 *
 *  @return 编码的
 */
+ (NSString *)base64Encoding:(NSString *)text;

@end
