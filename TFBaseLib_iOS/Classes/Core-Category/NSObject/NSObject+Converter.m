//
//  NSObject+Converter.m
//  SSXQ
//
//  Created by Daniel on 2020/10/13.
//  Copyright © 2020 Daniel.Sun. All rights reserved.
//

#import "NSObject+Converter.h"
#import "TFMJExtension.h"

@implementation NSObject (Converter)


+ (NSMutableArray *)arrayWithDictionary:(id)dictionary {
    return [self tf_mj_objectArrayWithKeyValuesArray:dictionary];
}

+ (id)modelWithDictionary:(id)dictionary {
    return [self tf_mj_objectWithKeyValues:dictionary];
}

- (void)updateWithDictionary:(id)dictionary {
    [self tf_mj_setKeyValues:dictionary];
}

- (NSString *)toJsonString {
    return [self tf_mj_JSONString];
}

- (NSDictionary *)toJson {
    return [self tf_mj_keyValues];
}

- (NSData *)toData {
    return self.tf_mj_JSONData;
}

@end
