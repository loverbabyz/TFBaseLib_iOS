//
//  TFBaseUtil+Identifier.h
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  获取Identifier
 *
 *  @return Identifier
 */
NSString *tf_uniqueIdentifier(void);

@interface TFBaseUtil (Identifier)

/**
 *  获取Identifier
 *
 *  @return Identifier
 */
+ (NSString *)uniqueIdentifier;

@end
