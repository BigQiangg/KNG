//
//  PlutoHTTPClient.m
//  laoyuegou
//
//  Created by Xiangqi on 2017/4/18.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "PlutoHTTPClient.h"
#import "AFTextPainResponseSerializer.h"
#import "HTTPSConfiguration.h"
#import "EncryptUtil.h"
#import "NetworkBaseConfigure.h"
#import "NSObject+LYExt.h"

NSString * const PlutoHTTPClientErrorDomain = @"PlutoHTTPClientErrorDomain";
NSString * const PlutoHTTPClientExceptionDomain = @"PlutoHTTPClientExceptionDomain";

static     PlutoHTTPClient   *__sharedInstance = nil;

@interface PlutoHTTPClient ()

@property (nonatomic, strong) HTTPSConfiguration *httpsConfiguration;

@end

@implementation PlutoHTTPClient

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
        [self rebuildHTTPSessionManagerWithBaseURL:[self baseUrl] configuration:nil];
        
        AFJSONResponseSerializer *JSONResponseSerializer = [AFJSONResponseSerializer serializer];
        [JSONResponseSerializer setRemovesKeysWithNullValues:YES];
        
        AFTextPainResponseSerializer *textPainResponseSerializer = [AFTextPainResponseSerializer serializer];
        textPainResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/octet-stream", nil];
        
        AFCompoundResponseSerializer *compoundResponseSerializer = [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:@[JSONResponseSerializer, textPainResponseSerializer]];
        [self setResponseSerializer:compoundResponseSerializer];
        
        self.httpsConfiguration = [[HTTPSConfiguration alloc] initWithAFHTTPSessionManager:self.httpSessionManager];
    }
    
    return self;
}

-(NSString *)baseUrl
{
    NSString *urlString = [ChessHTTPShare plutNetworkBaseUrl];
    return urlString;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ResponseSerializer Code
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)analyseTaskResponseWithTask:(NSURLSessionDataTask *)task
                      reponseObject:(id)responseObject
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    if ([self validateBaseResponse:responseObject error:&error withTask:task]) {
        if (success) {
            success(responseObject);
        }
    } else {
        [self analyseFailureWithTask:task failureError:error failure:failure];
    }
}

- (BOOL)validateBaseResponse:(NSDictionary *)response  error:(NSError **)error withTask:(NSURLSessionDataTask *)task
{
    if (![response isKindOfClass:[NSDictionary class]]) {
        
        return NO;
    } else {
        NSInteger errorCode = [response[@"errcode"] integerValue];
        NSString *errorMessage = response[@"errmsg"];
        
        //如果发现token失效，直接退出,在这统一一次性处理token失效问题
        if (errorCode == kLYNetworkCodeUserTokenInvalidate){
            [[NSNotificationCenter defaultCenter] postNotificationName:LY_TOKEN_INVALID_NOTIFICATION object:errorMessage];
            *error = [NSError errorWithDomain:PlutoHTTPClientErrorDomain
                                         code:errorCode
                                     userInfo:@{NSLocalizedDescriptionKey : errorMessage,
                                                NSLocalizedFailureReasonErrorKey : @"token失效"
                                                }];
            return NO;
        }
        
        if (errorCode == kLYNetworkCodeUserActionForbid && [errorMessage length]){
            [[NSNotificationCenter defaultCenter] postNotificationName:LY_USER_FORBID_NOTIFICATION object:errorMessage];
        }
        
        if (errorCode != 0) {
            if ([errorMessage length]) {
                *error = [NSError errorWithDomain:PlutoHTTPClientErrorDomain
                                             code:errorCode
                                         userInfo:@{NSLocalizedDescriptionKey : errorMessage,
                                                    @"errresponse":response
                                                    }];
            } else {
                //不确定错误，统一按照1001处理
                *error = [self customErrorWithCode:1001 withTask:task];
            }
            return NO;
        }
        
        return YES;
    }
}

