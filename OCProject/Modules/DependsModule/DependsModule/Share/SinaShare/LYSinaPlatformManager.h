//
//  LYSinaPlatformManager.h
//  laoyuegou
//
//  Created by Dombo on 2017/12/28.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LYShareContentTypeDefine.h"

@class LYSinaPlatformManager;
@class SinaUserInfoModel;
typedef enum : NSUInteger {
    UserActionStatus_Success,
    UserActionStatus_Failure
} UserActionStatusType;
@protocol LYSinaPlayformDelegate <NSObject>

@optional
- (void)lySinaPlatformManager:(LYSinaPlatformManager *)manager userInfoModel:(SinaUserInfoModel *)model;
- (void)lySinaPlatformManager:(LYSinaPlatformManager *)manager userShareStatus:(UserActionStatusType)status;
- (void)lySinaPlatformManager:(LYSinaPlatformManager *)manager authorizeLoginStatus:(UserActionStatusType)status;
@end

@interface LYSinaPlatformManager : NSObject

+ (instancetype)sharedInstance;

+ (BOOL)lySinaPlatformManagerApplication:(UIApplication *)application
                         handleOpenURL:(NSURL *)url;

+ (BOOL)lySinaPlatformManagerApplication:(UIApplication *)application
                               openURL:(NSURL *)url
                     sourceApplication:(NSString *)sourceApplication
                            annotation:(id)annotation;

+ (void)lySetupSinaWeiboShareParamsByText:(NSString *)text
                                    title:(NSString *)title
                                    image:(id)image
                                      url:(NSURL *)url
                                 latitude:(double)latitude
                                longitude:(double)longitude
                                 objectID:(NSString *)objectID
                                     type:(LYShareContentType)type;

+ (BOOL)isWeiboAppInstalled;

+ (BOOL)openWeiboApp;

+ (void)registerAppWithSinaWeiBo;

+ (void)authorizeLoginWithDelegate:(id)delegate;

+ (NSString *)sinaWeiBoKey;

- (NSString *)weiboToken;

- (void)sinaWeiBoToken:(NSString *)token;

- (void)resetSinaWeiBoKey;

@property (nonatomic, weak)id <LYSinaPlayformDelegate>delegate;

@end

@interface SinaUserInfoModel : NSObject

@property (nonatomic, copy) NSString *name; //!< 名字
@property (nonatomic, copy) NSString *avatar_large;//!< 头像【小】
@property (nonatomic, copy) NSString *gender; //!< [请求传这个] 男：1、女：2 未知：3
@property (nonatomic, copy) NSString *genderStr; //!< m：男、f：女、 未知 [不用这个]

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *accessToken;
@end

