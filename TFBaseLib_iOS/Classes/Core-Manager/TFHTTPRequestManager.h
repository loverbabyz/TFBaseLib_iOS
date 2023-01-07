//
//  TFHTTPManager.h
// Treasure
//
//  Created by Daniel on 15/7/1.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFHTTPRequestManager : NSObject

#define kTFHTTPManager  ([TFHTTPManager sharedManager])

typedef NS_ENUM(NSInteger, HttpRequestMethod)
{
    HttpRequestMethod_POST=0,
    HttpRequestMethod_GET,
    HttpRequestMethod_DELETE,
    HttpRequestMethod_PUT,
    HttpRequestMethod_IMAGE,
};

typedef NS_ENUM(NSInteger, RequestSerializerType)
{
    RequestSerializerTypeJSON = 0,
    RequestSerializerTypeHTTP,
    RequestSerializerTypeCUSTOME
};

typedef NS_ENUM(NSInteger, ResponseSerializerType)
{
    ResponseSerializerTypeJSON = 0,
    ResponseSerializerTypeHTTP,
    ResponseSerializerTypeCompound
};

+ (instancetype) sharedManager;

//自动重连次数
@property (nonatomic, assign) NSInteger reconnectNum;

//HTTP请求的方法..
@property (nonatomic, assign) HttpRequestMethod requestMethod;

//服务器地址BaseUrl
@property (nonatomic, strong) NSString *baseUrl;

/**
 *  网络请求 默认POST
 *
 *  @param url url
 *  @param parameters parameters
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 *  @param errorBlock errorBlock
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock;

/**
 *  网络请求带超时时间 默认POST
 *
 *  @param url          url
 *  @param httpHeader   请求的头
 *  @param parameters   parameters
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 *  @param errorBlock   errorBlock
 *  @param timeOut      timeOut
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut;

/**
 *  网络请求带自动重连次数 默认POST
 *
 *  @param url          url
 *  @param httpHeader   httpHeader
 *  @param parameters   parameters
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 *  @param errorBlock   errorBlock
 *  @param timesToRetry timesToRetry
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                              autoRetry:(int)timesToRetry;

/**
 *  网络请求同时带重连次数和超时时间 默认POST
 *
 *  @param url          url
 *  @param httpHeader   httpHeader
 *  @param parameters   parameters
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 *  @param errorBlock   errorBlock
 *  @param timeOut      timeOut
 *  @param timesToRetry timesToRetry
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut
                              autoRetry:(int)timesToRetry;

/**
 *  网络请求带before 默认POST
 *
 *  @param url url
 *  @param parameters parameters
 *  @param beforeBlock beforeBlock
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 *  @param errorBlock errorBlock
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock;

/**
 *  网络请求自定义请求方式
 *
 *  @param url url
 *  @param parameters parameters
 *  @param requestMethod requestMethod
 *  @param requestSerializerType serializerType
 *  @param beforeBlock beforeBlock
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 *  @param errorBlock errorBlock
 *
 *  @return NSURLSessionDataTask
 */

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                          requestMethod:(HttpRequestMethod)requestMethod
                  requestSerializerType:(RequestSerializerType)requestSerializerType
                 responseSerializerType:(ResponseSerializerType)responseSerializerType
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock;

/**
 *  网络请求自定义重连次数和超时时间 默认POST
 *
 *  @param url                    url
 *  @param httpHeader             httpHeader
 *  @param parameters             parameters
 *  @param requestMethod          requestMethod
 *  @param requestSerializerType  requestSerializerType
 *  @param responseSerializerType responseSerializerType
 *  @param beforeBlock            beforeBlock
 *  @param successBlock           successBlock
 *  @param failureBlock           failureBlock
 *  @param errorBlock             errorBlock
 *  @param timeOut                timeOut
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                          requestMethod:(HttpRequestMethod)requestMethod
                  requestSerializerType:(RequestSerializerType)requestSerializerType
                 responseSerializerType:(ResponseSerializerType)responseSerializerType
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut;

/**
 *  网络请求自定义请求方式和重连次数 默认POST
 *
 *  @param url                    url
 *  @param httpHeader             httpHeader
 *  @param parameters             parameters
 *  @param requestMethod          requestMethod
 *  @param requestSerializerType  requestSerializerType
 *  @param responseSerializerType responseSerializerType
 *  @param beforeBlock            beforeBlock
 *  @param successBlock           successBlock
 *  @param failureBlock           failureBlock
 *  @param errorBlock             errorBlock
 *  @param timesToRetry           timesToRetry
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                          requestMethod:(HttpRequestMethod)requestMethod
                  requestSerializerType:(RequestSerializerType)requestSerializerType
                 responseSerializerType:(ResponseSerializerType)responseSerializerType
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                              autoRetry:(int)timesToRetry;

/**
 *  网络请求所有参数 默认POST
 *
 *  @param url                    url
 *  @param httpHeader             httpHeader
 *  @param parameters             parameters
 *  @param requestMethod          requestMethod
 *  @param requestSerializerType  requestSerializerType
 *  @param responseSerializerType responseSerializerType
 *  @param beforeBlock            beforeBlock
 *  @param successBlock           successBlock
 *  @param failureBlock           failureBlock
 *  @param errorBlock             errorBlock
 *  @param timeOut                timeOut
 *  @param timesToRetry           timesToRetry
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                          requestMethod:(HttpRequestMethod)requestMethod
                  requestSerializerType:(RequestSerializerType)requestSerializerType
                 responseSerializerType:(ResponseSerializerType)responseSerializerType
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut
                              autoRetry:(int)timesToRetry
               customeRequestSerializer:(id)customeRequestSerializer;

/**
 *  网络请求body请求 默认POST
 *
 *  @param url          url
 *  @param parameters   parameters
 *  @param block        block
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 *  @param errorBlock   errorBlock
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString *)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary *)parameters
                               progress:(void (^)(NSProgress *))uploadProgress
              constructingBodyWithBlock:(void (^)(id))block
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString *errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock;

/**
 设置自定义请求序列化器

 @param customeHTTPRequestSerializer AFHTTPRequestSerializer子类
 */
//- (void)setCustomeHTTPRequestSerializer:(AFHTTPRequestSerializer *)customeHTTPRequestSerializer;

@end
