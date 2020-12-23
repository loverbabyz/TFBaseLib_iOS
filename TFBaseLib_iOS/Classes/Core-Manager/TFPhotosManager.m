//
//  TFPhotosManager.m
//  TFBaseLib
//
//  Created by sunxiaofei on 19/07/2017.
//  Copyright © 2017 daniel.xiaofei@gmail.com All rights reserved.
//

#import "TFPhotosManager.h"
#import "TFBaseMacro+Other.h"

#import <Photos/Photos.h>

@interface TFPhotosManager()

@property (nonatomic, strong) NSString *plistName;
@property (nonatomic, strong) NSString *folderName;
@property (nonatomic, copy) IntegerMsgBlock authorizationBlock;

@end

@implementation TFPhotosManager

- (void)setType:(MediaAssetType)type {
    _type = type;
    switch (_type) {
        case MediaAssetModelPhoto:
            self.plistName = self.photoPlistName;
            self.folderName = self.photoFolderName;
            
            break;
        case MediaAssetModelVideo:
            self.plistName = self.videoPlistName;
            self.folderName = self.videoFolderName;
            
            break;
        default:
            break;
    }
}

+ (instancetype)sharedManager {
    static TFPhotosManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TFPhotosManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = MediaAssetModelPhoto;
    }
    return self;
}

- (void)authorizationStatusBlock:(IntegerMsgBlock)block {
    self.authorizationBlock = block;
}

- (void)requestMediaWithType:(MediaAssetType)type block:(void(^)(NSArray *array))block {
    self.type = type;
    
    [self getAssetFromAlbum:^(NSArray *assetArray) {
        if (assetArray.count == 0) {
            if (block) {
                block(nil);
            }
            
            return;
        }
        
        NSDictionary *dict = [self readFromPlist];
        NSArray *allkeys = [dict allKeys];
        NSMutableArray *mediaArray = [NSMutableArray arrayWithCapacity:0];
        [assetArray enumerateObjectsUsingBlock:^(PHAsset *phAsset, NSUInteger idx, BOOL * _Nonnull stop) {
            // 视频
            if (phAsset.mediaType == PHAssetMediaTypeVideo) {
                PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
                options.version = PHImageRequestOptionsVersionCurrent;
                options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                
                [[PHImageManager defaultManager] requestAVAssetForVideo:phAsset
                                                                options:options
                                                          resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
                                                              TFAssetModel *video = [[TFAssetModel alloc] init];
                                                              video.isDownload = YES;
                                                              video.type = MediaAssetModelVideo;
                                                              video.localIdentifier = phAsset.localIdentifier;
                                                              video.url = ((AVURLAsset *)asset).URL;
                                                              //NSData *data = [NSData dataWithContentsOfURL:url];
                                                              //NSLog(@"%@",data);
                                                              
                                                              for (int i = 0; i < allkeys.count; i++) {
                                                                  if ([phAsset.localIdentifier isEqualToString:[dict objectForKey:allkeys[i]]]) {
                                                                      video.name = allkeys[i];
                                                                      
                                                                      break;
                                                                  }
                                                              }
                                                              
                                                              [mediaArray addObject:video];
                                                              
                                                              if (mediaArray.count == assetArray.count) {
                                                                  //*stop = YES;
                                                                  if (block) {
                                                                      block(mediaArray);
                                                                  }
                                                              }
                                                          }];
            }
            
            // 照片
            if (phAsset.mediaType == PHAssetMediaTypeImage) {
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
                option.version = PHImageRequestOptionsVersionOriginal;
                option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                option.networkAccessAllowed = NO;
                option.synchronous = YES;
                option.resizeMode = PHImageRequestOptionsResizeModeExact;
                
                [[PHCachingImageManager defaultManager] requestImageForAsset:phAsset
                                                                  targetSize:PHImageManagerMaximumSize
                                                                 contentMode:PHImageContentModeAspectFit
                                                                     options:option
                                                               resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                                   TFAssetModel *photo = [[TFAssetModel alloc] init];
                                                                   photo.localIdentifier = phAsset.localIdentifier;
                                                                   photo.image = [UIImage imageWithData:UIImageJPEGRepresentation(result, (CGFloat)1.0)];
                                                                   photo.isDownload = YES;
                                                                   
                                                                   for (int i = 0; i < allkeys.count; i++) {
                                                                       if ([phAsset.localIdentifier isEqualToString:[dict objectForKey:allkeys[i]]]) {
                                                                           photo.name = allkeys[i];
                                                                           
                                                                           break;
                                                                       }
                                                                   }
                                                                   
                                                                   [mediaArray addObject:photo];
                                                                   
                                                                   if (mediaArray.count == assetArray.count) {
                                                                       BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] &&
                                                                       ![info objectForKey:PHImageErrorKey] &&
                                                                       ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
                                                                       
                                                                       if (downloadFinined) {
                                                                           *stop = YES;
                                                                           if (block) {
                                                                               block(mediaArray);
                                                                           }
                                                                       }
                                                                   }
                                                               }];
            }
        }];
    }];
}

