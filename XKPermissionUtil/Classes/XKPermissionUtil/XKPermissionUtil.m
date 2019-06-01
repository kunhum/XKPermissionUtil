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

+ (void)xk_goAppSystemSettingType:(XKSourceType)type showAlertView:(BOOL)showAlertView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (showAlertView) {
            
            NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = appInfo[@"CFBundleDisplayName"];
            NSString *title = [NSString stringWithFormat:@"%@需要访问您的%@",appName, type == XKSourceTypeCamera ? @"相机" : @"相册"];
            UIAlertController *alcrtC = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alcrtC addAction:cancelAction];
            [alcrtC addAction:goAction];
            
            [[self xk_currentViewController] presentViewController:alcrtC animated:YES completion:nil];
        }
        else {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
        
    });
}
#pragma mark 检测通讯录权限
+ (void)xk_checkAddressbookStatus:(void(^)(BOOL result,CNAuthorizationStatus authStatus))completed {
    
    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (authStatus) {
        case CNAuthorizationStatusAuthorized:
            !completed ?: completed(YES, authStatus);
            break;
        case CNAuthorizationStatusDenied:
//            @"此功能需要您授权本App访问通讯录\n设置方法:打开手机设置->隐私->通讯录"
            !completed ?: completed(YES, authStatus);
            break;
        case CNAuthorizationStatusNotDetermined:
        {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    !completed ?: completed(granted, authStatus);
                });
            }];
        }
            break;
        case CNAuthorizationStatusRestricted:
            !completed ?: completed(NO, authStatus);
            break;
    }
    
}
#pragma mark 申请授权通讯录
+ (void)xk_addressbookAuthAction:(void(^)(BOOL result))completed {
    
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !completed ?: completed(NO);
        });
    }];
}

+ (UIViewController *)xk_currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

#pragma mark 当前控制器
+ (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController *svc = (UISplitViewController *)vc;
        if (svc.viewControllers.count > 0)
        return [self findBestViewController:svc.viewControllers.lastObject];
        else
        return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController *)vc;
        if (svc.viewControllers.count > 0)
        return [self findBestViewController:svc.topViewController];
        else
        return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController *svc = (UITabBarController *)vc;
        if (svc.viewControllers.count > 0)
        return [self findBestViewController:svc.selectedViewController];
        else
        return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

@end

/*
 NSArray *prefsArray = @[
 @"prefs::root=General&path=About",
 @"prefs::root=General&path=ACCESSIBILITY",
 @"prefs::root=AIRPLANE_MODE",
 @"prefs::root=General&path=AUTOLOCK",
 @"prefs::root=General&path=USAGE/CELLULAR_USAGE",
 @"prefs::root=Brightness",    //打开Brightness(亮度)设置界面
 @"prefs::root=Bluetooth",    //打开蓝牙设置
 @"prefs::root=General&path=DATE_AND_TIME",    //日期与时间设置
 @"prefs::root=FACETIME",    //打开FaceTime设置
 @"prefs::root=General",    //打开通用设置
 @"prefs::root=General&path=Keyboard",    //打开键盘设置
 @"prefs::root=CASTLE",    //打开iClound设置
 @"prefs::root=CASTLE&path=STORAGE_AND_BACKUP",    //打开iCloud下的储存空间
 @"prefs::root=General&path=INTERNATIONAL",    //打开通用下的语言和地区设置
 @"prefs::root=LOCATION_SERVICES",    //打开隐私下的定位服务
 @"prefs::root=ACCOUNT_SETTINGS",
 @"prefs::root=MUSIC",    //打开设置下的音乐
 @"prefs::root=MUSIC&path=EQ",    //打开音乐下的均衡器
 @"prefs::root=MUSIC&path=VolumeLimit",
 @"prefs::root=General&path=Network",
 @"prefs::root=NIKE_PLUS_IPOD",
 @"prefs::root=NOTES",
 @"prefs::root=NOTIFICATIONS_ID",
 @"prefs::root=Phone",
 @"prefs::root=Photos",
 @"prefs::root=General&path=ManagedConfigurationList",
 @"prefs::root=General&path=Reset",
 @"prefs::root=Sounds&path=Ringtone",
 @"prefs::root=Safari",
 @"prefs::root=General&path=Assistan",
 @"prefs::root=Sounds",
 @"prefs::root=General&path=SOFTWARE_UPDATE_LINK",
 @"prefs::root=STORE",
 @"prefs::root=TWITTER",
 @"prefs::root=FACEBOOK",
 @"prefs::root=General&path=USAGE",
 @"prefs::root=VIDEO",
 @"prefs::root=General&path=Network/VPN",
 @"prefs::root=Wallpaper",
 @"prefs::root=WIFI",
 @"prefs::root=INTERNET_TETHERING"
 ];
 */
