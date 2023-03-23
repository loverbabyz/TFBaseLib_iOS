//
//  TFDownloadManager.m
//  TFBaseLib
//
//  Created by Daniel on 15/10/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFDownloadManager.h"
#import "TFAFNetworking.h"

#define  KEY_filePath      @"filePath"
#define  KEY_URLString     @"URLString"
#define  KEY_operation      @"operation"

@interface TFDownloadManager ()

@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, assign) DownloadProgress downloadProgress;

@end

@implementation TFDownloadManager

TFSingletonM(Manager)

- (NSMutableArray *)paths
{
    if (!_paths)
    {
        _paths = [[NSMutableArray alloc] init];
    }
    
    return _paths;
}

#pragma mark - 类方法

+ (unsigned long long)fileSizeForPath:(NSString *)path
{
    return [[self alloc] fileSizeForPath:path];
}

+(void)downloadFileFromURL:(NSString *)URLString
                    folder:(NSString *)folder
                  fileName:(NSString *)fileName
                  progress:(DownloadProgress)progressBlock
                   success:(void (^)(void))successBlock
                   failure:(void (^)(NSError *error))failureBlock;
{
    return [[self class]downloadFileFromURL:URLString
                                     folder:folder
                                   fileName:fileName
                                   progress:progressBlock
                                    success:successBlock
                                    failure:failureBlock];
}

+ (void)cancelWithURL:(NSString *)URLString
{
    [[self class] cancelWithURL:URLString];
}

#pragma mark - 实例方法

- (unsigned long long)fileSizeForPath:(NSString *)path
{
    
    signed long long fileSize = 0;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:path])
    {
        
        NSError *error = nil;
        
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        
        if (!error && fileDict)
        {
            
            fileSize = [fileDict fileSize];
        }
    }
    
    return fileSize;
}

-(void)downloadFileFromURL:(NSString *)URLString
                    folder:(NSString *)folder
                  fileName:(NSString *)fileName
                  progress:(DownloadProgress)progressBlock
                   success:(void (^)(void))successBlock
                   failure:(void (^)(NSError *error))failureBlock
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *fileDir = [NSString stringWithFormat:@"%@/Download/%@", docPath,folder];
    
    BOOL isDir = NO;
    BOOL existed = [fileManager fileExistsAtPath:fileDir isDirectory:&isDir];
    
    if (!(isDir == YES && existed == YES))
    {
        [fileManager createDirectoryAtPath:fileDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [fileDir stringByAppendingPathComponent:fileName];
    
    NSLog(@"download file=%@", filePath);
    
    //    [self cancelWithURL:URLString];
    
    if ([fileManager fileExistsAtPath:filePath])
    {
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    TFAFURLSessionManager *manager = [[TFAFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    
    self.downloadProgress = progressBlock;
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
                                                                     progress:^(NSProgress * _Nonnull downloadProgress){
                                                                         if (progressBlock)
                                                                         {
                                                                             progressBlock([downloadProgress completedUnitCount], [downloadProgress totalUnitCount],0);
                                                                         }
                                                                         
                                                                     }
                                                                  destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                      //return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                      return [NSURL fileURLWithPath:filePath];
                                                                  } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                                                                      
                                                                      if (error)
                                                                      {
                                                                          NSLog(@"Error: %@", error);
                                                                          
                                                                          if (failureBlock)
                                                                          {
                                                                              failureBlock(error);
                                                                          }
                                                                      }
                                                                      else
                                                                      {
                                                                          NSLog(@"%@", response);
                                                                          
                                                                          if (successBlock)
                                                                          {
                                                                              successBlock();
                                                                          }
                                                                      }
                                                                  }];
    
    NSDictionary *dicNew = @{
                             KEY_URLString   : URLString,
                             KEY_filePath    : filePath,
                             KEY_operation   : downloadTask
                             };
    [self.paths addObject:dicNew];
    
    [downloadTask resume];
}

- (void)pauseWithURL:(NSString *)URLString
{
    for (NSDictionary *dic in self.paths)
    {
        if ([URLString isEqualToString:dic[KEY_URLString]])
        {
            id operation=dic[KEY_operation];
            if ([operation isKindOfClass:[NSURLSessionDownloadTask  class]])
            {
                [operation suspend];
            }
        }
    }
}

- (void)cancelWithURL:(NSString *)URLString
{
    for (NSDictionary *dic in self.paths)
    {
        if ([URLString isEqualToString:dic[KEY_URLString]])
        {
            id operation=dic[KEY_operation];
            if ([operation isKindOfClass:[NSURLSessionDownloadTask  class]])
            {
                [operation cancel];
            }
            
            [self.paths removeObject:dic];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (!dic) {
                return;
            }
            NSString *filePath=(NSString *)dic[KEY_filePath];
            if ([fileManager fileExistsAtPath:filePath])
            {
                [fileManager removeItemAtPath:filePath error:nil];
            }
        }
    }
}

@end

