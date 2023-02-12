//
//  TFMacro+Color.h
//  Treasure
//
//  Created by Daniel on 15/9/14.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseMacro+System.h"

typedef void (^VoidBlock)(void);

typedef void (^ErrorBlock)(NSError *error);
typedef void (^ErrorMsgBlock)(NSError *error, NSString *errorMsg);

typedef void (^NotificationBlock)(NSNotification *notification);

typedef void (^BoolBlock)(BOOL result);
typedef void (^BoolMsgBlock)(BOOL result, NSString *errorMsg);

typedef void (^ArrayBlock)(NSArray *resultList);
typedef void (^ArrayMsgBlock)(NSArray *resultList, NSString *errorMsg);

typedef void (^DictionaryBlock)(NSDictionary *resultDict);
typedef void (^DictionaryMsgBlock)(NSDictionary *resultDict, NSString *errorMsg);

typedef void (^NumberBlock)(NSNumber *resultNumber);
typedef void (^NumberMsgBlock)(NSNumber *resultNumber, NSString *errorMsg);

typedef void (^IntegerBlock)(NSInteger resultNumber);
typedef void (^IntegerMsgBlock)(NSInteger resultNumber, NSString *errorMsg);

typedef void (^StringBlock)(NSString *result);
typedef void (^StringMsgBlock)(NSString *result, NSString *errorMsg);

typedef void (^ObjectBlock)(id sender);
typedef void (^ObjectMsgBlock)(id result, NSString *errorMsg);

/**
 *  设置屏幕是否常亮
 *
 *  @param enable
 *
 *  @return
 */
#define IDLETIMERDISABLED(enable) [APP_APPLICATION setIdleTimerDisabled:enable]

/**
 *  宽的缩放比例
 */
#define WIDTH_SCALE (MAIN_SCREEN.bounds.size.width / 320.0)

/**
 *  高的缩放比例
 *
 */
#define HEIGHT_SCALE (MAIN_SCREEN.bounds.size.height / 568.0)

/**
 *  创建数组
 */
#define ARR(...) [NSArray arrayWithObjects:__VA_ARGS__, nil]

/**
 *  创建动态数组
 */
#define MARR(...) [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]

/**
 *  创建字符串
 */
#define STR(string, args...)    [NSString stringWithFormat:string, args]

/**
 *  创建通知
 *
 *  @param name   通知的name
 *  @param object 通知的数据
 *  @param info 通知的数据
 *
 *  @return 创建的通知
 */
#define POST_NOTIFICATION(name, obj, info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info];

/**
 *  判断是真机
 */
#if TARGET_OS_IPHONE
//iPhone Device
#endif

/**
 *  判断是模拟器
 */
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif
