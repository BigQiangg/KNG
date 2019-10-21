//
//  ChessHTTPShare.m
//  laoyuegou
//
//  Created by lcb on 2019/6/27.
//  Copyright © 2019 HaiNanLexin. All rights reserved.
//

#import "ChessHTTPShare.h"
#import "NetworkBaseConfigure.h"

@implementation ChessHTTPShare

#pragma mark -- 网络库base url处理
+ (NSString *)networkCenterBaseUrl
{
    return [[self class] networkBaseUrl];
}

+ (NSString *)plutNetworkBaseUrl
{
    return [[self class] plutBaseUrl];
}

+ (NSString *)playNetworkBaseUrl
{
    return [[self class] playBaseUrl];
}

+ (NSString *)phpNetworkCenterBaseUrl {
    return [[self class] phpNetworkBaseUrl];
}

+ (NSString *)toutiaoNetworkCenterBaseUrl {
    return [[self class] toutiaoNetworkBaseUrl];
}

+ (NSString *)plutBaseUrl
{
    NSString *urlString = nil;
    switch ([NetworkBaseConfigure buildEnvironment]) {
        case 1:
            urlString = @"http://pluto-dev.lygou.cc";
            break;
        case 2:
        {
            urlString = @"http://pluto.lygou.cc";
            break;
        }
        case 3:
            urlString = @"http://pluto-test.lygou.cc";
            break;
        case 5:
            urlString = @"http://pluto-stag.lygou.cc";
            break;
        default:
            urlString = @"http://pluto.lygou.cc";
            break;
    }
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];

    return urlString;
}

+ (NSString *)playBaseUrl
{
    NSString *urlString = nil;
    switch ([NetworkBaseConfigure buildEnvironment]) {
        case 1:
            urlString = @"http://play-dev.lygou.cc";
            //            urlString = @"http://latest-dev-play.lygou.cc";
            break;
        case 2:
        {
            urlString = @"http://play.lygou.cc";
            break;
        }
        case 3:
            urlString = @"http://play-test.lygou.cc";
            //            urlString = @"http://latest-test-play.lygou.cc";
            break;
        case 5:
            urlString = @"http://play-stag.lygou.cc";
            //            urlString = @"http://latest-staging-play.lygou.cc";
            break;
        default:
            urlString = @"http://play.lygou.cc";
            break;
    }
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    
    return urlString;
}



+ (NSString *)walletBaseUrl
{
    NSString *urlString = nil;
    switch ([NetworkBaseConfigure buildEnvironment]) {
        case 1:
            urlString = @"http://gateway-dev.lygou.cc";
            //            urlString = @"http://latest-dev-play.lygou.cc";
            break;
        case 2:
        {
            urlString = @"http://gateway.lygou.cc";
            break;
        }
        case 3:
            urlString = @"http://gateway-test.lygou.cc";
            //            urlString = @"http://latest-test-play.lygou.cc";
            break;
        case 5:
            urlString = @"http://gateway-stag.lygou.cc";
            //            urlString = @"http://latest-staging-play.lygou.cc";
            break;
        default:
            urlString = @"http://gateway.lygou.cc";
            break;
    }

    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    
    return urlString;
}

+ (NSString *)networkBaseUrl
{
    NSString *urlString = nil;
    switch ([NetworkBaseConfigure buildEnvironment])
    {
        case 1:
        {
            urlString = @"http://latest-dev-appv2.lygou.cc";
            
            break;
        }
            
        case 2:
        {
            urlString = @"http://appv2.lygou.cc";
            
            break;
        }
        case 3:
        {
            urlString = @"http://latest-test-appv2.lygou.cc";
            break;
        }
            
        case 5:
        {
            urlString = @"http://latest-staging-appv2.lygou.cc";
            break;
        }
            
        default:
        {
            urlString = @"http://latest-dev-appv2.lygou.cc";
            
            break;
        }
    }
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];

    return urlString;
}

+ (NSString *)phpNetworkBaseUrl
{
    NSString *urlString = nil;
    switch ([NetworkBaseConfigure buildEnvironment])
    {
        case 1:
        {
            urlString = @"http://latest-dev-api.lygou.cc";
            
            break;
        }
            
        case 2:
        {
            urlString = @"http://api.lygou.cc";
            
            break;
        }
        case 3:
        {
            urlString = @"http://latest-test-api.lygou.cc";
            break;
        }
            
        case 5:
        {
            urlString = @"http://latest-staging-api.lygou.cc";
            break;
        }
            
        default:
        {
            urlString = @"http://latest-dev-api.lygou.cc";
            
            break;
        }
    }
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    return urlString;
}
+ (NSString *)toutiaoNetworkBaseUrl
{
    NSString *urlString = nil;
    switch ([NetworkBaseConfigure buildEnvironment])
    {
        case 1:
        {
            urlString = @"http://latest-dev-apicdn.lygou.cc";
            
            break;
        }
            
        case 2:
        {
            urlString = @"http://apicdn.lygou.cc";
            
            break;
        }
        case 3:
        {
            urlString = @"http://latest-test-apicdn.lygou.cc";
            break;
        }
            
        case 5:
        {
            urlString = @"http://latest-staging-apicdn.lygou.cc";
            break;
        }
            
        default:
        {
            urlString = @"http://latest-dev-apicdn.lygou.cc";
            
            break;
        }
    }
    
    urlString = [urlString stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
    
    return urlString;
}

@end
