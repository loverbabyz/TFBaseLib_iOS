//
//  NSData+Base64.h
//  Treasure
//
//  Created by Daniel on 15/9/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (TFBase64)

/**
 *  base64编码
 *
 *  @return 编码后的数据
 */
- (NSString *)base64Encoding;

/**
 *  base64编码
 *
 *  @return 编码后的数据
 */
+ (NSString *)base64Encoding:(NSData*)data;

@end
