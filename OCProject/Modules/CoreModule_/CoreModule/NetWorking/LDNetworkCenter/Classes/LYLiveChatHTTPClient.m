//
//  LYLiveChatHTTPClient.m
//  laoyuegou
//
//  Created by Dombo on 2018/4/2.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import "LYLiveChatHTTPClient.h"

@implementation LYLiveChatHTTPClient

static LYLiveChatHTTPClient* _instance = nil;
+ (instancetype) shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    return _instance ;
}

- (NSString *)baseUrl
{
    NSString *urlString = [ChessHTTPShare walletBaseUrl];
    return urlString;
}

- (NSDictionary *)appendAdditionBaseParameters{
    return [[NetworkCenter sharedInstance] appendAdditionBaseParameters:NO];
}

@end
