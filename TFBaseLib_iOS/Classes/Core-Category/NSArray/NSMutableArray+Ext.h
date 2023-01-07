//
//  NSMutableArray+Ext.h
//  Treasure
//
//  Created by Daniel on 15/7/1.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSArray+Ext.h"

@interface NSMutableArray (Ext)

/**
 *  将两个元素互换位置
 *
 *  @return YES，表示移动成功，NO表示移动失败
 */
- (BOOL)exchangeObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;

@end
