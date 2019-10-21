//
//  NetworkBaseConfigure.m
//  laoyuegou
//
//  Created by SmallJun on 2019/7/11.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import "NetworkBaseConfigure.h"

@interface NetworkBaseConfigure ()

@property (nonatomic,copy) NSString *baseAppkey;
@property (nonatomic,copy) NSString *baseAppSecret;
@property (nonatomic,copy) NSString *baseApiVersion;
@property (nonatomic,assign) int buildEnvi;
@property (nonatomic,weak) id <NetworkBaseDatasource> baseDdatasource;

@end

@implementation NetworkBaseConfigure

static NetworkBaseConfigure *sharedInstance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkBaseConfigure alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _buildEnvi = 3;
        _baseAppkey = @"1001";
        _baseAppSecret = @"lyg#1001#app";
        _baseApiVersion = @"3.1.2";
    }
    
    return self;
}

+ (void)setAppKey:(NSString *)appkey appSecret:(NSString *)appSecret apiVersion:(NSString *)apiVersion {
    [NetworkBaseConfigure sharedInstance].baseAppkey = appkey;
    [NetworkBaseConfigure sharedInstance].baseAppSecret = appSecret;
    [NetworkBaseConfigure sharedInstance].baseApiVersion = apiVersion;
}

+ (NSString *)appkey {
    return [NetworkBaseConfigure sharedInstance].baseAppkey;
}

+ (NSString *)appSecret {
    return [NetworkBaseConfigure sharedInstance].baseAppSecret;
}

+ (NSString *)apiVersion {
    return [NetworkBaseConfigure sharedInstance].baseApiVersion;
}


+ (void)setAppBuildEnvironment:(int)envi {
    [NetworkBaseConfigure sharedInstance].buildEnvi = envi;
}

+ (int)buildEnvironment {
    return [NetworkBaseConfigure sharedInstance].buildEnvi;
}

#pragma mark -- 当前用户基本信息
+ (NSString *)getCurrentLoginUserId {
    id delegate = [NetworkBaseConfigure sharedInstance].baseDdatasource;
    if ([delegate respondsToSelector:@selector(currentLoginUserId)]) {
        return [delegate currentLoginUserId];
    }
    
    return @"";
}

+ (NSString *)getCurrentLoginUserToken {
    id delegate = [NetworkBaseConfigure sharedInstance].baseDdatasource;
    if ([delegate respondsToSelector:@selector(currentLoginUserToken)]) {
        return [delegate currentLoginUserToken];
    }
    
    return @"";
}

+ (NSString *)getCurrentVisitorToken {
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"un_login_key"];
    return token?token:@"";
//    id delegate = [NetworkBaseConfigure sharedInstance].baseDdatasource;
//    if ([delegate respondsToSelector:@selector(currentVisitorToken)]) {
//        return [delegate currentVisitorToken];
//    }
//
//    return @"";
}

#pragma mark -- other
+ (void)setDatasource:(id<NetworkBaseDatasource>)datasource {
    [NetworkBaseConfigure sharedInstance].baseDdatasource = datasource;
}

+ (NSString *)getSensorAnonymousId {
    id delegate = [NetworkBaseConfigure sharedInstance].baseDdatasource;
    if ([delegate respondsToSelector:@selector(currentSensorAnonymousId)]) {
        return [delegate currentSensorAnonymousId];
    }
    
    return nil;
}

@end
