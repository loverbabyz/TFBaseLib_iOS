//
//  TFBaseUtil+AES.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/13.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil.h"

NSString* tf_aes256Encrypt(NSString* string, const void *key);

NSString* tf_aes256Decrypt(NSString* base64EncodedString, const void *key);

NSString* tf_aes256EncryptByKey(NSString* string, const void *key);
NSString*  tf_aes256DecryptByKey(NSString* base64EncodedString, const void *key);


@interface TFBaseUtil (AES)

+ (NSData *)aesKeyForPassword:(NSString *)password;

/**
 *  加密方法
 *
 *  @param message  需要加密的内容
 *  @param password 加密的password
 */
+ (NSString *)aes256Encrypt:(NSString *)message password:(NSString *)password;

/**
 *  解密方法
 *
 *  @param base64EncodedString 密文
 *  @param password            解密的password
 */
+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString password:(NSString *)password;

/**
 *  加密方法
 *
 *  @param message 需要加密的内容
 *  @param keyByte 加密的key
 */
+ (NSString *)aes256Encrypt:(NSString *)message keyByte:(const void *)keyByte;

/**
 *  解密方法
 *
 *  @param base64EncodedString 密文
 *  @param keyByte             解密的key
 */
+ (NSString *)aes256Decrypt:(NSString *)base64EncodedString keyByte:(const void *)keyByte; 

@end
