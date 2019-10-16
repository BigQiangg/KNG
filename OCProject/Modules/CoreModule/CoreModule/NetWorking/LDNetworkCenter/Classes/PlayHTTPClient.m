//
//  PlayHTTPClient.m
//  laoyuegou
//
//  Created by smalljun on 17/8/30.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "PlayHTTPClient.h"

static PlayHTTPClient   *__sharedInstance = nil;

@implementation PlayHTTPClient

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
    NSString *urlString = [ChessHTTPShare playNetworkBaseUrl];
    return urlString;
}

@end
