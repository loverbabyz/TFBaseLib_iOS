//
//  TFPermissionManager.m
//  TFBaseLib
//
//  Created by Daniel on 16/3/2.
//  Copyright © 2016年 daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFPermissionManager.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>
#import <Contacts/Contacts.h>
#import "TFBaseMacro+System.h"

@implementation TFPermissionManager

+ (void)getCameraPermission:(nonnull void(^)(BOOL allowed))completion
{
    
    //ios7之前系统没有设置权限
    if([TF_SYSTEM_VERSION floatValue] < 7.0){
        completion(YES);
        return;
    }
    
    AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    /*
     typedef NS_ENUM(NSInteger, AVAuthorizationStatus) {
     AVAuthorizationStatusNotDetermined = 0,
     AVAuthorizationStatusRestricted,
     AVAuthorizationStatusDenied,
     AVAuthorizationStatusAuthorized
     } NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED;
     */
    switch (authorizationStatus)
    {
        case AVAuthorizationStatusAuthorized:
            if (completion)
            {
                completion(YES);
            }
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            if (completion)
            {
                completion(NO);
            }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         if (completion)
                                         {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 completion(granted);
                                             });
                                         }
                                     }];
        }
            break;
        default:
            if (completion)
            {
                completion(NO);
            }
            break;
    }
}

+ (void)getPhotoPermission:(nonnull void(^)(BOOL allowed))completion
{
    if ([TF_SYSTEM_VERSION floatValue] < 8.0)
    {
        PHAuthorizationStatus authorizationStatus = [PHPhotoLibrary authorizationStatus];
        
        switch (authorizationStatus)
        {
            case PHAuthorizationStatusAuthorized:
                completion(YES);
                break;
            case PHAuthorizationStatusRestricted:
            case PHAuthorizationStatusDenied:
                completion(NO);
                break;
            case PHAuthorizationStatusNotDetermined:
            {
                [[PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeUnknown options:nil] enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (*stop)
                    {
                        completion(YES);
                    }
                    else
                    {
                        *stop = YES;
                    }
                }];
            }
                break;
                
            default:
                break;
        }
        
    }
    else
    {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status ==  PHAuthorizationStatusAuthorized)
            {
                completion(YES);
            }
            else
            {
                completion(NO);
            }
        }];
    }
}

//麦克风权限
+ (void)getMicroPhonePermission:(nonnull void(^)(BOOL allowed))completion
{
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        [avSession requestRecordPermission:^(BOOL available) {
            
            if (available) {
                //completionHandler
                completion(YES);
            }
            else
            {
                completion(NO);
            }
        }];
        
    }
}

//推送权限
+ (void)getNotificationPermission:(nonnull void(^)(BOOL allowed))completion
{
}

//通讯录权限
+ (void)getABAddressPermission:(nonnull void(^)(BOOL allowed))completion
{
    //这里有一个枚举类:CNEntityType,不过没关系，只有一个值:CNEntityTypeContacts
        switch ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts])
        {
                //存在权限
            case CNAuthorizationStatusAuthorized:
                //获取通讯录
                completion(YES);
                break;
                
                //权限未知
            case CNAuthorizationStatusNotDetermined:
                //请求权限
                completion(NO);
//                [self __requestAuthorizationStatus];
                break;
                
                //如果没有权限
            case CNAuthorizationStatusRestricted:
            case CNAuthorizationStatusDenied://需要提示
                completion(NO);
                break;
        }
}

//日历权限
+ (void)getCalenderPermission:(nonnull void(^)(BOOL allowed))completion
{
}

//健康权限
+ (void)getHealthPermission:(nonnull void(^)(BOOL allowed))completion
{
}

//HomeKit权限
+ (void)getHomeKitPermission:(nonnull void(^)(BOOL allowed))completion
{
}

//蓝牙权限
+ (void)getBlueToothPermission:(nonnull void(^)(BOOL allowed))completion
{
}

//GPS权限
+ (void)getGPSPermission:(nonnull void(^)(BOOL allowed))completion
{
}


+ (void)openPermissionSetting
{
    if (UIApplicationOpenSettingsURLString != NULL)
    {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [TF_APP_APPLICATION openURL:appSettings options:@{} completionHandler:nil];
    }
}

@end
