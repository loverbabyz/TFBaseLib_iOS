//
//  NSObject+Ext.h
//  TFUILib
//
//  Created by Daniel on 16/4/22.
//  Copyright © 2016年 daniel.xiaofei@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifdef __cplusplus
#define TFUI_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define TFUI_EXTERN extern __attribute__((visibility ("default")))
#endif

@interface NSObject (Ext)

/**
 网络状态改变
 */
TFUI_EXTERN NSNotificationName const TFReachabilityDidChangeNotification;

/**
 页面显示
 */
TFUI_EXTERN NSNotificationName const TFViewDidAppearNotification;

/**
 页面即将消失
 */
TFUI_EXTERN NSNotificationName const TFViewWillDisappearNotification;

@end
