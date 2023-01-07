//
//  TFKeyChain.h
//  TFBaseLib
//
//  Created by Daniel on 15/10/21.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

#define kTFKeyChain  ([TFKeyChain standardKeyChain])

@interface TFKeyChain : NSObject

/**
 *  构造钥匙串
 *
 */
+ (instancetype)standardKeyChain;

@end
