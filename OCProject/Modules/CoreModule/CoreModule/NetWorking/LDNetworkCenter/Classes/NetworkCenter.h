//
//  NetworkCenter.h
//  NewVersionOfAFNetworking
//
//  Created by XiangqiTu on 16/3/8.
//  Copyright © 2016年 laoyuegou. All rights reserved.
//

#import "ChessHTTPClient.h"
#import "ChessHTTPShare.h"
extern NSString * const kLYGNetworkCenterIssueFailtureDomain;//具体的业务错误ErrorDomain
extern NSString * const kLYGNetworkCenterClientExceptionDomain;//意外异常错误ErrorDomain

@interface NetworkCenter : ChessHTTPClient

- (NSString *)baseUrl;

+ (instancetype)sharedInstance;

#pragma mark - Network Info Params

- (NSDictionary *)appendAdditionBaseParameters:(BOOL)needUserid;

- (NSDictionary *)appendAdditionBaseParameters;

//按服务端需求，搜集、拼接设备用户的基本
- (NSString *)stringFormatCurrentBaseInfo;

//需要上报给后台的信息
- (NSMutableDictionary *)currentDeviceLogInfo;

//埋点使用 app_device_id
+ (NSString *) appDeviceID;

@end
