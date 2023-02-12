//
//  NSString+Path.m
//  Treasure
//
//  Created by Daniel on 15/9/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "NSString+Path.h"
#import "TFBaseMacro+Path.h"

@implementation NSString (Path)

+ (NSString *)documentPath
{
    return [TF_APP_HOME_PATH stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)tmpPath
{
    return [TF_APP_HOME_PATH stringByAppendingPathComponent:@"tmp"];
}

+ (NSString *)cachePath
{
    return [TF_APP_HOME_PATH stringByAppendingPathComponent:@"Library/Caches"];
}

+ (NSString *)pathWithFileName:(NSString *)fileName
{
    return [self pathWithFileName:fileName ofType:nil];
}

+ (NSString *)pathWithFileName:(NSString *)fileName ofType:(NSString *)type
{
    return [TF_MAIN_BUNDLE pathForResource:fileName ofType:type];
}

@end
