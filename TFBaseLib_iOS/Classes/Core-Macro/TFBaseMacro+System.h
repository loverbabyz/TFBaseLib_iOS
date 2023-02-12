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
 *   当前设备
 */
#define CURREND_DEVICE     [UIDevice currentDevice]

/**
 *  手机系统的版本
 */
#define SYSTEM_VERSION   [CURREND_DEVICE systemVersion]

/**
 *  手机系统的语言
 */
#define SYSTEM_LANGUAGE  ([[NSLocale preferredLanguages] objectAtIndex:0])

/**
 *  APP版本
 */
#define APP_VERSION      [[MAIN_BUNDLE infoDictionary] objectForKey:@"CFBundleVersion"]

/**
 *  APP版本 for short
 */
#define APP_SHORT_VERSION   [[MAIN_BUNDLE infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/**
 *  Main Screen
 */
#define MAIN_SCREEN     [UIScreen mainScreen]

/**
 *  app的UIApplication
 */
#define APP_APPLICATION     [UIApplication sharedApplication]

/**
 *  app的主window
 */
#define APP_KEY_WINDOW     kTFBaseUtilKeyWindow

/**
 *  app的delegate
 */
#define APP_DELEGATE     ((AppDelegate *)[APP_APPLICATION delegate])

/**
 *  系统版本是ios9
 */
#define TARGET_IOS9X     [CURREND_DEVICE_SYSTEM_VERSION floatValue] >=9.0f

/**
 *  系统版本是ios8
 */
#define TARGET_IOS8X     [CURREND_DEVICE_SYSTEM_VERSION floatValue] >=8.0f

/**
 *  系统版本是ios7
 */
#define TARGET_IOS7X     [CURREND_DEVICE_SYSTEM_VERSION floatValue] >=7.0f

/**
 *  设备是手机5
 */
#define TARGET_IPHONE     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/**
 *  设备是iPad
 */
#define TARGET_IPAD       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/**
 *  设备是模拟器
 */
#define TARGET_SIMULATOR  (NSNotFound != [[CURREND_DEVICE model] rangeOfString:@"Simulator"].location)
/**
 *  设备是iPhone4
 */
#define TARGET_IPHONE_4   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [MAIN_SCREEN currentMode].size) : NO)

/**
 *  设备是iPhone5
 */
#define TARGET_IPHONE_5   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [MAIN_SCREEN currentMode].size) : NO)

/**
 *  设备是iPhone6
 */
#define TARGET_IPHONE_6   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334),[MAIN_SCREEN currentMode].size) : NO)

/**
 *  设备是iPhone6P
 */
#define TARGET_IPHONE_6PLUS    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208),[MAIN_SCREEN currentMode].size) : NO)

/**
 *  设备是iPhone8
 */
#define TARGET_IPHONE_X   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436),[MAIN_SCREEN currentMode].size) : NO)

