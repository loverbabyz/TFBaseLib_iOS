//
//  TFLogManager.h
//  TFBaseLib
//
//  Created by Daniel on 15/11/4.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFLogManager : NSObject

#define kTFLogManager  ([TFLogManager sharedManager])

+ (instancetype) sharedManager;

/**
 *  自定义保存日志方式
 */
- (void)logWithDeleteInterval:(NSTimeInterval)deleteInterval
                       maxAge:(NSTimeInterval)maxAge
            deleteOnEverySave:(BOOL)deleteOnEverySave
                 saveInterval:(NSTimeInterval)saveInterval
                saveThreshold:(NSUInteger)saveThreshold
               saveLogCalback:(void(^)(NSString *logMessageString))saveLogCalback;

/**
 *  文件方式保存日志方式
 *
 *  @param maximumFileSize         单个文件最大容量(单位：M)
 *  @param rollingFrequency        多长时间自动新建一个文件(单位：小时)
 *  @param maximumNumberOfLogFiles 保存日志的最大数量
 *  @param logDir                  保存路径
 */
- (void)logWithMaximumFileSize:(long long)maximumFileSize
              rollingFrequency:(long long)rollingFrequency
       maximumNumberOfLogFiles:(NSInteger)maximumNumberOfLogFiles
                        logDir:(NSString *)logDir;
@end
