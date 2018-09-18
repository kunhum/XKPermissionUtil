//
//  XKUtil.h
//  PinShangHome
//
//  Created by Nicholas on 2018/8/24.
//  Copyright © 2018年 com.xiaopao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface XKPermissionUtil : NSObject

///检测相机权限
+ (void)xk_checkCameraStatus:(void(^)(BOOL result,AVAuthorizationStatus authStatus))completed;
///申请授权相机
+ (void)xk_cameraAuthAction:(void(^)(BOOL result))completed;

///检测麦克风权限
+ (void)xk_checkMicStatus:(void(^)(BOOL result,AVAuthorizationStatus authStatus))completed;
///申请授权麦克风
+ (void)xk_MicAuthAction:(void(^)(BOOL result))completed;

///检测照片权限
+ (void)xk_checkPhotoStatus:(void(^)(BOOL result,PHAuthorizationStatus authStatus))completed;
///申请授权照片
+ (void)xk_photoAuthAction:(void(^)(BOOL result))completed;


@end
