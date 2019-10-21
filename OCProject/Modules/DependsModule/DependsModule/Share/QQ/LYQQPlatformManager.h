//
//  LYQQPlatformManager.h
//  laoyuegou
//
//  Created by zwq on 2018/10/9.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYThirdUserModel.h"

typedef NS_ENUM(NSInteger,LYThirdLoginCode) {
    LYThirdLoginCodeSuccess,
    LYThirdLoginCodeCancel,
    LYThirdLoginCodeFail,
    LYThirdLoginCodeNoNetWork,
};

typedef void(^LYThirdLoginCallBack)(LYThirdUserModel * user,LYThirdLoginCode code,NSString * errMsg);

@interface LYQQPlatformManager : NSObject

@property(nonatomic,copy) LYThirdLoginCallBack loginCallBack;
+ (BOOL)isInstalled;

+ (BOOL)isQQCallBack:(NSString *) url;

+ (void)registerAppWithQQ; //!< QQapp 注册

+ (void)lySetupQQParamsByText:(NSString *)text
                        title:(NSString *)title
                          url:(NSURL *)url
                        image:(id)image
                   thumbImage:(id)thumbImage
                         type:(LYGContentType)type
           forPlatformSubType:(LYGPlatformType)platformSubType;


+ (void)authorizeLoginWithCallBack:(LYThirdLoginCallBack) loginCallBack;

+ (BOOL)lyQQPlatformManagerApplication:(UIApplication *)application
                                 openURL:(NSURL *)url
                       sourceApplication:(NSString *)sourceApplication
                              annotation:(id)annotation;

+ (BOOL)lyQQPlatformManagerApplication:(UIApplication *)application
                           handleOpenURL:(NSURL *)url;



@end

