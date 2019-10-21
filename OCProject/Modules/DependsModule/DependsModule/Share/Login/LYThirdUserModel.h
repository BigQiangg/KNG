//
//  LYThirdUserModel.h
//  laoyuegou
//
//  Created by zwq on 2018/10/9.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYShareDefine.h"

@class LYThirdCredential;

/**
 *  性别
 */
typedef NS_ENUM(NSUInteger, LYThirdGender){
    /**
     *  男
     */
    LYThirdGenderMale      = 0,
    /**
     *  女
     */
    LYThirdGenderFemale    = 1,
    /**
     *  未知
     */
    LYThirdGenderUnknown   = 2,
};

/**
 *  用户信息
 */
@interface LYThirdUserModel : NSObject

/**
 *  平台类型
 */
@property (nonatomic) LYGPlatformType platformType;

/**
 *  授权凭证， 为nil则表示尚未授权
 */
@property (nonatomic, retain) LYThirdCredential *credential;

/**
 *  用户标识
 */
@property (nonatomic, copy) NSString *uid;

/**
 *  昵称
 */
@property (nonatomic, copy) NSString *nickname;

/**
 *  头像
 */
@property (nonatomic, copy) NSString *icon;

/**
 *  性别
 */
@property (nonatomic) LYThirdGender gender;

/**
 *  用户主页
 */
@property (nonatomic, copy) NSString *url;

/**
 *  用户简介
 */
@property (nonatomic, copy) NSString *aboutMe;

/**
 *  认证用户类型
 */
@property (nonatomic) NSInteger verifyType;

/**
 *  认证描述
 */
@property (nonatomic, copy) NSString *verifyReason;

/**
 *  生日
 */
@property (nonatomic, strong) NSDate *birthday;

/**
 *  粉丝数
 */
@property (nonatomic) NSInteger followerCount;

/**
 *  好友数
 */
@property (nonatomic) NSInteger friendCount;

/**
 *  分享数
 */
@property (nonatomic) NSInteger shareCount;

/**
 *  注册时间
 */
@property (nonatomic) NSTimeInterval regAt;

/**
 *  用户等级
 */
@property (nonatomic) NSInteger level;

/**
 *  教育信息
 */
@property (nonatomic, retain) NSArray *educations;

/**
 *  职业信息
 */
@property (nonatomic, retain) NSArray *works;

/**
 *  原始数据
 */
@property (nonatomic, retain) NSDictionary *rawData;


/**
 *  城市
 */
@property (nonatomic, copy) NSString *city;

@end
