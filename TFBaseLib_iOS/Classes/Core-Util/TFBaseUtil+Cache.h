//
//  TFBaseUtil+Cache.h
//  TFBaseLib
//
//  Created by Daniel on 15/10/14.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFBaseUtil.h"

/**
 *  信息本地化
 */
void tf_saveValue(id value, NSString *key);
id tf_getValueWithKey(NSString *key);

/**
 *  对象信息本地化，要保存的对象，需要实现方法 
 - (void)encodeWithCoder:(NSCoder *)encoder  
 - (id)initWithCoder:(NSCoder *)decoder
 */
void tf_saveObject(id obj, NSString *key);
id tf_getObjectWithKey(NSString *key);

/**
 *  按照key值删除
 */
void tf_removeObjectWithKey(NSString *key);

@interface TFBaseUtil (Cache)

/**
 *  信息本地化
 */
+ (void) saveValue:(id)value key:(NSString *)key;
+ (id) getValueWithKey:(NSString *)key;

/**
 *  对象信息本地化，要保存的对象，需要实现方法 
 - (void)encodeWithCoder:(NSCoder *)encoder  
 - (id)initWithCoder:(NSCoder *)decoder
 */
+ (void)saveObject:(id)obj key:(NSString *)key;
+ (id)getObjectWithKey:(NSString *)key;

/**
 *  按照key值删除
 */
+ (void) removeObjectWithKey:(NSString *)key;


@end
