//
//  TFBaseUtil+System.m
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFBaseUtil+System.h"
#import "TFBaseMacro+System.h"

NSInteger tf_iOSVersion(void)
{
    return [TFBaseUtil iOSVersion];
}

BOOL tf_isiPad(void)
{
    return [TFBaseUtil isiPad];
}

BOOL tf_isiPhone(void)
{
    return [TFBaseUtil isiPhone];
}

BOOL tf_isRetina(void)
{
    return [TFBaseUtil isRetina];
}

BOOL tf_isRetinaHD(void)
{
    return [TFBaseUtil isRetinaHD];
}

BOOL tf_isLandscape(void)
{
    return [TFBaseUtil isLandscape];
}

@implementation TFBaseUtil (System)

+ (NSInteger)iOSVersion
{
    return [SYSTEM_VERSION integerValue];
}

+ (BOOL)isiPad
{
    return CURREND_DEVICE.userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

+ (BOOL)isiPhone
{
    return CURREND_DEVICE.userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

+ (BOOL)isRetina
{
    return [MAIN_SCREEN respondsToSelector:@selector(displayLinkWithTarget:selector:)]
    && (MAIN_SCREEN.scale == 2.0 || MAIN_SCREEN.scale == 3.0);
}

+ (BOOL)isRetinaHD
{
    return [MAIN_SCREEN respondsToSelector:@selector(displayLinkWithTarget:selector:)]
    && (MAIN_SCREEN.scale == 3.0);
}

+ (BOOL)isLandscape
{
    return (UIInterfaceOrientationIsLandscape \
            ([APP_APPLICATION statusBarOrientation]));
}

@end
