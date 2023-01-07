//
//  TFGCDQueue.h
//  TFBaseLib
//
//  Created by Daniel on 16/3/3.
//  Copyright © 2016年 daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFGCDGroup : NSObject

@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;

#pragma 初始化
- (instancetype)init;

#pragma mark - 用法
- (void)enter;
- (void)leave;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

@end
