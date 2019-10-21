//
//  NetworkCenter.m
//  NewVersionOfAFNetworking
//
//  Created by XiangqiTu on 16/3/8.
//  Copyright © 2016年 laoyuegou. All rights reserved.
//

#import "NetworkCenter.h"
#import "NSString+MD5.h"
#import "EncryptUtil.h"
#import "AFTextPainResponseSerializer.h"
#import "HTTPSConfiguration.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "NetworkBaseConfigure.h"
#import "NetworkHelper.h"
#import "UIDevice+LYExt.h"
#import "NSString+LYDeviceID.h"
#import "NSObject+LYExt.h"
#import "FoundtionConst.h"

NSString * const kLYGNetworkCenterIssueFailtureDomain = @"kLYGNetworkCenterIssueFailtureDomain"; //具体的业务错误ErrorDomain
NSString * const kLYGNetworkCenterClientExceptionDomain = @"kLYGNetworkCenterClientExceptionDomain";//意外异常错误ErrorDomain

static     NetworkCenter   *__sharedInstance = nil;

@interface NetworkCenter ()

@property (nonatomic, strong) HTTPSConfiguration *httpsConfiguration;

@end

@implementation NetworkCenter

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

-(NSString *)baseUrl
{
    NSString *urlString = [ChessHTTPShare networkCenterBaseUrl];
    return urlString;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Request Serializer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//基础参数
- (NSDictionary *)appendAdditionBaseParameters:(BOOL)needUserid
{
    //方便后台的api版本号,分别多包统一参数
    NSString *appAPIVersion = [NetworkBaseConfigure apiVersion];
    NSString *appShortVersion = [UIDevice appShortVersion]?:@"";
    
    NSString *uid = [NetworkBaseConfigure getCurrentLoginUserId];
    NSString *token = [NetworkBaseConfigure getCurrentLoginUserToken];
    
    NSString *region = @"zh-Hans";
//    NSString *region = [LYLanguageTools shareInstance].currentLanguage;
    NSString *timeZone = [@([NSTimeZone systemTimeZone].secondsFromGMT) stringValue]?:@"";
    
    NSString *visitorToken = [NetworkBaseConfigure getCurrentVisitorToken];
    
    CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
    NSString *screenWidth = [NSString stringWithFormat:@"%ld",(long)screenSize.width];
    NSString *screenHeight = [NSString stringWithFormat:@"%ld",(long)screenSize.height];

    NSDictionary *params = @{
                             @"platform" : AppPlatform,
                             @"appver" : appAPIVersion,
                             @"realVer" : appShortVersion,
                             @"appfrom" : AppChanel,
                             @"p_width" : screenWidth,
                             @"p_height" : screenHeight,
                             @"region" : region,
                             @"time_zone" : timeZone,
                             @"unlogin_token" : visitorToken,
                             };
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    [mut addEntriesFromDictionary:params];
    if (needUserid && [uid length]) {
        [mut setValue:uid forKey:@"user_id"];
    }
    [mut setValue:token forKey:@"token"];
    
    return mut;
}

- (NSDictionary *)appendAdditionBaseParameters
{
    return [self appendAdditionBaseParameters:YES];
}

/**
 * 请求headField中 包含签名信息
 */
- (void)expendFinalRulesForWillSendRequest:(NSMutableURLRequest *)willSendRequest
                           withRelativeURL:(NSString *)relativeURLString
                           totalParameters:(NSDictionary *)totalParameters
{
    NSDictionary *dictParams = [self encodingAllParams:totalParameters];
    NSDictionary *additionalHeaderDictionary = [self buildRequestHeaderFromParams:dictParams
                                                                        URLString:relativeURLString
                                                                           method:willSendRequest.HTTPMethod];
    [additionalHeaderDictionary enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![willSendRequest valueForHTTPHeaderField:field]) {
            [willSendRequest setValue:value forHTTPHeaderField:field];
        }
    }];
}

- (NSDictionary *)encodingAllParams:(NSDictionary *)reqParams
{
    NSMutableDictionary *result = nil;
    if(reqParams) {
        result = [NSMutableDictionary dictionary];
        [reqParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (obj) {
                NSString *value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)[obj description], NULL, CFSTR(":/?#[]@!$&’'()*+,;="), kCFStringEncodingUTF8));
                result[key] = value;
            }
        }];
    }
    return result;
}

