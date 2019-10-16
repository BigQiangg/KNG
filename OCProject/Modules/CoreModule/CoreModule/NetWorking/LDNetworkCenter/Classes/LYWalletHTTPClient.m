//
//  LYWalletHTTPClient.m
//  laoyuegou
//
//  Created by hedgehog on 2018/1/8.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import "LYWalletHTTPClient.h"

static LYWalletHTTPClient   *__sharedInstance = nil;

@implementation LYWalletHTTPClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    
    return __sharedInstance;
}

-(NSString *)baseUrl
{
    NSString *urlString = [ChessHTTPShare walletBaseUrl];
    return urlString;
}

@end
