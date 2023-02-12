//
//  TFBaseUtil+URL.m
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil+URL.h"
#import "TFBaseMacro+System.h"

BOOL tf_canOpenURL(NSString * urlString)
{
    return [TFBaseUtil canOpenURL:urlString];
}

void tf_openURL(NSString* urlString)
{
    return [TFBaseUtil openURL:urlString];
}

@implementation TFBaseUtil (URL)

//打开URL
+(BOOL)canOpenURL:(NSString*)urlString
{
    return [APP_APPLICATION canOpenURL:[NSURL URLWithString:urlString]];
}

+(void)openURL:(NSString*)urlString
{
    [APP_APPLICATION openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
}


@end
