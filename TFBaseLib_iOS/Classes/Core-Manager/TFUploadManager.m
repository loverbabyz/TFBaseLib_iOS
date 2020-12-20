//
//  TFUploadManager.m
//  TFBaseLib
//
//  Created by xiayiyong on 15/10/9.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFUploadManager.h"
#import <AFNetworking/AFNetworking.h>

#define  KEY_URLString     @"URLString"
#define  KEY_operation      @"operation"

@interface TFUploadManager ()

@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic, assign) UploadProgress uploadProgress;
@end

@implementation TFUploadManager

+ (instancetype)sharedManager
{
    static TFUploadManager *sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TFUploadManager alloc] init];
    });
    return sharedInstance;
}

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

+ (void)uploadFileToURL:(nonnull NSString *)URLString
             parameters:(NSDictionary *)parameters
                 header:(NSDictionary *)httpHeader
constructingBodyWithBlock:(nullable void (^)(id formData))block
               progress:(nullable UploadProgress)progressBlock
                success:(nullable void (^)(id backData))successBlock
                failure:(nullable void (^)(NSError *error))failureBlock;
{
    return [[self class]uploadFileToURL:URLString
                             parameters:parameters
                                 header:httpHeader
              constructingBodyWithBlock:block
                               progress:progressBlock
                                success:successBlock
                                failure:failureBlock];
}

+ (void)pauseWithURL:(NSString *)URLString
{
    [[self class] pauseWithURL:URLString];
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

-(void)uploadFileToURL:(NSString *)URLString
constructingBodyWithBlock:(nullable void (^)(id formData))block
            parameters:(NSDictionary *)parameters
                header:(NSDictionary *)httpHeader
              progress:(UploadProgress)progressBlock
               success:(void (^)(id backData))successBlock
               failure:(void (^)(NSError *error))failureBlock;
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]
                                    multipartFormRequestWithMethod:@"POST"
                                    URLString:URLString
                                    parameters:parameters
                                    constructingBodyWithBlock:block
                                    error:nil];
    NSArray *keys=[httpHeader allKeys];;
    NSUInteger count=[keys count];
    
    for (int i = 0; i < count; i++)
    {
        id key = [keys objectAtIndex: i];
        id value = [httpHeader objectForKey: key];
        if (key!=nil && value!=nil)
        {
            [request setValue:value forHTTPHeaderField:key];
        }
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    self.uploadProgress = progressBlock;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request
                                                                       progress:^(NSProgress *progress){
                                                                           if (progressBlock) {
                                                                               progressBlock((CGFloat)progress.completedUnitCount,(CGFloat)progress.completedUnitCount,(CGFloat)progress.totalUnitCount);
                                                                           }
                                                                       }
                                                              completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
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
                                                                      NSLog(@"%@", responseObject);
                                                                      
                                                                      if (successBlock)
                                                                      {
                                                                          successBlock(responseObject);
                                                                      }
                                                                  }
                                                                  
                                                              }];
    
    
    
    NSDictionary *dicNew = @{
                             KEY_URLString   : URLString,
                             KEY_operation   : uploadTask
                             };
    [self.paths addObject:dicNew];
    
    [uploadTask resume];
}

- (void)pauseWithURL:(NSString *)URLString
{
    for (NSDictionary *dic in self.paths)
    {
        if ([URLString isEqualToString:dic[KEY_URLString]])
        {
            id operation=dic[KEY_operation];
            if ([operation isKindOfClass:[NSURLSessionUploadTask  class]])
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
            if ([operation isKindOfClass:[NSURLSessionUploadTask  class]])
            {
                [operation cancel];
            }
            
            [self.paths removeObject:dic];
        }
    }
}

@end

