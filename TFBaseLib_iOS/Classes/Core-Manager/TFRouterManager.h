//
//  TFRouterManager.h
//  Treasure
//
//  Created by Daniel on 16/5/17.
//  Copyright © 2020年 daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  路由管理类
 */
@interface TFRouterManager : NSObject

/// scheme
@property (nonatomic, copy, readonly) NSString *scheme;

/// host
@property (nonatomic, copy, readonly) NSString *host;

+ (instancetype)sharedManager;

@end

