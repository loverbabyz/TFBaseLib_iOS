//
//  NSString+HTML.h
//  Treasure
//
//  Created by Daniel on 15/9/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HTML)

/*!
 * 过滤掉HTML标签
 * @return 返回喜欢去掉所有HTML标签后的字符串
 */
- (NSString *)filteredHtml;

/*!
 * 过滤掉HTML标签
 *
 * @param html HTML内容
 * @return 返回喜欢去掉所有HTML标签后的字符串
 */
+ (NSString *)filterHTML:(NSString *)html;

/**
 *  去掉html格式
 *
 *  @return 处理完后的数据
 */
- (NSString *)removeHtmlFormat;

@end
