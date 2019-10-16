//
//  TouTiaoHttpClient.m
//  laoyuegou
//
//  Created by lyg on 2019/4/30.
//  Copyright © 2019 HaiNanLexin. All rights reserved.
//

#import "TouTiaoHttpClient.h"

#import "AFTextPainResponseSerializer.h"
#import "HTTPSConfiguration.h"
#import <SystemConfiguration/CaptiveNetwork.h>

static     TouTiaoHttpClient  *__sharedInstance = nil;

@interface TouTiaoHttpClient ()

@property (nonatomic, strong) HTTPSConfiguration *httpsConfiguration;

@end

@implementation TouTiaoHttpClient

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
    });
    
    return __sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        //Init ChessHttpClient
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.allowsCellularAccess = YES;
        configuration.timeoutIntervalForRequest = 60.0;
        
        [self rebuildHTTPSessionManagerWithBaseURL:[self baseUrl] configuration:configuration];
        
        AFJSONResponseSerializer *JSONResponseSerializer = [AFJSONResponseSerializer serializer];
        [JSONResponseSerializer setRemovesKeysWithNullValues:YES];
        
        AFTextPainResponseSerializer *textPainResponseSerializer = [AFTextPainResponseSerializer serializer];
        textPainResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/octet-stream", @"text/html", nil];
        
        AFCompoundResponseSerializer *compoundResponseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[JSONResponseSerializer, textPainResponseSerializer]];
        [self setResponseSerializer:compoundResponseSerializer];
        
        self.httpsConfiguration = [[HTTPSConfiguration alloc] initWithAFHTTPSessionManager:self.httpSessionManager];
    }
    
    return self;
}


- (NSString *)baseUrl
{
    NSString *urlString = [ChessHTTPShare toutiaoNetworkCenterBaseUrl];
    return urlString;
}

@end
