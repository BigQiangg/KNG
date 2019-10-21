//
//  LYLoginStatusManager.h
//  laoyuegou
//
//  Created by Dombo on 2018/1/29.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LYLoginPlatfrom_Default,
    LYLoginPlatfrom_WeiXin,
    LYLoginPlatfrom_Weibo,
    LYLoginPlatfrom_QQ,
} LYLoginPlatfromType;

@interface LYLoginStatusManager : NSObject

+ (void)registeredLoginStatePlatfromKey:(LYLoginPlatfromType)platfromType; //!< 注册登录标记

+ (void)resetLoginStatePlatfromKey:(LYLoginPlatfromType)platfromType; //!< 注销重置登录标记

+ (BOOL)loginSuccessfulPlatfromKey:(LYLoginPlatfromType)platfromType; //!< 判断是否登录成功（无标记为成功、有标记则为失败）
+ (void)checkLoginSuccessful;

@end
