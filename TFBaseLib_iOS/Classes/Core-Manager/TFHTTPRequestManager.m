
//
//  TFHTTPManager.m
// Treasure
//
//  Created by Daniel on 15/7/1.
//  Copyright (c) daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFHTTPRequestManager.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreServices/CoreServices.h>

#import "ObjcAssociatedObjectHelpers.h"
#import <AFNetworking/AFNetworking.h>


#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"

typedef int (^RetryDelayCalcBlock)(int, int, int); // int totalRetriesAllowed, int retriesRemaining, int delayBetweenIntervalsModifier
@interface TFHTTPSessionManager : AFHTTPSessionManager

@end

@implementation TFHTTPSessionManager

SYNTHESIZE_ASC_OBJ(__tasksDict, setTasksDict);
SYNTHESIZE_ASC_OBJ(__retryDelayCalcBlock, setRetryDelayCalcBlock);

- (instancetype)initWithBaseURL:(NSURL *)url {
#ifdef DEBUG
    
    // debug 版本的包可以被正常抓取
    self = [super initWithBaseURL:url];
    
#else
    
    // 发起的请求不带cookie和缓存
    NSURLSessionConfiguration *conf = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    conf.connectionProxyDictionary = @{};
    
    self = [super initWithBaseURL:url sessionConfiguration:conf];
    
#endif
    
    return self;
}

- (void)createTasksDict {
    [self setTasksDict:[[NSDictionary alloc] init]];
}

- (void)createDelayRetryCalcBlock {
    RetryDelayCalcBlock block = ^int(int totalRetries, int currentRetry, int delayInSecondsSpecified) {
        return delayInSecondsSpecified;
    };
    [self setRetryDelayCalcBlock:block];
}

- (id)retryDelayCalcBlock {
    if (!self.__retryDelayCalcBlock) {
        [self createDelayRetryCalcBlock];
    }
    return self.__retryDelayCalcBlock;
}

- (id)tasksDict {
    if (!self.__tasksDict) {
        [self createTasksDict];
    }
    return self.__tasksDict;
}