//根据服务端约定将签名参数放入header中
-(NSDictionary *)buildRequestHeaderFromParams:(NSDictionary *)reqParams
                                    URLString:(NSString *)URLString
                                       method:(NSString *)method
{
    NSString *appKey = [NetworkBaseConfigure appkey];
    NSString *appSecret = [NetworkBaseConfigure appSecret];
    NSMutableDictionary *dictHeader = [NSMutableDictionary dictionary];
    dictHeader[@"Auth-Appkey"] = appKey;
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    dictHeader[@"Auth-Timestamp"] = [NSString stringWithFormat:@"%lld",(long long)timestamp];
    
    NSMutableString *restfulParam = [[NSMutableString alloc] initWithString:@""];
    
    NSArray *arrayKeys = [reqParams allKeys];
    //  NSArray *arrayKeys = @[@"Abc",@"abe",@"tbe",@"abc"]; 测试排序
    NSArray *sortResult = [arrayKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *string1, NSString *string2) {
        return [string1 caseInsensitiveCompare:string2];
    }];
    
    [sortResult enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [restfulParam appendFormat:@"%@=%@",obj,reqParams[obj]];
    }];
    
    NSString *signStr = [NSString stringWithFormat:@"%@#%@#%lld#%@#omg#%@#%@",method,URLString,(long long)timestamp,appKey,appSecret,restfulParam];
    NSString *md5Sign = [signStr MD5Digest];
    dictHeader[@"Auth-Sign"] = md5Sign;
    dictHeader[@"Client-Info"] = [self stringFormatCurrentBaseInfo];
    //prod staging test dev
    //1 为开发环境 2为store产品环境  3为测试环境 4为企业产品环境 5为预发布环境
    dictHeader[@"X-Env"] = @[@"dev",@"prod",@"test",@"prod",@"staging"][[NetworkBaseConfigure buildEnvironment] - 1];
  //  dictHeader[@"X-Cookie-Grayslice"] = @"";// 假的 cookie
//    dictHeader[@"X-Branch"] =  [LYServerConfig shared].hostVariable?:@"working";
    dictHeader[@"X-Branch"] =  @"working";
    
    NSLocale *currentLocale = [NSLocale currentLocale];

    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode]?:@"";

    // NSArray *countryArray = [NSLocale ISOCountryCodes];
    
    dictHeader[@"Auth-Country"] = countryCode;
    
    NSString *timeZone = [@([NSTimeZone systemTimeZone].secondsFromGMT) stringValue]?:@"";
    
    dictHeader[@"Auth-TimeZone"] = timeZone;

    
    return dictHeader;
}

