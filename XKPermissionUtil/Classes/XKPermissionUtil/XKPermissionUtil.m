//
//  XKUtil.m
//  PinShangHome
//
//  Created by Nicholas on 2018/8/24.
//  Copyright © 2018年 com.xiaopao. All rights reserved.
//

#import "XKPermissionUtil.h"

@implementation XKPermissionUtil

#pragma mark - 私有
+ (void)checkDeviceStatusWityType:(AVMediaType)type completed:(void(^)(BOOL result,AVAuthorizationStatus authStatus))completed {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:type];
    
    switch (authStatus) {
            //还没决定
        case AVAuthorizationStatusNotDetermined:
        {
            //视频
            if (type == AVMediaTypeVideo) {
                [self xk_cameraAuthAction:^(BOOL result) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completed) {
                            completed(result, authStatus);
                        }
                    });
                }];
            }
            //麦克风
            else if (type == AVMediaTypeAudio) {
                
                [self xk_MicAuthAction:^(BOOL result) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completed) {
                            completed(result, authStatus);
                        }
                    });
                }];
            }
        }
            break;
            //未授权，家长限制
        case AVAuthorizationStatusRestricted:
            //未授权
        case AVAuthorizationStatusDenied:
        {
            if (completed) {
                completed(NO, authStatus);
            }
        }
            break;
        case AVAuthorizationStatusAuthorized:
        {
            if (completed) {
                completed(YES, authStatus);
            }
        }
            break;
            
        default:
            if (completed) {
                completed(NO, authStatus);
            }
            break;
    }
}

#pragma mark - 接口
#pragma mark 检查相机权限
+ (void)xk_checkCameraStatus:(void (^)(BOOL, AVAuthorizationStatus))completed {
    
    [self checkDeviceStatusWityType:AVMediaTypeVideo completed:completed];
    
}
#pragma mark 申请授权相机
+ (void)xk_cameraAuthAction:(void(^)(BOOL result))completed {
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:completed];
}

#pragma mark 检测麦克风权限
+ (void)xk_checkMicStatus:(void(^)(BOOL result,AVAuthorizationStatus authStatus))completed {
    
    [self checkDeviceStatusWityType:AVMediaTypeAudio completed:completed];
}
#pragma mark 申请授权麦克风
+ (void)xk_MicAuthAction:(void(^)(BOOL result))completed {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:completed];
}

#pragma mark 检测照片权限
+ (void)xk_checkPhotoStatus:(void(^)(BOOL result,PHAuthorizationStatus authStatus))completed {
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    switch (authStatus) {
            //已授权
        case PHAuthorizationStatusAuthorized:
            if (completed) {
                completed(YES, authStatus);
            }
            break;
            //未授权，家长限制
        case PHAuthorizationStatusRestricted:
            //未授权
        case PHAuthorizationStatusDenied:
            if (completed) {
                completed(NO, authStatus);
            }
            break;
            //还没决定
        case PHAuthorizationStatusNotDetermined:
        {
            [self xk_photoAuthAction:^(BOOL result) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completed) {
                        completed(result, authStatus);
                    }
                });
            }];
            
        }
            break;
        
        default:
            if (completed) {
                completed(NO, authStatus);
            }
            break;
    }
}
#pragma mark 申请相册授权
+ (void)xk_photoAuthAction:(void (^)(BOOL))completed {
    
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        completed(status==PHAuthorizationStatusAuthorized);
    }];
}

@end