- (NSURLSessionDataTask *)requestUrlWithAutoRetry:(int)retriesRemaining
                                    retryInterval:(int)intervalInSeconds
                           originalRequestCreator:(NSURLSessionDataTask *(^)(void (^)(NSURLSessionDataTask *, NSError *)))taskCreator
                                  originalFailure:(void(^)(NSURLSessionDataTask *, NSError *))failure {
    id taskcreatorCopy = [taskCreator copy];
    void(^retryBlock)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *task, NSError *error) {
        NSMutableDictionary *retryOperationDict = self.tasksDict[taskcreatorCopy];
        int originalRetryCount = [retryOperationDict[@"originalRetryCount"] intValue];
        int retriesRemainingCount = [retryOperationDict[@"retriesRemainingCount"] intValue];
        if (retriesRemainingCount > 0) {
            NSLog(@"AutoRetry: Request failed: %@, retry %d out of %d begining...",
                error.localizedDescription, originalRetryCount - retriesRemainingCount + 1, originalRetryCount);
            void (^addRetryOperation)(void) = ^{
                [self requestUrlWithAutoRetry:retriesRemaining - 1 retryInterval:intervalInSeconds originalRequestCreator:taskCreator originalFailure:failure];
            };
            RetryDelayCalcBlock delayCalc = self.retryDelayCalcBlock;
            int intervalToWait = delayCalc(originalRetryCount, retriesRemainingCount, intervalInSeconds);
            if (intervalToWait > 0) {
                NSLog(@"AutoRetry: Delaying retry for %d seconds...", intervalToWait);
                dispatch_time_t delay = dispatch_time(0, (int64_t)(intervalToWait * NSEC_PER_SEC));
                dispatch_after(delay, dispatch_get_main_queue(), ^(void){
                    addRetryOperation();
                });
            } else {
                addRetryOperation();
            }
        } else {
            NSLog(@"AutoRetry: Request failed %d times: %@", originalRetryCount, error.localizedDescription);
            NSLog(@"AutoRetry: No more retries allowed! executing supplied failure block...");
            failure(task, error);
            NSLog(@"AutoRetry: done.");
        }
    };
    NSURLSessionDataTask *task = taskCreator(retryBlock);
    NSMutableDictionary *taskDict = self.tasksDict[taskcreatorCopy];
    if (!taskDict) {
        taskDict = [NSMutableDictionary new];
        taskDict[@"originalRetryCount"] = [NSNumber numberWithInt:retriesRemaining];
    }
    taskDict[@"retriesRemainingCount"] = [NSNumber numberWithInt:retriesRemaining];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:self.tasksDict];
    newDict[taskcreatorCopy] = taskDict;
    self.tasksDict = newDict;

    return task;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id respo))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry
                retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        return [self GET:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {} success:success failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry
                 retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        return [self HEAD:URLString parameters:parameters headers:nil success:success failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry
                 retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        return [self POST:URLString parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {} success:success failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry
                 retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        return [self POST:URLString parameters:parameters headers:nil constructingBodyWithBlock:block progress:^(NSProgress * _Nonnull uploadProgress) {} success:success failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry
                retryInterval:(int)intervalInSeconds
{

    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        return [self PUT:URLString parameters:parameters headers:nil success:success failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)PATCH:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                        failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                      autoRetry:(int)timesToRetry
                  retryInterval:(int)intervalInSeconds
{

    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        return [self PATCH:URLString parameters:parameters headers:nil success:success failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                       autoRetry:(int)timesToRetry
                   retryInterval:(int)intervalInSeconds
{
    NSURLSessionDataTask *task = [self requestUrlWithAutoRetry:timesToRetry retryInterval:intervalInSeconds originalRequestCreator:^NSURLSessionDataTask *(void (^retryBlock)(NSURLSessionDataTask *, NSError *)) {
        return [self DELETE:URLString parameters:parameters headers:nil success:success failure:retryBlock];
    } originalFailure:failure];
    return task;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id respo))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry {
    return [self GET:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)HEAD:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry {
    return [self HEAD:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry {
    return [self POST:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                     autoRetry:(int)timesToRetry {
    return [self POST:URLString parameters:parameters constructingBodyWithBlock:block success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                    autoRetry:(int)timesToRetry {
    return [self PUT:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
                       autoRetry:(int)timesToRetry {
    return [self DELETE:URLString parameters:parameters success:success failure:failure autoRetry:timesToRetry retryInterval:0];
}


@end

#pragma clang diagnostic pop


#define AFNETWORKING_ALLOW_INVALID_SSL_CERTIFICATES
#define HTTP_DEFAULT_URL            @""
#define DEFAULT_RETRY_NUM           1       //重连次数
#define DEFAULT_TIMEOUT_INTERVAL    20      //超时时间

@interface TFHTTPRequestManager ()

@property (strong, nonatomic) TFHTTPSessionManager *sessionManager;

@end

@implementation TFHTTPRequestManager

+ (instancetype)sharedManager
{
    static TFHTTPRequestManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TFHTTPRequestManager alloc] initTaskPool];
    });
    
    return instance;
}

#pragma mark -
#pragma mark Init Methods

- (instancetype)initTaskPool
{
    self = [super init];
    if (self)
    {
        _baseUrl = @"";
        _requestMethod = HttpRequestMethod_POST;
        
        _sessionManager = [TFHTTPSessionManager manager];
        
        _sessionManager.operationQueue.maxConcurrentOperationCount=10;
        
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        _sessionManager.requestSerializer.timeoutInterval = DEFAULT_TIMEOUT_INTERVAL;
        
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain",@"application/json",@"charset=utf-8",nil];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        
        //allowInvalidCertificates 是否允许无效证书（也就是自建的证书）,默认为NO,如果是需要验证自建证书，需要设置为YES
        securityPolicy.allowInvalidCertificates = YES;
        
        //validatesDomainName 是否需要验证域名，默认为YES；
        //假如证书的域名与你请求的域名不一致，需把该项设置为NO
        //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。
        //因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
        securityPolicy.validatesDomainName = NO;
        
        _sessionManager.securityPolicy = securityPolicy;
    }
    return self;
}

/**
 *  设置http头
 */
+ (void)addHttpHead:(NSDictionary*)httpHeader
{
    if (httpHeader==nil)
    {
        return;
    }
    
    TFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    
    NSArray *keys=[httpHeader allKeys];;
    NSUInteger count=[keys count];
    
    for (int i = 0; i < count; i++)
    {
        id key = [keys objectAtIndex: i];
        id value = [httpHeader objectForKey: key];
        if (key!=nil && value!=nil)
        {
            [manager.requestSerializer setValue:value forHTTPHeaderField:key];
        }
    }
}

/**
 *  设置
 *
 *  @param serializerType RequestSerializerTypeJSON和RequestSerializerTypeHTTP
 */
+ (void)initRequestSerializerType:(RequestSerializerType)serializerType customeRequestSerializer:(id<AFURLRequestSerialization>)customeRequestSerializer
{
    TFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    if (serializerType == RequestSerializerTypeHTTP)
    {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    else if (serializerType == RequestSerializerTypeJSON)
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    } else {
        manager.requestSerializer = customeRequestSerializer;
    }
    
    manager.requestSerializer.timeoutInterval = DEFAULT_TIMEOUT_INTERVAL;
}

/**
 *  设置
 *
 *  @param serializerType RequestSerializerTypeJSON和RequestSerializerTypeHTTP
 */
+ (void)initResponseSerializerType:(ResponseSerializerType)serializerType
{
    TFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    
    switch (serializerType) {
        case ResponseSerializerTypeHTTP:
        {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            break;
            
        case ResponseSerializerTypeJSON:
        {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/json",@"text/plain",@"application/json",@"charset=utf-8",nil];
        }
            break;
            
        case ResponseSerializerTypeCompound:
        {
            manager.responseSerializer = [AFCompoundResponseSerializer serializer];
        }
            break;
    }
}

#pragma mark -
#pragma mark 1

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                               before:nil
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock];
}

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:nil
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:timeOut
                            autoRetry:DEFAULT_RETRY_NUM
             customeRequestSerializer:nil];
}

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                              autoRetry:(int)timesToRetry

{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:nil
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:DEFAULT_TIMEOUT_INTERVAL
                            autoRetry:timesToRetry
             customeRequestSerializer:nil];
}

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
                                timeOut:(int)timeOut
                              autoRetry:(int)timesToRetry
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:nil
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:timeOut
                            autoRetry:timesToRetry
             customeRequestSerializer:nil];
}

#pragma mark -
#pragma mark 2
+ (NSURLSessionDataTask *)doTaskWithURL:(NSString*)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary*)parameters
                                 before:(void (^)(void))beforeBlock
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:HttpRequestMethod_POST
                requestSerializerType:RequestSerializerTypeJSON
               responseSerializerType:ResponseSerializerTypeJSON
                               before:beforeBlock
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock];
}

#pragma mark -
#pragma mark 3
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
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:requestMethod
                requestSerializerType:requestSerializerType
               responseSerializerType:responseSerializerType
                               before:beforeBlock
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:DEFAULT_TIMEOUT_INTERVAL
                            autoRetry:DEFAULT_RETRY_NUM
             customeRequestSerializer:nil];
}

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
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:requestMethod
                requestSerializerType:requestSerializerType
               responseSerializerType:responseSerializerType
                               before:beforeBlock
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:timeOut
                            autoRetry:DEFAULT_RETRY_NUM
             customeRequestSerializer:nil];
}

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
                              autoRetry:(int)timesToRetry
{
    return [[self class]doTaskWithURL:url
                           httpHeader:httpHeader
                           parameters:parameters
                        requestMethod:requestMethod
                requestSerializerType:requestSerializerType
               responseSerializerType:responseSerializerType
                               before:beforeBlock
                              success:successBlock
                              failure:failureBlock
                                error:errorBlock
                              timeOut:DEFAULT_TIMEOUT_INTERVAL
                            autoRetry:timesToRetry
             customeRequestSerializer:nil];
}

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
               customeRequestSerializer:(id)customeRequestSerializer
{
    if (url==nil||[url length]==0)
    {
        if (failureBlock)
        {
            failureBlock(-1,@"url为空");
        }
        
        return nil;
    }
    
    if (![url hasPrefix:@"http"] && ![url hasPrefix:@"https"])
    {
        
        NSString *baseUrl=[[[self class]sharedManager]baseUrl];
        if (baseUrl==nil||[baseUrl length]==0)
        {
            if (failureBlock)
            {
                failureBlock(-1,@"url为错误");
            }
            
            return nil;
        }
        else
        {
            url=[NSString stringWithFormat:@"%@%@",baseUrl,url];
        }
    }
    
    NSMutableDictionary *reqData= [[NSMutableDictionary alloc]initWithDictionary:parameters];
    
    //NSData* jsonRequestData = [NSJSONSerialization dataWithJSONObject:reqData options:kNilOptions error:nil];
    //NSString* jsonRequestString = [[NSString alloc] initWithData:jsonRequestData encoding: NSUTF8StringEncoding];
    //NSLog(@"requesturl=%@?%@",url,jsonRequestString);
    
    [[self class] initRequestSerializerType:requestSerializerType customeRequestSerializer:customeRequestSerializer];
    [[self class] initResponseSerializerType:responseSerializerType];
    [[self class] addHttpHead:httpHeader];
    
    TFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    manager.requestSerializer.timeoutInterval = timeOut;
    
    NSURLSessionDataTask *task=nil;
    
    if (beforeBlock)
    {
        beforeBlock();
    }
    
    switch (requestMethod)
    {
        case HttpRequestMethod_POST:
        {
            task=[manager POST:url
                    parameters:reqData
                       success:^(NSURLSessionDataTask *task, id responseObject)
                  {
                      [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
                  }
                       failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
                  }autoRetry:timesToRetry];
        }
            break;
        case HttpRequestMethod_GET:
        {
            task=[manager GET:url
                   parameters:reqData
                      success:^(NSURLSessionDataTask *task, id responseObject)
                  {
                      [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
                  }
                      failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
                  }autoRetry:timesToRetry];
        }
            break;
        case HttpRequestMethod_DELETE:
        {
            task=[manager DELETE:url
                      parameters:reqData
                         success:^(NSURLSessionDataTask *task, id responseObject)
                  {
                      [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
                  }
                         failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
                  }autoRetry:timesToRetry];
        }
            break;
        case HttpRequestMethod_PUT:
        {
            task=[manager PUT:url
                   parameters:reqData
                      success:^(NSURLSessionDataTask *task, id responseObject)
                  {
                      [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
                  }
                      failure:^(NSURLSessionDataTask *task, NSError *error)
                  {
                      [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
                  }autoRetry:timesToRetry];
        }
            break;
        case HttpRequestMethod_IMAGE:
            
            
            
            break;
        default:
            break;
    }
    
    return task;
    
}

#pragma mark- upload

+ (NSURLSessionDataTask *)doTaskWithURL:(NSString *)url
                             httpHeader:(NSDictionary *)httpHeader
                             parameters:(NSDictionary *)parameters
                               progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
              constructingBodyWithBlock:(void (^)(id))block
                                success:(void (^)(id data))successBlock
                                failure:(void (^)(int errorCode, NSString *errorMessage))failureBlock
                                  error:(void (^)(NSError *error))errorBlock
{
    
    [[self class] initRequestSerializerType:RequestSerializerTypeJSON customeRequestSerializer:nil];
    [[self class] initResponseSerializerType:ResponseSerializerTypeJSON];
    [[self class] addHttpHead:httpHeader];
    if (url==nil||[url length]==0)
    {
        if (failureBlock)
        {
            failureBlock(-1,@"url为空");
        }
        
        return nil;
    }
    
    if (![url hasPrefix:@"http"] && ![url hasPrefix:@"https"])
    {
        
        NSString *baseUrl=[[[self class]sharedManager]baseUrl];
        if (baseUrl==nil||[baseUrl length]==0)
        {
            if (failureBlock)
            {
                failureBlock(-1,@"url为错误");
            }
            
            return nil;
        }
        else
        {
            url=[NSString stringWithFormat:@"%@%@",baseUrl,url];
        }
    }
    
    NSMutableDictionary *reqData=[[NSMutableDictionary alloc]initWithDictionary:parameters];
    
//    NSData* jsonRequestData = [NSJSONSerialization dataWithJSONObject:reqData options:kNilOptions error:nil];
//    NSString* jsonRequestString = [[NSString alloc] initWithData:jsonRequestData encoding: NSUTF8StringEncoding];
//    NSLog(@"requesturl=%@?%@",url,jsonRequestString);
    
    NSURLSessionDataTask *task=nil;
    TFHTTPSessionManager *manager = [[TFHTTPRequestManager sharedManager]sessionManager];
    
    manager.requestSerializer.timeoutInterval = 10;
    
    task = [manager POST:url
              parameters:reqData
                 headers:httpHeader
constructingBodyWithBlock:block
                progress:uploadProgress
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self dosuccess:responseObject success:successBlock failure:failureBlock error:errorBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self dofailure:error success:successBlock failure:failureBlock error:errorBlock];
    }];
    
    return task;
}

#pragma mark- 打印url 和 json数据 httpHeader用于调试

+(void)dosuccess:(id)responseObject
         success:(void (^)(id data))successBlock
         failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
           error:(void (^)(NSError *error))errorBlock
{
    //NSLog(@"JSON: %@", responseObject);
    
    if (successBlock)
    {
        successBlock(responseObject);
    }
}

+(void)dofailure:(NSError *)error
         success:(void (^)(id data))successBlock
         failure:(void (^)(int errorCode, NSString* errorMessage))failureBlock
           error:(void (^)(NSError *error))errorBlock
{
    NSLog(@"ERROR: %@", error);
    
    if (errorBlock)
    {
        errorBlock(error);
    }
}

@end
