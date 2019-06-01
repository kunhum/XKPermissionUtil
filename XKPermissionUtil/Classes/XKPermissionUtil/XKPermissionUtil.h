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
#import <Contacts/Contacts.h>

typedef NS_ENUM(NSInteger, XKSourceType) {
    
    XKSourceTypeCamera = 0,
    XKSourceTypePhoto,
    XKSourceTypeAddressbook
};

@interface XKPermissionUtil : NSObject

///打开相应设置页
+ (void)xk_goAppSystemSettingType:(XKSourceType)type showAlertView:(BOOL)showAlertView;

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

///检测通讯录权限
+ (void)xk_checkAddressbookStatus:(void(^)(BOOL result,CNAuthorizationStatus authStatus))completed;
///申请授权通讯录
+ (void)xk_addressbookAuthAction:(void(^)(BOOL result))completed;

@end
