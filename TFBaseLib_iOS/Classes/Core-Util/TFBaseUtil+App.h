//
//  TFBaseUtil+App.h
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  判断本机是否安装了某个应用，该应用是自己公司的产品
 *
 *  @param urlSchemes urlSchemes
 *
 *  @return 安装了返回YES否则返回NO
 */
BOOL tf_hasLocalInstallApp(NSString *urlSchemes);

/**
 *  判断能否打开指定的Itunes应用的链接
 *
 *  @param itunesUrlString Itunes应用的链接
 *
 *  @return 可以打开返回YES否则返回NO
 */
BOOL tf_canOpenApp(NSString *itunesUrlString);

/**
 *  在本机调起指定的应用
 *
 *  @param urlSchemes urlSchemes
 */
void tf_openLocalApp(NSString *urlSchemes);

/**
 *  进入APP Store
 *
 *  @param itunesUrlStrin itunesUrlString
 */
void tf_openAppStore(NSString *itunesUrlStrin);

/**
 获取app名称
 */
NSString * tf_appName(void);

@interface TFBaseUtil (App)

/**
*  判断本机是否安装了某个应用，该应用是自己公司的产品
*
*  @param urlSchemes urlSchemes
*
*  @return 安装了返回YES否则返回NO
*/
+ (BOOL)hasLocalInstallApp:(NSString *)urlSchemes;

/**
 *  判断能否打开指定的Itunes应用的链接
 *
 *  @param itunesUrlString Itunes应用的链接
 *
 *  @return 可以打开返回YES否则返回NO
 */
+ (BOOL)canOpenApp:(NSString *)itunesUrlString;

/**
 *  在本机调起指定的应用
 *
 *  @param urlSchemes urlSchemes 
 */
+ (void)openLocalApp:(NSString *)urlSchemes;

/**
 *  进入APP Store
 *
 *  @param itunesUrlString itunesUrlString
 */
+ (void)openAppStore:(NSString *)itunesUrlString;

/**
 获取app名称
 */
+ (NSString *)appName;

@end
