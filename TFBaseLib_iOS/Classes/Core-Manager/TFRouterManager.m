//
//  TFRouterManager.m
//  Treasure
//
//  Created by Daniel on 16/5/17.
//  Copyright © 2020年 daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFRouterManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "TFAspects.h"
#import "NSString+Ext.h"
#import "DeepLinkKit.h"
#import "TFBaseMacro+Path.h"

@interface TFRouterManager()

@property (nonatomic, strong) DPLDeepLinkRouter *router;

@end
@implementation TFRouterManager

+ (void)load {
    [super load];
    [[self class] checkAppDelegate];
    [[self class] trackAppDelegate];
}

+ (void)checkAppDelegate {
    Class cls=NSClassFromString(@"AppDelegate");
    
    SEL cmd1 = @selector(application:handleOpenURL:);
    SEL cmd2 = @selector(application:openURL:sourceApplication:annotation:);
    
    Method method1 = class_getInstanceMethod(cls, cmd1);
    Method method2 = class_getInstanceMethod(cls, cmd2);
    
    if (!method1) {
        class_addMethod(cls, cmd1, (IMP)dynamicMethod1_router, "v@:@@");
    }
    
    if (!method2) {
        class_addMethod(cls, cmd2, (IMP)dynamicMethod2_router, "v@:@@@@");
    }
}

BOOL dynamicMethod1_router(id _self, SEL cmd,UIApplication *application ,NSURL *url) {
    return YES;
}

BOOL dynamicMethod2_router(id _self, SEL cmd,UIApplication *application ,NSURL *url, NSString *sourceApplication,id annotation) {
    return YES;
}

+ (void)trackAppDelegate {
    [NSClassFromString(@"AppDelegate")
     tf_aspect_hookSelector:@selector(application:didFinishLaunchingWithOptions:)
     withOptions:TFAspectPositionBefore
     usingBlock:^(id<TFAspectInfo> aspectInfo, id application,id launchOptions){
        // Route registration.
        [[TFRouterManager sharedManager] routeRegistion];
        
        return YES;
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     tf_aspect_hookSelector:@selector(application:handleOpenURL:)
     withOptions:TFAspectPositionBefore
     usingBlock:^(id<TFAspectInfo> aspectInfo, id application, id url){
        BOOL result = [[TFRouterManager sharedManager].router handleURL:url withCompletion:nil];
        
        return result;
     }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     tf_aspect_hookSelector:@selector(application:openURL:sourceApplication:annotation:)
     withOptions:TFAspectPositionBefore
     usingBlock:^(id<TFAspectInfo> aspectInfo, id application, id url, id sourceApplication, id annotation){
        BOOL result = [[TFRouterManager sharedManager].router handleURL:url withCompletion:nil];
        
        return result;
    }
     error:NULL];
    
    /// NOTE: 9.0以后使用新API接口
    [NSClassFromString(@"AppDelegate")
     tf_aspect_hookSelector:@selector(application:openURL:options:)
     withOptions:TFAspectPositionBefore
     usingBlock:^(id<TFAspectInfo> aspectInfo, id application, id url, id options) {
        BOOL result = [[TFRouterManager sharedManager].router handleURL:url withCompletion:nil];
        
        return result;
    }
     error:NULL];
    
    [NSClassFromString(@"AppDelegate")
     tf_aspect_hookSelector:@selector(application:continueUserActivity:restorationHandler:)
     withOptions:TFAspectPositionBefore
     usingBlock:^(id<TFAspectInfo> aspectInfo, id application, id userActivity, id restorationHandler) {
        BOOL result = [[TFRouterManager sharedManager].router handleUserActivity:userActivity withCompletion:nil];
        
        return result;
    }
     error:NULL];
}

TFSingletonM(Manager)

- (instancetype)init {
    if (self = [super init]) {
        [self schemeInfo];
    }
    
    return self;
}

/// 注册路由
- (void)routeRegistion {
    NSDictionary *configDict = [self _routerConfig];
    
    if (!configDict) {
        NSLog(@"缺少路由表配置文件[RouterConfig.plist]或未配置路由");
        
        return;
    }
    
    static NSString *routeKey = @"ROUTE";
    
    [configDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary *dict, BOOL * _Nonnull stop) {
        NSString *route = [dict objectForKey:routeKey];
        NSString *handler = key;
        if([route isEmpty] || [handler isEmpty]) {
            return;
        }
        
        Class handlerClass = NSClassFromString(handler);
        if (handlerClass && [handlerClass isSubclassOfClass:[DPLRouteHandler class]]) {
            self.router[route] = [handlerClass class];
        }
    }];
}

- (void)schemeInfo {
    NSDictionary *dict = [TF_MAIN_BUNDLE infoDictionary];
    NSArray *urlTypes = dict[@"CFBundleURLTypes"];
    
    for (NSDictionary *scheme in urlTypes) {
        NSString *schemeKey = scheme[@"CFBundleTypeRole"];
        if ([schemeKey isEqualToString:@"Router"]) {
            _host = scheme[@"CFBundleURLName"];
            _scheme = scheme[@"CFBundleURLSchemes"][0];
     
            break;
        }
    }
}

- (NSDictionary *)_routerConfig {
    NSString *path = [TF_MAIN_BUNDLE pathForResource:@"RouterConfig" ofType:@"plist"];
    
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

#pragma mark - getter && setter

- (DPLDeepLinkRouter *)router {
    if (!_router) {
        _router = [DPLDeepLinkRouter new];
    }
    
    return _router;
}

@end