- (void)save:(TFAssetModel *)model success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock {
    if (![self checkPhotosLimits]) {
        if (failureBlock) {
            failureBlock();
        }
        
        return;
    }
    
    //标识保存到系统相册中的标识
    __block NSString *localIdentifier;
    
    //首先获取相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL *stop) {
        //Camera Roll是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:self->_folderName]) {
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                //请求创建一个Asset
                PHAssetChangeRequest *assetRequest = (self->_type == MediaAssetModelPhoto)
                ? [PHAssetChangeRequest creationRequestForAssetFromImage:model.image]
                : [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:model.pathUrl]];
                
                //请求编辑相册
                PHAssetCollectionChangeRequest *collectonRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                
                //为Asset创建一个占位符，放到相册编辑请求中
                PHObjectPlaceholder *placeHolder = [assetRequest placeholderForCreatedAsset];
                
                //相册中添加视频
                [collectonRequest addAssets:@[placeHolder]];
                
                localIdentifier = placeHolder.localIdentifier;
            } completionHandler:^(BOOL success, NSError *error) {
                if (success){
                    //NSLog(@"保存媒体成功!");
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[self readFromPlist]];
                    [dict setObject:localIdentifier forKey:model.name];
                    
                    [self writeDicToPlist:dict];
                    
                    if (successBlock) {
                        successBlock();
                    }
                } else {
                    //NSLog(@"保存媒体失败:%@", error);
                    if (failureBlock) {
                        failureBlock();
                    }
                }
            }];
        }
    }];
}

