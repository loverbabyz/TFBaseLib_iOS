//
//  TFBaseUtil+URL.h
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFBaseUtil.h"

/**
 *  判断是否可以打开连接
 *
 *  @param urlString urlString
 *
 *  @return 可以返回YES不可以返回NO
 */
BOOL tf_canOpenURL(NSString * urlString);

/**
 *  打开URL
 *
 *  @param urlString urlString
 */
void tf_openURL(NSString* urlString);

@interface TFBaseUtil (URL)

/**
 *  判断是否可以打开连接
 *
 *  @param urlString urlString
 *
 *  @return 可以返回YES不可以返回NO
 */
+(BOOL)canOpenURL:(NSString*)urlString;

/**
 *  打开URL
 *
 *  @param urlString urlString 
 */
+(void)openURL:(NSString*)urlString;

@end
