//
//  TFBaseMacro+System.h
//  Treasure
//
//  Created by Daniel on 15/9/14.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#if __has_include("TFBaseUtil.h")
#import "TFBaseUtil.h"
#endif

#if __has_include("TFBaseMacro+Path.h")
#import "TFBaseMacro+Path.h"
#endif

/**
 *  手机系统的语言
 */
#ifndef TF_SYSTEM_LANGUAGE
#define TF_SYSTEM_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])
#endif

/**
 *  APP版本
 */
#ifndef TF_APP_VERSION
#define TF_APP_VERSION [[TF_MAIN_BUNDLE infoDictionary] objectForKey:@"CFBundleVersion"]
#endif

/**
 *  APP版本 for short
 */
#ifndef TF_APP_SHORT_VERSION
#define TF_APP_SHORT_VERSION [[TF_MAIN_BUNDLE infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#endif

/**
 *  Main Screen
 */
#ifndef TF_MAIN_SCREEN
#define TF_MAIN_SCREEN [UIScreen mainScreen]
#endif

/**
 *  app的UIApplication
 */
#ifndef TF_APP_APPLICATION
#define TF_APP_APPLICATION [UIApplication sharedApplication]
#endif

/**
 *  app的主window
 */
#ifndef TF_APP_KEY_WINDOW
#define TF_APP_KEY_WINDOW kTFBaseUtilKeyWindow
#endif

/**
 *  app的delegate
 */
#ifndef TF_APP_DELEGATE
#define TF_APP_DELEGATE ((AppDelegate *)[TF_APP_APPLICATION delegate])
#endif

/**
 *   当前设备
 */
#ifndef TF_CURREND_DEVICE
#define TF_CURREND_DEVICE [UIDevice currentDevice]
#endif

/**
 *  手机系统的版本
 */
#ifndef TF_SYSTEM_VERSION
#define TF_SYSTEM_VERSION [TF_CURREND_DEVICE systemVersion]
#endif

/**
 *  手机系统的版本大于或等于指定版本
 */
#ifndef TF_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO
#define TF_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
    ([TF_SYSTEM_VERSION compare:v options:NSNumericSearch] != NSOrderedAscending)
#endif

/**
 *  手机系统的版本小于指定版本
 */
#ifndef TF_SYSTEM_VERSION_LESS_THAN
#define TF_SYSTEM_VERSION_LESS_THAN(v) \
    ([TF_SYSTEM_VERSION compare:v options:NSNumericSearch] == NSOrderedAscending)
#endif

#ifndef TF_iOSVersion
#define TF_iOSVersion ([TF_SYSTEM_VERSION floatValue])
#endif

#ifndef TF_iOS6
#define TF_iOS6 (TF_iOSVersion >= 6.0 && iOSVersion < 7.0)
#endif

#ifndef TF_iOS6_OR_LATER
#define TF_iOS6_OR_LATER (TF_iOSVersion >= 6.0)
#endif

#ifndef TF_iOS7
#define TF_iOS7 (TF_iOSVersion >= 7.0 && TF_iOSVersion < 8.0)
#endif

#ifndef TF_iOS7_OR_LATER
#define TF_iOS7_OR_LATER (TF_iOSVersion >= 7.0)
#endif

#ifndef TF_iOS8
#define TF_iOS8 (TF_iOSVersion >= 8.0 && TF_iOSVersion < 9.0)
#endif

#ifndef TF_iOS8_OR_LATER
#define TF_iOS8_OR_LATER (TF_iOSVersion >= 8.0)
#endif

#ifndef TF_iOS9
#define TF_iOS9 (iOSVersion >= 9.0 && iOSVersion < 10.0)
#endif

#ifndef TF_iOS9_OR_LATER
#define TF_iOS9_OR_LATER (TF_iOSVersion >= 9.0)
#endif

#ifndef TF_iOS10
#define TF_iOS10 (TF_iOSVersion >= 10.0 && TF_iOSVersion < 11.0)
#endif

#ifndef TF_iOS10_OR_LATER
#define TF_iOS10_OR_LATER (TF_iOSVersion >= 10.0)
#endif

#ifndef TF_iOS11
#define TF_iOS11 (TF_iOSVersion >= 11.0 && TF_iOSVersion < 12.0)
#endif

#ifndef TF_iOS11_OR_LATER
#define TF_iOS11_OR_LATER (TF_iOSVersion >= 11.0)
#endif