- (void)remove:(TFAssetModel *)model success:(void(^)(void))successBlock failure:(void(^)(void))failureBlock {
    if (![self isExistFolder:_folderName]) {
        if (failureBlock) {
            failureBlock();
        }
        
        return;
    }
    
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [collectonResuts enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL *stop) {
        if ([assetCollection.localizedTitle isEqualToString:self->_folderName]) {
            *stop = YES;
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            [assetResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
                if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                    *stop = YES;
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        [PHAssetChangeRequest deleteAssets:@[asset]];
                    } completionHandler:^(BOOL success, NSError *error) {
                        if (success) {
                            //NSLog(@"删除成功!");
                            
                            NSMutableDictionary *updateDic = [NSMutableDictionary dictionaryWithDictionary:[self readFromPlist]];
                            [updateDic removeObjectForKey:model.name];
                            [self writeDicToPlist:updateDic];
                            
                            if (successBlock) {
                                successBlock();
                            }
                        } else {
                            //NSLog(@"删除失败:%@", error);
                            if (failureBlock) {
                                failureBlock();
                            }
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)handel:(NSArray *)media type:(MediaAssetType)type completed:(void (^)(NSArray *))block {
    if (![self checkPhotosLimits]) {
        if (block) {
            block(media);
        }
        
        return;
    }
    
    [self requestMediaWithType:type block:^(NSArray *array) {
        if (array.count == 0) {
            if (block) {
                block(media);
            }
            
            return;
        }
        
        for (TFAssetModel *localPhoto in array) {
            for (TFAssetModel *remoteModel in media) {
                if ([localPhoto.name isEqualToString:remoteModel.name]) {
                    remoteModel.url = localPhoto.url;
                    remoteModel.image = localPhoto.image;
                    remoteModel.isDownload = YES;
                    
                    break;
                }
            }
        }
        
        if (block) {
            block(media);
        }
    }];
}

#pragma mark - private method

- (void)getAssetFromAlbum:(void(^)(NSArray *photos))block; {
    if (![self isExistFolder:self.folderName]) {
        if (block) {
            block(nil);
        }
        
        return;
    }
    
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    NSMutableArray *assetArray = [NSMutableArray arrayWithCapacity:0];
    [collectonResuts enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL * _Nonnull stop1) {
        if ([assetCollection.localizedTitle isEqualToString:self->_folderName]) {
            *stop1 = YES;
            PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
            if (assetResult.count ==0 || assetResult == nil) {
                if (block) {
                    block(nil);
                }
                
                return ;
            }
            
            [assetResult enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL *stop) {
                [assetArray addObject:asset];
                
                if (assetArray.count == assetResult.count) {
                    *stop = YES;
                    if (block) {
                        block(assetArray);
                    }
                    
                    return ;
                }
            }];
        }
    }];
}

- (BOOL)isExistFolder:(NSString *)folderName {
    //首先获取用户手动创建相册的集合
    PHFetchResult *collectonResuts = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    __block BOOL isExisted = NO;
    //对获取到集合进行遍历
    [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        PHAssetCollection *assetCollection = obj;
        
        //folderName是我们写入照片的相册
        if ([assetCollection.localizedTitle isEqualToString:folderName]) {
            isExisted = YES;
            *stop = YES;
        }
    }];
    
    return isExisted;
}

- (void)createFolder:(NSString *)folderName {
    if ([self isExistFolder:folderName]) {
        return;
    }
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //添加HUD文件夹
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:folderName];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            //NSLog(@"创建相册文件夹成功!");
        } else {
            //NSLog(@"创建相册文件夹失败:%@", error);
        }
    }];
}

- (void)setFolderName:(NSString *)folderName {
    if ([_folderName isEqualToString:folderName]) {
        return;
    }
    
    _folderName = folderName;
    
    [self createFolder:folderName];
}

- (void)setPlistName:(NSString *)plistName {
    if ([_plistName isEqualToString:plistName]) {
        return;
    }
    
    _plistName = plistName;
    
    //创建plist文件，记录path和localIdentifier的对应关系
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", plistName]];
    //NSLog(@"plist路径:%@", filePath);
    NSFileManager* fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:filePath]) {
        BOOL success = [fm createFileAtPath:filePath contents:nil attributes:nil];
        if (!success) {
            //NSLog(@"创建plist文件失败!");
        } else {
            //NSLog(@"创建plist文件成功!");
        }
    } else {
        //NSLog(@"沙盒中已有该plist文件，无需创建!");
    }
}

- (BOOL)checkPhotosLimits {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    NSString *errorMessage = @"";
    BOOL result = NO;
    if (status == PHAuthorizationStatusDenied) {
        errorMessage = @"用户拒绝当前应用访问相册,需要提醒用户打开访问开关";
    } else if (status == PHAuthorizationStatusRestricted){
        errorMessage = @"家长控制,不允许访问";
    } else if (status == PHAuthorizationStatusNotDetermined){
        errorMessage = @"用户未做出选择";
    } else if (status == PHAuthorizationStatusAuthorized){
        errorMessage = @"用户允许当前应用访问相册";
        result = YES;
    }
    
    if (self.authorizationBlock) {
        self.authorizationBlock(status, errorMessage);
    }
    
    return result;
}

#pragma mark - plist

// 清空plist
- (void)clearPlist {
    [self writeDicToPlist:[NSDictionary new]];
}

// 写入plist文件
- (void)writeDicToPlist:(NSDictionary *)dict {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", _plistName]];
    [dict writeToFile:filePath atomically:YES];
}

// 读取plist文件
- (NSDictionary *)readFromPlist {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", _plistName]];
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

// 根据路径获取文件名
- (NSString *)showFileNameFromPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@", [[path componentsSeparatedByString:@"/"] lastObject]];
}

@end

@implementation TFAssetModel

@end
