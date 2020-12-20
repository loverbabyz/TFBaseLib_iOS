//
//  NSString+TFEncrypt.m
//  UIDeviceAddition
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "NSString+TFEncrypt.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(TFEncrypt)


- (NSString *)md5 {
    if (self == nil || [self length] == 0)
    {
        return nil;
    }
    
    NSMutableString *md5String = [NSMutableString string];
    const char *cString = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cString, (CC_LONG)strlen(cString), result);
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [md5String appendFormat:@"%02x",result[i]];
    }
    return md5String;
}

- (NSString *)SHA1 {
    if (self == nil || [self length] == 0)
    {
        return nil;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH], i;
    CC_SHA1([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for ( i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)SHA256 {
    if (self == nil || [self length] == 0)
    {
        return nil;
    }
    
    unsigned char digest[CC_SHA256_DIGEST_LENGTH], i;
    CC_SHA256([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)SHA512 {
    if (self == nil || [self length] == 0)
    {
        return nil;
    }
    
    unsigned char digest[CC_SHA512_DIGEST_LENGTH], i;
    CC_SHA512([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_SHA512_DIGEST_LENGTH; i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}

- (NSString *)XOR {
    NSData *originalData = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *sourceDataPoint = (Byte *)[originalData bytes];
    for (int i = 0; i < originalData.length; i++) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        // 与(&)、非(~)、或(|)、异或(^)
        sourceDataPoint[i] ^= 1;
#pragma clang diagnostic pop
    }
    
    return [[NSString alloc] initWithData:originalData encoding:NSUTF8StringEncoding];
}

@end
