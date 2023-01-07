//
//  TFBaseUtil+Null.h
//  TFBaseLib
//
//  Created by Daniel on 15/10/16.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  移除所有值为null的key-value
 *
 *  @param object 要操作的对象
 *
 *  @return 操作完成的对象
 */
id tf_removeNullFromObject(id object);

@interface TFBaseUtil (Null)

/**
 *  移除所有值为null的key-value
 *
 *  @param object 要操作的对象
 *
 *  @return 操作完成的对象
 */
+ (id)removeNullFromObject:(id)object;

@end
