//
//  NSString+Ext.h
//  Treasure
//
//  Created by xiayiyong on 15/7/1.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * 对NSString有用的扩展类
 * 
 * @author huangyibiao
 */
@interface NSString (Ext)

/**
*  去掉左边的空格
*
*  @return 处理后的字符串
*/
- (NSString *)trimLeft;

/**
 *  去掉右边的空格
 *
 *  @return 处理后的字符串
 */
- (NSString *)trimRight;

/**
 *  去掉两边的空格
 *
 *  @return 处理后的字符串
 */
- (NSString *)trim;

/**
 *  去掉所有空格
 *
 *  @return 处理后的字符串
 */
- (NSString *)trimAll;

/**
 *  去掉换行
 *
 *  @return 处理后的字符串
 */
- (NSString *)removeNewLine;

/**
 *  去掉所有字母
 *
 *  @return 处理后的字符串
 */
- (NSString *)trimLetters;

/**
 *  去掉字符中中所有的指定的字符
 *
 *  @param character 指定的字符串
 *
 *  @return 处理后的字符串
 */
- (NSString *)trimCharacter:(unichar)character;

/**
 *  去掉两端的空格
 *
 *  @return 处理后的字符串
 */
- (NSString *)trimWhitespace;

/**
 *  计算行数
 *
 *  @return 返回行数
 */
- (NSUInteger)numberOfLines;

/*!
 * @brief 判断是否是空串
 *
 * @return YES表示是空串，NO表示非空
 */
- (BOOL)isEmpty;

/**
 *  判断去掉两边的空格后是否是空串
 *
 *  @return YES表示是空串，NO表示非空
 */
- (BOOL)isTrimEmpty;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/** 去掉两端空格和换行符 */
- (NSString *)stringByTrimmingBlank;

/*!
 * 添加前缀（不修改self）
 *
 * @param prefix 前缀
 * @return 返回添加后的字符串
 */
- (NSString *)addPrefix:(NSString *)prefix;

/**
 *  添加后缀（不修改self）
 *
 *  @param subfix 后缀
 *
 *  @return 返回添加后的字符串
 */
- (NSString *)addSubfix:(NSString *)subfix;

/**
 *  从指定文件名读取文件内容
 *
 *  @param fileName 文件名，需要带文件类型，如:abc.json
 *
 *  @return 文件内容
 */
+ (NSString *)contentsOfFile:(NSString *)fileName;

/**
 *  读取指定文件名中的字符，并序列化为NSDictionary或NSArray
 *
 *  @param fileName 文件名，需要带文件类型，如:abc.json
 *
 *  @return NSDictionary或NSArra对象
 */
+ (id)jsonDataFromFileName:(NSString *)fileName;

/**
 十进制转换为二进制
 
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal;

/**
 二进制转换成十六进制
 
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary;

/**
 十六进制转换为二进制
 
 @param hex 十六进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByHex:(NSString *)hex;

/**
 二进制转换为十进制
 
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary;

/**
 十六进制转换为字符串
 
 @param data 二进制数
 @return 十六进制字符串
 */
+ (NSString *)hexStringFromData:(NSData*)data;

/// 获取拼音
- (NSString *)toPinYin;

/// 将数字串用指定点位符进行分隔，
/// eg.:13800138000 - > 138 0013 8000
/// @param placeholder 分隔点位符
/// @param span 要分隔的长度
- (NSString *)splitNumberWithPlaceholder:(NSString *)placeholder span:(NSInteger)span;

/// 将数量转为单位万的字符串
+ (NSString *)shiftUnit:(NSInteger)num;

/// 是否为URL
- (BOOL)isURL;

@end
