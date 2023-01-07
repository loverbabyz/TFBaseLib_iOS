//
//  NSData+TFEncrypt.h
//  Treasure
//
//  Created by Daniel on 15/9/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (TFEncrypt)

/**
 *  MD2加密算法
 *
 *  @return 处理后的值
 */
- (NSData *)MD2;

/**
 *  MD4加密算法
 *
 *  @return 处理后的值
 */
- (NSData *)MD4;

/**
 *  MD5加密算法
 *
 *  @return 处理后的值
 */
- (NSData *)MD5;

- (NSString *)MD5Hash;

/**
 *  SHA1加密算法
 *
 *  @return 处理后的值
 */
- (NSData *)SHA1;

/**
 *  SHA224加密算法
 *
 *  @return 处理后的值
 */
- (NSData *)SHA224;

/**
 *  SHA256加密算法
 *
 *  @return 处理后的值
 */
- (NSData *)SHA256;

/**
 *  SHA384加密算法
 *
 *  @return 处理后的值
 */
- (NSData *)SHA384;

/**
 *  SHA512加密算法
 *
 *  @return 处理后的值
 */
- (NSData *)SHA512;

/**
 *  AES256加密
 *
 *  @param key   key
 *  @param error error
 *
 *  @return 处理后的值
 */
- (NSData *)AES256EncryptedUsingKey:(id)key error:(NSError **)error;

/**
 *  AES256解密
 *
 *  @param key   key
 *  @param error error
 *
 *  @return 处理后的值
 */

- (NSData *)AES256DecryptedUsingKey:(id)key error:(NSError **)error;

/**
 *  DES加密
 *
 *  @param key   key
 *  @param error error
 *
 *  @return 处理后的值
 */

- (NSData *)DESEncryptedUsingKey:(id)key error:(NSError **)error;

/**
 *  DES解密
 *
 *  @param key   key
 *  @param error error
 *
 *  @return 处理后的值
 */

- (NSData *)DESDecryptedUsingKey:(id)key error:(NSError **)error;

/**
 *  CAST加密
 *
 *  @param key   key
 *  @param error error
 *
 *  @return 处理后的值
 */

- (NSData *)CASTEncryptedUsingKey:(id)key error:(NSError **)error;

/**
 *  CAST解密
 *
 *  @param key   key
 *  @param error error
 *
 *  @return 处理后的值
 */

- (NSData *)CASTDecryptedUsingKey:(id)key error:(NSError **)error;

/**
 *  弱加密算法
 *
 *  @param algorithm algorithm
 *  @param key       key
 *  @param error     error
 *
 *  @return 处理后的值
 */
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                                  error:(CCCryptorStatus *)error;

/**
 *  弱加密算法
 *
 *  @param algorithm algorithm
 *  @param key       key
 *  @param options   options
 *  @param error     error
 *
 *  @return 处理后的值
 */
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                                options:(CCOptions) options
                                  error:(CCCryptorStatus *) error;

/**
 *  弱加密算法
 *
 *  @param algorithm algorithm
 *  @param key       key
 *  @param iv        iv
 *  @param options   options
 *  @param error     error
 *
 *  @return 处理后的值
 */
- (NSData *)dataEncryptedUsingAlgorithm:(CCAlgorithm) algorithm
                                    key:(id)key		// data or string
                   initializationVector:(id)iv		// data or string
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error;

/**
 *  弱解密算法
 *
 *  @param algorithm algorithm
 *  @param key       key
 *  @param error     error
 *
 *  @return 处理后的值
 */
- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                                  error:(CCCryptorStatus *)error;

/**
 *  弱解密算法
 *
 *  @param algorithm algorithm
 *  @param key       key
 *  @param options   options
 *  @param error     error
 *
 *  @return 处理后的值
 */
- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error;

/**
 *  弱解密算法
 *
 *  @param algorithm algorithm
 *  @param key       key
 *  @param iv        iv
 *  @param options   options
 *  @param error     error 
 *
 *  @return 处理后的值
 */
- (NSData *)decryptedDataUsingAlgorithm:(CCAlgorithm)algorithm
                                    key:(id)key		// data or string
                   initializationVector:(id)iv		// data or string
                                options:(CCOptions)options
                                  error:(CCCryptorStatus *)error;

@end
