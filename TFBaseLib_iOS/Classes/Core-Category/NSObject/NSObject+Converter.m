//
//  NSObject+Converter.m
//  SSXQ
//
//  Created by Daniel on 2020/10/13.
//  Copyright © 2020 Daniel.Sun. All rights reserved.
//

#import "NSObject+Converter.h"
#import "MJExtension.h"

@implementation NSObject (Converter)


+ (NSMutableArray *)arrayWithDictionary:(id)dictionary {
    return [self mj_objectArrayWithKeyValuesArray:dictionary];
}

+ (id)modelWithDictionary:(id)dictionary {
    return [self mj_objectWithKeyValues:dictionary];
}

- (void)updateWithDictionary:(id)dictionary {
    [self mj_setKeyValues:dictionary];
}

- (NSString *)toJsonString {
    return [self mj_JSONString];
}

- (NSDictionary *)toJson {
    return [self mj_keyValues];
}

- (NSData *)toData {
    return self.mj_JSONData;
}

@end
