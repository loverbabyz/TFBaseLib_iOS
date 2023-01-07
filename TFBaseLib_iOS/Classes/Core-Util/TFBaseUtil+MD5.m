//
//  TFBaseUtil+MD5.m
//  TFBaseLib
//
//  Created by Daniel on 15/10/13.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil+MD5.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "NSString+TFEncrypt.h"

NSString *tf_md5(NSString *string)
{
    return [TFBaseUtil md5:string];
}

@implementation TFBaseUtil (MD5)

+(NSString *)md5:(NSString *)string
{
    return [string md5];
}

@end
