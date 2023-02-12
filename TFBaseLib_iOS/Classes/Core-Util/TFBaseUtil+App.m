//
//  TFBaseUtil+App.m
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFBaseUtil+App.h"
#import "TFBaseMacro+System.h"
#import "TFBaseMacro+Path.h"

BOOL tf_hasLocalInstallApp(NSString *urlSchemes)
{
    return [TFBaseUtil hasLocalInstallApp:urlSchemes];
}

BOOL tf_canOpenApp(NSString *itunesUrlString)
{
    return [TFBaseUtil canOpenApp:itunesUrlString];
}

void tf_openLocalApp(NSString *urlSchemes)
{
    return [TFBaseUtil openLocalApp:urlSchemes];
}

void tf_openAppStore(NSString *itunesUrlStrin)
{
    return[TFBaseUtil openAppStore:itunesUrlStrin];
}

NSString * tf_appName()
{
    return [TFBaseUtil appName];
}

@implementation TFBaseUtil (App)

+ (BOOL)hasLocalInstallApp:(NSString *)urlSchemes
{
    if ([TF_APP_APPLICATION canOpenURL:[NSURL URLWithString:urlSchemes]])
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)canOpenApp:(NSString *)itunesUrlString
{
    if ([TF_APP_APPLICATION canOpenURL:[NSURL URLWithString:itunesUrlString]])
    {
        return YES;
    }
    
    return NO;
}

+ (void)openLocalApp:(NSString *)urlSchemes
{
    if ([self canOpenApp:urlSchemes])
    {
        [TF_APP_APPLICATION openURL:[NSURL URLWithString:urlSchemes] options:@{} completionHandler:nil];
    }
}

+ (void)openAppStore:(NSString *)itunesUrlString
{
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"虚拟机不支持APP Store.打开iTunes不会有效果。");
#else
    [TF_APP_APPLICATION openURL:[NSURL URLWithString:itunesUrlString] options:@{} completionHandler:nil];
#endif
    return;
}

+ (NSString *)appName
{
    return [TF_MAIN_BUNDLE objectForInfoDictionaryKey:@"CFBundleDisplayName"] ? [TF_MAIN_BUNDLE objectForInfoDictionaryKey:@"CFBundleDisplayName"] : [TF_MAIN_BUNDLE objectForInfoDictionaryKey:@"CFBundleName"];
}

@end
