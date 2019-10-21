//
//  BaseDAO.m
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseDAO.h"
#import <YYCache/YYCache.h>

@interface BaseDAO()
{
    BOOL _isLoaded;
}
@end

@implementation BaseDAO

-(void)store
{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}

- (void)storeInBackground{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}

-(void)clean
{
    _isLoaded = NO;
//    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}

-(void)load
{
    if (!_isLoaded) {
        [self dispatchLoad];
        _isLoaded = YES;
    }
}

-(void)dispatchLoad
{
    @throw [NSException exceptionWithName:@"UnimplementedOperation" reason:@"This Operation should be implemented by subclasses" userInfo:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStateChange:) name:LY_LOGIN_CHANGE_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(freeMemory) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) freeMemory
{
    if ([self handleFreeMemory]) {
        _isLoaded = NO;
    }
}

- (BOOL) handleFreeMemory
{
    return NO;
}


- (YYCache *)createCacheWithUserCacheType:(LYCacheType)type cacheName:(NSString *)name
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    rootPath = [NSString stringWithFormat:@"%@/%@",rootPath,@"ApplicationCache"];
    NSString *path = nil;
    switch (type) {
        case LYCacheTypeUserClass:
            path = [NSString stringWithFormat:@"%@/%@",[rootPath stringByAppendingPathComponent:@"UserCache"],[[LYUserConfInfoDao queryUserID] stringByAppendingPathComponent:name]];
            break;
        case LYCacheTypeVersionClass:
            path = [NSString stringWithFormat:@"%@/%@",[rootPath stringByAppendingPathComponent:@"VersionCache"],[[UIDevice appShortVersion] stringByAppendingPathComponent:name]];
            break;
        case LYCacheTypeVersionUserClass:
            path = [NSString stringWithFormat:@"%@/%@",[rootPath stringByAppendingPathComponent:@"VersionUserCache"],[[UIDevice appShortVersion] stringByAppendingPathComponent:[[LYUserConfInfoDao queryUserID] stringByAppendingPathComponent:name]]];
            break;
        case LYCacheTypeAllConfigurationClass:
            path = [rootPath stringByAppendingPathComponent:[@"Configuration" stringByAppendingPathComponent:name]];
            break;
    }

    return [[YYCache alloc] initWithPath:path];
}

+ (YYCache *)createCacheWithUserCacheType:(LYCacheType)type cacheName:(NSString *)name
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) firstObject];
    rootPath = [NSString stringWithFormat:@"%@/%@",rootPath,@"ApplicationCache"];
    NSString *path = nil;
    switch (type) {
        case LYCacheTypeUserClass:
            path = [NSString stringWithFormat:@"%@/%@",[rootPath stringByAppendingPathComponent:@"UserCache"],[[LYUserConfInfoDao queryUserID] stringByAppendingPathComponent:name]];
            break;
        case LYCacheTypeVersionClass:
            path = [NSString stringWithFormat:@"%@/%@",[rootPath stringByAppendingPathComponent:@"VersionCache"],[[UIDevice appShortVersion] stringByAppendingPathComponent:name]];
            break;
        case LYCacheTypeVersionUserClass:
            path = [NSString stringWithFormat:@"%@/%@",[rootPath stringByAppendingPathComponent:@"VersionUserCache"],[[UIDevice appShortVersion] stringByAppendingPathComponent:[[LYUserConfInfoDao queryUserID] stringByAppendingPathComponent:name]]];
            break;
        case LYCacheTypeAllConfigurationClass:
            path = [rootPath stringByAppendingPathComponent:[@"Configuration" stringByAppendingPathComponent:name]];
            break;
    }
    
    return [[YYCache alloc] initWithPath:path];
}

//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = YES;
    if (![notification.object isKindOfClass:[NSDictionary class]]) {
        loginSuccess = [notification.object boolValue];
    }
    if (loginSuccess) {
        [self loginInit];
    }
}

- (void)loginInit
{
    
}

@end
