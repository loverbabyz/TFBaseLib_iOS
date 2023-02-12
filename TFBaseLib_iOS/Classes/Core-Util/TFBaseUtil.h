//
//  TFBaseUtil.h
//  TFBaseLib
//
//  Created by Daniel on 15/10/20.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "pinyin.h"
#import "TFBaseMacro+Singleton.h"

#define kTFBaseUtil [TFBaseUtil sharedManager]

#define kTFBaseUtilKeyWindow [TFBaseUtil keyWindow];

@interface TFBaseUtil : NSObject

TFSingletonH(Manager)

/**
 Getting keyWindow
 from IQKeyboardManager: https://github.com/hackiftekhar/IQKeyboardManager/blob/master/IQKeyboardManager/IQKeyboardManager.m
 */
+ (UIWindow *)keyWindow;

@end
