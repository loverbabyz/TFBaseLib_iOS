//
//  TFBaseUtil+Other.h
//  TFBaseLib
//
//  Created by xiayiyong on 16/2/4.
//  Copyright © 2016年 daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFBaseUtil.h"

/**
 判读是否为空或输入只有空格
 */
BOOL tf_isEmpty(NSString *string);

/**
 *  禁止输入表情
 */
NSString *tf_disableEmoji(NSString *string);

/**
 *  判断字符串中是否包含表情
 *
 *  @param string 传入字符串
 */
BOOL tf_isContainsEmoji(NSString *string);


@interface TFBaseUtil (Other)

+(void)idleTimerDisabled:(BOOL)enable;

/**
 *  根据类名获取对应的Nib文件
 *
 *  @param className 类名称
 *
 *  @return 返回Nib文件
 */
+ (UIView *)getViewFromNib:(NSString *)className;

/**
 *  字符串是否为空
 *
 *  @param string 传入的字符串
 *
 *  @return YES-为空 / NO-不为空
 */
+(BOOL) isEmpty:(NSString *)string;

/**
 *  禁止输入表情
 */
+(NSString *) disableEmoji:(NSString *)string;

/**
 *  判断输入的字段为表情的时候，用空字符替换。
 */
+(BOOL) isContainsEmoji:(NSString *)string;

@end