- (NSString *)stringFormatCurrentBaseInfo
{
    NSDictionary *baseInfo = (NSDictionary *)[self currentDeviceBaseInfo];
    
    NSMutableString *baseInfoString =[NSMutableString stringWithString:@"LYG;"];
    
    [baseInfo enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        [baseInfoString appendFormat:@" %@/%@",key,[obj stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }];
    NSString *hasPre = @"(";
    NSString *hasSub = @")";
    NSString *result = [NSString stringWithFormat:@"%@%@%@",hasPre,baseInfoString,hasSub];
    
    return result;
}

//按服务端需求，搜集、拼接设备用户的基本
- (NSMutableDictionary *)currentDeviceBaseInfo
{
    NSMutableDictionary *baseInfo = [NSMutableDictionary dictionary];
    baseInfo[@"id"] = [NetworkBaseConfigure appkey];
    baseInfo[@"v"] = [NetworkBaseConfigure apiVersion];
    baseInfo[@"realVer"] = [UIDevice appShortVersion]?:@"";
    baseInfo[@"f"] = AppChanel;
    baseInfo[@"p"] = AppPlatform;
    
    NSString *idfa = [NSString idfaString];
    NSString *idfaString = [EncryptUtil encryptWithText:idfa];
    baseInfo[@"uuid"] = idfaString?:@"";
    
    NSString *idfv = [NSString idfvString];
    NSString *idfvString = [EncryptUtil encryptWithText:idfv];
    baseInfo[@"uuid1"] = idfvString?:@"";
    
    NSString *uuid2 = [NetworkHelper readUUIDFromKeyChain];
    baseInfo[@"uuid2"] = mAvailableString(uuid2);
    
    //神策匿名ID
    NSString *sensorAnonymousID = [NetworkBaseConfigure getSensorAnonymousId];
    if (LY_CHECK_STRING(sensorAnonymousID)) {
        baseInfo[@"sensorsId"] = sensorAnonymousID;
    }
    
    NSString *deviceModel = [UIDevice deviceModel]?:@"";
    NSString *deviceModelEncrypt = [EncryptUtil encryptWithText:deviceModel];
    baseInfo[@"b"] = deviceModelEncrypt?:@"";
    
    NSString *carrierName = [UIDevice carrierName]?:@"";
    NSString *carrierNameEncrypt = [EncryptUtil encryptWithText:carrierName];
    baseInfo[@"car"] = carrierNameEncrypt?:@"";
    
    CGSize screenSize = [UIDevice nativeScreenSize];
    NSString *screenWidth = [NSString stringWithFormat:@"%ld",(long)screenSize.width];
    NSString *screenHeight = [NSString stringWithFormat:@"%ld",(long)screenSize.height];
    
    NSString *size =  [NSString stringWithFormat:@"%@*%@",screenWidth,screenHeight];
    NSString *sizeEncrypt = [EncryptUtil encryptWithText:size];
    baseInfo[@"res"] = sizeEncrypt?:@"";
    
    NSString *uid = [NetworkBaseConfigure getCurrentLoginUserId];
    NSString *token = [NetworkBaseConfigure getCurrentLoginUserToken];
    if (uid && token) {
        baseInfo[@"uid"] = uid;
        baseInfo[@"t"] = token;
    }
    
    NSString *region = @"zh-Hans";
//    NSString *region = [LYLanguageTools shareInstance].currentLanguage;
    baseInfo[@"re"] = region;
    NSString *timeZone = [@([NSTimeZone systemTimeZone].secondsFromGMT) stringValue]?:@"";
    
    baseInfo[@"tz"] = timeZone;
    
    baseInfo[@"os"] = [[UIDevice currentDevice] systemName];
    baseInfo[@"osv"] = [[UIDevice currentDevice] systemVersion];
    
    baseInfo[@"net"] = [UIDevice getNetworkType];
    baseInfo[@"lt"] = [NSString stringWithFormat:@"%lld",(long long)[[NSDate date] timeIntervalSince1970]];
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode]?:@"";
    baseInfo[@"cd"] = countryCode;//国家码
    
    return baseInfo;
}

//需要上报给后台的信息
- (NSMutableDictionary *)currentDeviceLogInfo
{
    NSMutableDictionary *baseInfo = [NSMutableDictionary dictionary];
    
    NSString *mid = [NetworkHelper readUUIDFromKeyChain];
    baseInfo[@"mid"] = mid;
    
    NSString *idfa = [NSString idfaString];
    baseInfo[@"ifa"] = idfa?:@"";
   
    NSString *idfv = [NSString idfvString];
    baseInfo[@"ifv"] = idfv?:@"";

    baseInfo[@"ky"] = @"";              //苹果设备的生产序列号，无法获取
    
    NSString *ifname = [(NSArray *)(__bridge_transfer id)CNCopySupportedInterfaces() firstObject];
    NSDictionary *info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
    NSLog(@"%@ => %@",ifname,info);
    baseInfo[@"wf"] = @"";
    baseInfo[@"wfbs"] = @"";
    if (info) {
        for (NSString *name in info) {
            
            if ([name isEqualToString:@"SSID"]) {
                baseInfo[@"wf"] = info[name]?:@"";                  //wifi的ssid名字
            } else if ([name isEqualToString:@"BSSID"]) {
                baseInfo[@"wfbs"] = info[name]?:@"";                //wifi的bssid
            }
        }
    }

    baseInfo[@"mc"] = @"";                  //wifi的mac，无法获取，一般认为BSSID就是Wi-Fi的MAC
    
    NSString *language =  [[[NSBundle mainBundle] preferredLocalizations] firstObject];
    baseInfo[@"lg"] = language?:@"";        //系统语言
    NSString *timeZone = [NSTimeZone systemTimeZone].name?:@"";
    baseInfo[@"tz"] = timeZone;             //系统时区
    
    CGSize screenSize = [UIDevice nativeScreenSize];
    NSString *screenWidth = [NSString stringWithFormat:@"%ld",(long)screenSize.width];
    NSString *screenHeight = [NSString stringWithFormat:@"%ld",(long)screenSize.height];
    NSString *size =  [NSString stringWithFormat:@"%@*%@",screenWidth,screenHeight];
    baseInfo[@"sr"] = size?:@"";                                    //屏幕分辨率
    
    baseInfo[@"pl"] = [[UIDevice currentDevice] model]?:@"";        //平台 （iOS，iPad，iPhone，iPod）
    baseInfo[@"op"] = [UIDevice carrier]?:@"";                    //运营商（46001，46002 etc..）
    baseInfo[@"mf"] = @"iPhone";                                    //厂商，iPhone
    baseInfo[@"ov"] = [[UIDevice currentDevice] systemVersion];     //系统版本
    baseInfo[@"os"] = @"2";                                         //系统（1=安卓，2=iOS）
    
    //------额外参数------
    baseInfo[@"net"] = [UIDevice getNetworkType];
    baseInfo[@"aid"] = [NetworkBaseConfigure appkey];
    baseInfo[@"appVer"] = [NetworkBaseConfigure apiVersion];
    baseInfo[@"realVer"] = [UIDevice appShortVersion]?:@"";
    
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *countryCode = [currentLocale objectForKey:NSLocaleCountryCode]?:@"";
    baseInfo[@"cd"] = countryCode;                                  //国家码
    
    //20180806
    baseInfo[@"chanel"] = AppChanel;                                //渠道号
    
    return baseInfo;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Response Serializer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)analyseTaskResponseWithTask:(NSURLSessionDataTask *)task
                      reponseObject:(id)responseObject
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *error))failure
{
    NSError *error = nil;
    if ([self validateBaseResponse:responseObject error:&error withPath:task.currentRequest.URL.path]) {
        if (success) {
            success(responseObject);
        }
    } else {
        [self analyseFailureWithTask:task failureError:error failure:failure];
    }
}

