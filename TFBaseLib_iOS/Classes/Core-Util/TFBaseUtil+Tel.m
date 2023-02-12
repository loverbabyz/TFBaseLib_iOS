//
//  TFBaseUtil+Tel.m
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil+Tel.h"
#import "TFBaseMacro+System.h"

BOOL tf_canTel(void)
{
    return [TFBaseUtil canTel];
}

void tf_tel(NSString* phoneNumber)
{
    return[TFBaseUtil tel:phoneNumber];
}

void tf_telprompt(NSString* phoneNumber)
{
    return [TFBaseUtil telprompt:phoneNumber];
}

@implementation TFBaseUtil (Tel)

//拨打电话

+ (BOOL)canTel
{
    return [TF_APP_APPLICATION canOpenURL:[NSURL URLWithString:@"tel:"]];
}

+ (void)tel:(NSString*)phoneNumber
{
    [TF_APP_APPLICATION openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNumber]] options:@{} completionHandler:nil];
}

+ (void)telprompt:(NSString*)phoneNumber
{
    [TF_APP_APPLICATION openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",phoneNumber]] options:@{} completionHandler:nil];
}


@end
