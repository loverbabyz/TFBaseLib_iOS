//
//  NSString+MJExtension.h
//  MJExtensionExample
//
//  Created by MJ Lee on 15/6/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFMJExtensionConst.h"

@interface NSString (TFMJExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)tf_mj_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)tf_mj_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)tf_mj_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)tf_mj_firstCharLower;

- (BOOL)tf_mj_isPureInt;

- (NSURL *)tf_mj_url;
@end