- (void)analyseFailureWithTask:(NSURLSessionDataTask *)task
                  failureError:(NSError *)error
                       failure:(void (^)(NSError *))failure
{
    
    if ([NetworkBaseConfigure buildEnvironment] == 1 || [NetworkBaseConfigure buildEnvironment] == 3) {
        NSDictionary *userInfo = error.userInfo;
        [userInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSData class]]) {
                
                NSString *url = [[task.currentRequest URL] absoluteString];
                NSData *data = (NSData *)obj;
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"currentURL == \n%@ \n ,network error reson == %@,",url,str);
            }
        }];
    }
    
    //DEBUG的时候，可以查看error的NSLocalizedDescriptionKey
    if ([error.domain isEqualToString:PlutoHTTPClientErrorDomain]) {
        if (failure) {
            failure(error);
        }
    } else if ([NetworkBaseConfigure buildEnvironment] == 1) { //如果是开发环境，提示具体的错误信息
        if (failure) {
            NSLog(@"error desc == %@",error);
            NSData * data = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
            NSString *desc = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSError *newError = [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey : desc}];
            failure(newError);
        }
    } else { //如果不是开发环境，提示语为通用提示语
        //错误类型含有： 1.网络异常 2.服务器异常 3.request参数拼接 出错 4. response（JSON格式）解析出错
        //这里初步将不是业务的错误code 统一处理为 "网络异常"
        
        NSError *e = nil;
        if (error.code == NSURLErrorNotConnectedToInternet) {
            e = [self customErrorWithCode:NSURLErrorNotConnectedToInternet withTask:task];
        } else {
            e = [self customErrorWithCode:1001 withTask:task];
        }
        //暂时通过这种形式将真正的错误对象通过这个形式往外暴露
        if (e) {
            e.extensionInfo = error;
        }
        
        if (failure) {
            failure(e);
        }
    }
}

- (NSError *)customErrorWithCode:(NSInteger)errorCode withTask:(NSURLSessionDataTask *)task
{
    NSString *description = [[self customErrorMappingDictionaryWithTask:task] objectForKey:[@(errorCode) stringValue]];
    NSError *error = [NSError errorWithDomain:PlutoHTTPClientExceptionDomain
                                         code:errorCode
                                     userInfo:@{NSLocalizedDescriptionKey: description}];
    
    return error;
}

- (NSDictionary *)customErrorMappingDictionaryWithTask:(NSURLSessionDataTask *)task
{
    //后期补充类型，抓取error产生的原因
    //错误类型含有： 1.网络异常 2.服务器异常 3.request参数拼接 出错 4. response（JSON格式）解析出错
    if ([NetworkBaseConfigure buildEnvironment] == 3 || [NetworkBaseConfigure buildEnvironment] == 1) {
        NSString *errorStr = [NSString stringWithFormat:@"%@ \n 网络不给力",task.currentRequest.URL.path];
        return @{@"1001" : errorStr,
                 [@(NSURLErrorNotConnectedToInternet) stringValue] : errorStr
                 };
        
    }
    return @{@"1001" : @"网络不给力",
             [@(NSURLErrorNotConnectedToInternet) stringValue] : @"网络不给力"
             };
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - RequestSerializer Code
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSDictionary *)appendAdditionBaseParameters
{
    return [[NetworkCenter sharedInstance] appendAdditionBaseParameters:NO];
}

- (NSDictionary *)appendAdditionHTTPHeaderFields
{
    NSString *clientId = [NetworkBaseConfigure getCurrentLoginUserId];
    NSString *appKey = [NetworkBaseConfigure appkey];
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *timestampStr = [NSString stringWithFormat:@"%lld",(long long)(timestamp *1000)]; //毫秒
    NSString *token = [NetworkBaseConfigure getCurrentLoginUserToken];
    
    NSMutableDictionary *dictHeader = [NSMutableDictionary dictionary];
    dictHeader[@"userId"] = clientId;
    dictHeader[@"Auth-Appkey"] = appKey;
    dictHeader[@"Auth-Timestamp"] = timestampStr;
    
    dictHeader[@"X-AppID"] = @"1";
    dictHeader[@"X-AppToken"] = @"123";


    NSString *signStr = [NSString stringWithFormat:@"LYG:%@:TOKEN:%@:CT:%@", clientId, token, timestampStr];
    NSString *sha1 = [[EncryptUtil sha1:signStr] uppercaseString];
    dictHeader[@"Auth-Sign"] = sha1;
    
    dictHeader[@"X-Env"] = @[@"dev",@"prod",@"test",@"prod",@"staging"][[NetworkBaseConfigure buildEnvironment] - 1];
   // dictHeader[@"X-Cookie-Grayslice"] = @"";// 假的 cookie
//    dictHeader[@"X-Branch"] = [LYServerConfig shared].hostVariable?:@"working";
    dictHeader[@"X-Branch"] = @"working";
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode]?:@"";
    
    dictHeader[@"Auth-Country"] = countryCode;

    NSString *timeZone = [@([NSTimeZone systemTimeZone].secondsFromGMT) stringValue]?:@"";
    
    dictHeader[@"Auth-TimeZone"] = timeZone;
    
    dictHeader[@"Client-Info"] = [[NetworkCenter sharedInstance] stringFormatCurrentBaseInfo];
    return dictHeader;
}

@end
