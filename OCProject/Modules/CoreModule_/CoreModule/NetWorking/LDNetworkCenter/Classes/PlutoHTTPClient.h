//
//  PlutoHTTPClient.h
//  laoyuegou
//
//  Created by Xiangqi on 2017/4/18.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "ChessHTTPClient.h"
#import "ChessHTTPShare.h"
#import "NetworkCenter.h"
extern NSString * const PlutoHTTPClientErrorDomain;//具体的业务错误ErrorDomain
extern NSString * const PlutoHTTPClientExceptionDomain;//异常错误ErrorDomain

@interface PlutoHTTPClient : ChessHTTPClient

+ (instancetype)sharedInstance;

@end
