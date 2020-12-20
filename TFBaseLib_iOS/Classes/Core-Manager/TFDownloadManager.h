//
//  TFDownloadManager.h
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownloadProgress)(CGFloat progress, CGFloat totalMBRead, CGFloat totalMBExpectedToRead);

@interface TFDownloadManager : NSObject

#define kTFDownloadManager  ([TFDownloadManager sharedManager])

+ (instancetype) sharedManager;

#pragma mark - 类方法

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
+ (unsigned long long)fileSizeForPath:(NSString *)path;

/**
 *  开始下载文件
 *
 *  @param URLString     文件链接
 *  @param folder        文件夹
 *  @param fileName          文件名
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 */
+ (void)downloadFileFromURL:(NSString *)URLString
                     folder:(NSString *)folder
                   fileName:(NSString *)fileName
                   progress:(DownloadProgress)progressBlock
                    success:(void (^)(void))successBlock
                    failure:(void (^)(NSError *error))failureBlock;

/**
 *  取消请求根据url
 *
 *  @param URLString 要取消的URL
 */
+ (void)cancelWithURL:(NSString *)URLString;

#pragma mark - 实例方法

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeForPath:(NSString *)path;

/**
 *  开始下载文件
 *
 *  @param URLString     文件链接
 *  @param folder        文件夹
 *  @param fileName          文件名
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 */
- (void)downloadFileFromURL:(NSString *)URLString
                     folder:(NSString *)folder
                   fileName:(NSString *)fileName
                   progress:(DownloadProgress)progressBlock
                    success:(void (^)(void))successBlock
                    failure:(void (^)(NSError *error))failureBlock;

/**
 *  暂停下载文件
 */
- (void)pauseWithURL:(NSString *)URLString;

/**
 *  停止下载文件
 */
- (void)cancelWithURL:(NSString *)URLString;


@end