- (BOOL)validateBaseResponse:(NSDictionary *)response  error:(NSError **)error withPath:(NSString *)urlPath
{
    if ([response isKindOfClass:[NSDictionary class]]) {
        if ([[response allKeys] containsObject:@"errcode"]) {
            
            NSInteger errorCode = [response[@"errcode"] integerValue];
            NSString *errorMessage = response[@"errmsg"];
            
            //语音通话中，如果是发起通话接口，需要返回所有信息进行处理
            if ([urlPath containsString:@"/pumpkin/initcall"]) {
                return YES;
            }
            
            //2.6.2 Add by XiangqiTu
            if (errorCode == kLYNetworkCodeBusinessInvalidNeedOriginData) {
                return YES;
            }
            
            
            //如果发现token失效，直接退出,在这统一一次性处理token失效问题
            if (errorCode == kLYNetworkCodeUserTokenInvalidate){
                [[NSNotificationCenter defaultCenter] postNotificationName:LY_TOKEN_INVALID_NOTIFICATION object:errorMessage];
                *error = [NSError errorWithDomain:kLYGNetworkCenterIssueFailtureDomain
                                             code:errorCode
                                         userInfo:@{NSLocalizedDescriptionKey : errorMessage,
                                                    NSLocalizedFailureReasonErrorKey : @"token失效"
                                                    }];
                return NO;
            }
            
            if (errorCode == kLYNetworkCodeUserActionForbid && [errorMessage length]){
                [[NSNotificationCenter defaultCenter] postNotificationName:LY_USER_FORBID_NOTIFICATION object:errorMessage];
            }
            
            if (errorMessage && [errorMessage length] && errorCode != 0) {
                *error = [NSError errorWithDomain:kLYGNetworkCenterIssueFailtureDomain
                                             code:errorCode
                                         userInfo:@{NSLocalizedDescriptionKey : errorMessage
                                                    }];
                return NO;
            }
        }
        
        return YES;
    } else {
        if ([response isKindOfClass:[NSData class]]) {
            NSData *data = (NSData *)response;
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"network err description == %@",str);
        }
    }
    return NO;
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
    if ([error.domain isEqualToString:kLYGNetworkCenterIssueFailtureDomain]) {
        if (failure) {
            failure(error);
        }
    } else {
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
    NSError *error = [NSError errorWithDomain:kLYGNetworkCenterClientExceptionDomain
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

+ (NSString *)appDeviceID{
    NSString *idfa = [NSString idfaString];
    NSString *idfaString = [EncryptUtil encryptWithText:idfa];
    if (LY_CHECK_STRING(idfaString)) {
        return idfaString;
    }
    
    
    NSString *idfv = [NSString idfvString];
    NSString *idfvString = [EncryptUtil encryptWithText:idfv];
    if (LY_CHECK_STRING(idfvString)) {
        return idfvString;
    }
    
    NSString *uuid2 = [NetworkHelper readUUIDFromKeyChain];
    if (LY_CHECK_STRING(uuid2)) {
        return uuid2;
    }
    
    return @"";
}

@end
