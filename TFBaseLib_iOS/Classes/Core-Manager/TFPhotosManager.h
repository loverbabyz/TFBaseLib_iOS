//
//  TFPhotosManager.h
//  TFBaseLib
//
//  Created by sunxiaofei on 19/07/2017.
//  Copyright © 2017 daniel.xiaofei@gmail.com All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFBaseMacro+Singleton.h"

#define kPhotosManager ([TFPhotosManager sharedManager])

typedef enum : NSUInteger {
    // 照片
    MediaAssetModelPhoto,
    // 视频
    MediaAssetModelVideo
} MediaAssetType;

@class AssetModel;

@interface TFPhotosManager : NSObject

@property (nonatomic, assign) MediaAssetType type;
@property (nonatomic, strong) NSString *photoPlistName;
@property (nonatomic, strong) NSString *photoFolderName;

@property (nonatomic, strong) NSString *videoPlistName;
@property (nonatomic, strong) NSString *videoFolderName;

TFSingletonH(Manager)

/**
 授权状态检测回调
 */
- (void)authorizationStatusBlock:(void (^)(NSInteger resultNumber, NSString *errorMsg))block;
/**
 获取已保存到相册的照片/视频
 
 @param block 回调方法，返回已保存到相册的照片/视频
 */
- (void)requestMediaWithType:(MediaAssetType)type block:(void(^)(NSArray *array))block;

/**
 *  保存图片/视频到系统相册
 */
- (void)save:(AssetModel *)model success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;

/**
 *  删除系统相册中的文件
 */
- (void)remove:(AssetModel *)model success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock;

- (void)handel:(NSArray *)mediaAsset type:(MediaAssetType)type completed:(void(^)(NSArray *array))block;

@end

@interface TFAssetModel : NSObject

/**
 类型
 */
@property (nonatomic, assign) MediaAssetType type;
@property (nonatomic, assign) BOOL isDownload;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *localIdentifier;
@property (nonatomic, strong) NSString *pathUrl;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image;

@end
