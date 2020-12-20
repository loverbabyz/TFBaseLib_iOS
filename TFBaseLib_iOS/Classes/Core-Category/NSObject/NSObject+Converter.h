//
//  NSObject+Converter.h
//  SSXQ
//
//  Created by Daniel on 2020/10/13.
//  Copyright © 2020 Daniel.Sun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Converter)

/// 字典数组转模型数组
/// @param dictionary 可以是String, NSData, NSDictionary
+ (NSMutableArray *)arrayWithDictionary:(id)dictionary;

/// 字典转model
/// @param dictionary 可以是String, NSData, NSDictionary
+ (id)modelWithDictionary:(id)dictionary;

/// 更新模型的值
/// @param dictionary 可以是String, NSData, NSDictionary
- (void)updateWithDictionary:(id)dictionary;

/// 模型转换为josn字符串
- (NSString *)toJsonString;

/// 模型转换为字典
- (NSDictionary *)toJson;

/// 模型转换data
- (NSData*)toData;

@end

NS_ASSUME_NONNULL_END
