//
//  NSObject+TFMJClass.h
//  MJExtensionExample
//
//  Created by MJ Lee on 15/8/11.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  遍历所有类的block（父类）
 */
typedef void (^TFMJClassesEnumeration)(Class c, BOOL *stop);

/** 这个数组中的属性名才会进行字典和模型的转换 */
typedef NSArray * (^TFMJAllowedPropertyNames)(void);
/** 这个数组中的属性名才会进行归档 */
typedef NSArray * (^TFMJAllowedCodingPropertyNames)(void);

/** 这个数组中的属性名将会被忽略：不进行字典和模型的转换 */
typedef NSArray * (^TFMJIgnoredPropertyNames)(void);
/** 这个数组中的属性名将会被忽略：不进行归档 */
typedef NSArray * (^TFMJIgnoredCodingPropertyNames)(void);

/**
 * 类相关的扩展
 */
@interface NSObject (TFMJClass)
/**
 *  遍历所有的类
 */
+ (void)tf_mj_enumerateClasses:(TFMJClassesEnumeration)enumeration;
+ (void)tf_mj_enumerateAllClasses:(TFMJClassesEnumeration)enumeration;

#pragma mark - 属性白名单配置
/**
 *  这个数组中的属性名才会进行字典和模型的转换
 *
 *  @param allowedPropertyNames          这个数组中的属性名才会进行字典和模型的转换
 */
+ (void)tf_mj_setupAllowedPropertyNames:(TFMJAllowedPropertyNames)allowedPropertyNames;

/**
 *  这个数组中的属性名才会进行字典和模型的转换
 */
+ (NSMutableArray *)tf_mj_totalAllowedPropertyNames;

#pragma mark - 属性黑名单配置
/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 *
 *  @param ignoredPropertyNames          这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (void)tf_mj_setupIgnoredPropertyNames:(TFMJIgnoredPropertyNames)ignoredPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行字典和模型的转换
 */
+ (NSMutableArray *)tf_mj_totalIgnoredPropertyNames;

#pragma mark - 归档属性白名单配置
/**
 *  这个数组中的属性名才会进行归档
 *
 *  @param allowedCodingPropertyNames          这个数组中的属性名才会进行归档
 */
+ (void)tf_mj_setupAllowedCodingPropertyNames:(TFMJAllowedCodingPropertyNames)allowedCodingPropertyNames;

/**
 *  这个数组中的属性名才会进行字典和模型的转换
 */
+ (NSMutableArray *)tf_mj_totalAllowedCodingPropertyNames;

#pragma mark - 归档属性黑名单配置
/**
 *  这个数组中的属性名将会被忽略：不进行归档
 *
 *  @param ignoredCodingPropertyNames          这个数组中的属性名将会被忽略：不进行归档
 */
+ (void)tf_mj_setupIgnoredCodingPropertyNames:(TFMJIgnoredCodingPropertyNames)ignoredCodingPropertyNames;

/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSMutableArray *)tf_mj_totalIgnoredCodingPropertyNames;

#pragma mark - 内部使用
+ (void)tf_mj_setupBlockReturnValue:(id (^)(void))block key:(const char *)key;
@end
