//
//  TFBaseUtil.m
//  TFBaseLib
//
//  Created by Daniel on 15/10/20.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil.h"

@implementation TFBaseUtil

TFSingletonM(Manager)

+ (UIWindow *)keyWindow {
    static __weak UIWindow *cachedKeyWindow = nil;

    /*  (Bug ID: #23, #25, #73)   */
    UIWindow *originalKeyWindow = nil;

    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive && [scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        originalKeyWindow = window;
                        break;
                    }
                }
            }
        }
    } else
    #endif
    {
    #if __IPHONE_OS_VERSION_MIN_REQUIRED < 130000
        originalKeyWindow = [UIApplication sharedApplication].keyWindow;
    #endif
    }

    //If original key window is not nil and the cached keywindow is also not original keywindow then changing keywindow.
    if (originalKeyWindow)
    {
        cachedKeyWindow = originalKeyWindow;
    }

    __strong UIWindow *strongCachedKeyWindow = cachedKeyWindow;

    return strongCachedKeyWindow;
}

+ (NSString *)appDelegateClassString {
    if (NSClassFromString(@"AppDelegate")) {
        /// obj-c
        return @"AppDelegate";
    } else {
        /// swift
        return [NSString stringWithFormat:@"%@.%@", NSBundle.mainBundle.infoDictionary[@"CFBundleExecutable"], @"AppDelegate"];;
    }
}

@end
