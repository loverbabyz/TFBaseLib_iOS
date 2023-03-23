//
//  NSObject+TFMJProperty.h
//  MJExtensionExample
//
//  Created by MJ Lee on 15/4/17.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFMJExtensionConst.h"

@class TFMJProperty;

/**
 *  遍历成员变量用的block
 *
 *  @param property 成员的包装对象
 *  @param stop   YES代表停止遍历，NO代表继续遍历
 */
typedef void (^TFMJPropertiesEnumeration)(TFMJProperty *property, BOOL *stop);

/** 将属性名换为其他key去字典中取值 */
typedef NSDictionary * (^TFMJReplacedKeyFromPropertyName)(void);
typedef id (^TFMJReplacedKeyFromPropertyName121)(NSString *propertyName);
/** 数组中需要转换的模型类 */
typedef NSDictionary * (^TFMJObjectClassInArray)(void);
/** 用于过滤字典中的值 */
typedef id (^TFMJNewValueFromOldValue)(id object, id oldValue, TFMJProperty *property);

/**
 * 成员属性相关的扩展
 */
@interface NSObject (TFMJProperty)
#pragma mark - 遍历
/**
 *  遍历所有的成员
 */
+ (void)tf_mj_enumerateProperties:(TFMJPropertiesEnumeration)enumeration;

#pragma mark - 新值配置
/**
 *  用于过滤字典中的值
 *
 *  @param newValueFormOldValue 用于过滤字典中的值
 */
+ (void)tf_mj_setupNewValueFromOldValue:(TFMJNewValueFromOldValue)newValueFormOldValue;
+ (id)tf_mj_getNewValueFromObject:(__unsafe_unretained id)object oldValue:(__unsafe_unretained id)oldValue property:(__unsafe_unretained TFMJProperty *)property;

#pragma mark - key配置
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName 将属性名换为其他key去字典中取值
 */
+ (void)tf_mj_setupReplacedKeyFromPropertyName:(TFMJReplacedKeyFromPropertyName)replacedKeyFromPropertyName;
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @param replacedKeyFromPropertyName121 将属性名换为其他key去字典中取值
 */
+ (void)tf_mj_setupReplacedKeyFromPropertyName121:(TFMJReplacedKeyFromPropertyName121)replacedKeyFromPropertyName121;

#pragma mark - array model class配置
/**
 *  数组中需要转换的模型类
 *
 *  @param objectClassInArray          数组中需要转换的模型类
 */
+ (void)tf_mj_setupObjectClassInArray:(TFMJObjectClassInArray)objectClassInArray;
@end
