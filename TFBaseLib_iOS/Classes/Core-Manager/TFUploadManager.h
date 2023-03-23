//
//  TFNetworkManager.h
//  Treasure
//
//  Created by Daniel on 15/9/6.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFBaseMacro+Singleton.h"

typedef void(^UploadProgress)(CGFloat progress, CGFloat totalMBRead, CGFloat totalMBExpectedToRead);

@interface TFUploadManager : NSObject

#define kTFUploadManager  ([TFUploadManager sharedManager])

TFSingletonH(Manager)

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
 *  开始上传文件
 *
 *  @param URLString     上传的地址
 *  @param block         请求body
 *  @param progressBlock 进度
 *  @param successBlock  成功
 *  @param failureBlock  失败
 */
+ (void)uploadFileToURL:(NSString *)URLString
             parameters:(NSDictionary *)parameters
                 header:(NSDictionary *)httpHeader
constructingBodyWithBlock:(void (^)(id formData))block
               progress:(UploadProgress)progressBlock
                success:(void (^)(id backData))successBlock
                failure:(void (^)(NSError *error))failureBlock;

/**
 *  暂停上传文件
 */
+ (void)pauseWithURL:(NSString *)URLString;

/**
 *  停止上传文件
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
 *  开始上传文件
 *
 *  @param URLString     上传的地址
 *  @param block         请求body
 *  @param progressBlock 进度
 *  @param successBlock  成功
 *  @param failureBlock  失败
 */
-(void)uploadFileToURL:(NSString *)URLString
constructingBodyWithBlock:(void (^)(id formData))block
            parameters:(NSDictionary *)parameters
                header:(NSDictionary *)httpHeader
              progress:(UploadProgress)progressBlock
               success:(void (^)(id backData))successBlock
               failure:(void (^)(NSError *error))failureBlock;
/**
 *  暂停上传文件
 */
- (void)pauseWithURL:(NSString *)URLString;

/**
 *  停止上传文件
 */
- (void)cancelWithURL:(NSString *)URLString;


@end
