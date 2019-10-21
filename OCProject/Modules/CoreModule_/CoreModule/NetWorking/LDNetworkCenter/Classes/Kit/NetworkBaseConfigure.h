//
//  NetworkBaseConfigure.h
//  laoyuegou
//
//  Created by SmallJun on 2019/7/11.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppChanel @"999"
//手机平台参数，1代表ios
#define AppPlatform @"1"

@protocol NetworkBaseDatasource <NSObject>

@required
- (NSString *)currentLoginUserId;
- (NSString *)currentLoginUserToken;

@optional
- (NSString *)currentVisitorToken;
- (NSString *)currentSensorAnonymousId;

@end

//用于外部来控制基类相关的颜色、字号等等主题
@interface NetworkBaseConfigure : NSObject

#pragma mark -- APP基本信息

+ (void)setAppKey:(NSString *)appkey appSecret:(NSString *)appSecret apiVersion:(NSString *)apiVersion;

+ (NSString *)appkey;

+ (NSString *)appSecret;

+ (NSString *)apiVersion;

+ (void)setAppBuildEnvironment:(int)envi;

+ (int)buildEnvironment;

#pragma mark -- 当前用户基本信息
+ (NSString *)getCurrentLoginUserId;

+ (NSString *)getCurrentLoginUserToken;

+ (NSString *)getCurrentVisitorToken;

#pragma mark -- other
+ (void)setDatasource:(id<NetworkBaseDatasource>)datasource;

+ (NSString *)getSensorAnonymousId;

@end

