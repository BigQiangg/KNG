//
//  ChessHTTPShare.h
//  laoyuegou
//
//  Created by lcb on 2019/6/27.
//  Copyright © 2019 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChessHTTPShare : NSObject
+ (NSString *)networkCenterBaseUrl;
+ (NSString *)plutNetworkBaseUrl;
+ (NSString *)playNetworkBaseUrl;
+ (NSString *)phpNetworkCenterBaseUrl;
+ (NSString *)toutiaoNetworkCenterBaseUrl;
+ (NSString *)walletBaseUrl;
+ (NSString *)phpNetworkBaseUrl;// !< 3.0.2 开始添加的，宋佳钦那边

@end
