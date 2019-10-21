//
//  BaseDAO.h
//  Annotation_iPad
//
//  Created by Melo Yao on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYCache;
typedef NS_ENUM(NSInteger, LYCacheType)
{
    LYCacheTypeUserClass = 1,                 //用户分组
    LYCacheTypeVersionClass = 2,              //版本分组
    LYCacheTypeVersionUserClass = 3,         //版本用户分组
    LYCacheTypeAllConfigurationClass = 4,     //全局配置
};

@interface BaseDAO : NSObject

-(void)store;

- (void)storeInBackground;

-(void)clean;

-(void)load;

-(void) freeMemory;

- (YYCache *)createCacheWithUserCacheType:(LYCacheType)type cacheName:(NSString *)name;

+ (YYCache *)createCacheWithUserCacheType:(LYCacheType)type cacheName:(NSString *)name;

- (void)loginInit;

@property (nonatomic, copy) NSString *cacheKey;

@end
