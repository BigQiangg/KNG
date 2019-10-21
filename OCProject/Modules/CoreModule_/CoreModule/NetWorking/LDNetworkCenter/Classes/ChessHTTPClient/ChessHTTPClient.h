//
//  AFHTTPClient.h
//  IMSDK
//
//  Created by Xiangqi on 16/7/7.
//  Copyright © 2016年 Xiangqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

//内部网络的错误码
typedef NS_ENUM(NSInteger, LYNetworkErrorCode){
    kLYNetworkCodeEnterBlackList = -85,                 //被拉黑
    kLYNetworkCodeUserTokenInvalidate = -1002,          //用户token失效
    kLYNetworkCodeUserActionForbid = -1008,             //用户被后台拉黑，部分功能被禁止使用
    kLYNetworkCodeBusinessInvalidNeedOriginData = -9999 //业务失效，但是仍需要操作前的数据
};

//token失效
#define LY_TOKEN_INVALID_NOTIFICATION @"user_token_invalid_notification"
#define LY_USER_FORBID_NOTIFICATION @"user_forbid_notification"

@protocol  AFMultipartFormData;

@class AFHTTPSessionManager;

@interface ChessHTTPClient : NSObject

//Read Only Property
@property (nonatomic, strong, readonly) AFHTTPSessionManager    *httpSessionManager;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setup
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  This method should be invoked only once  (at the setup period).
 *
 *  While initializing AFHTTPClient, you can resetup it's baseURL and NSURLSessionConfiguration.
 *  Or you just think this method is a method which is typeof init.
 *
 *  @param aConfiguration : If aConfiguration is setted nil, a default configuration will be used.
 */
- (void)rebuildHTTPSessionManagerWithBaseURL:(NSString *)baseURLString configuration:(NSURLSessionConfiguration *)aConfiguration;

/**
 *  You can customize your AFHTTPResponseSerializer.
 *  This method should be inovked once while you setup your AFHTTPClient.
 *
 *  @param responseSerializer CustomAFHTTPResponseSerializer
 */
- (void)setResponseSerializer:(id)responseSerializer;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - HTTP Method
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)GETWithURLPath:(NSString *)URLPath
            parameters:(NSDictionary *)parameters
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

- (void)POSTWithURLPath:(NSString *)URLPath
             parameters:(NSDictionary *)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

/**
 jsonSerializer 为YES支持application/json,否则采用默认,是否支持数据gzip压缩，Yes需要压缩，NO不需要

 @param URLPath URLPath
 @param parameters parameters
 @param jsonSerializer jsonSerializer
 @param gzip gzip
 @param success success
 @param failure failure 
 */
- (void)POSTWithURLPath:(NSString *)URLPath
             parameters:(NSDictionary *)parameters
   requestJsonSerializer:(BOOL)jsonSerializer
                   gzip:(BOOL)gzip
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

- (void)HEADWithURLPath:(NSString *)URLPath
             parameters:(NSDictionary *)parameters
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

- (void)POSTWithURLPath:(NSString *)URLPath
             parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                success:(void (^)(id responseObject))success
                failure:(void (^)(NSError *error))failure;

- (void)httpRequestWithMethod:(NSString *)method
                      URLPath:(NSString *)URLPath
                   parameters:(NSDictionary *)parameters
                      success:(void (^)(id responseObject))success
                      failure:(void (^)(NSError *error))failure;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Override Response Serializer
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)analyseTaskResponseWithTask:(NSURLSessionDataTask *)task
                      reponseObject:(id)responseObject
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *error))failure;

- (void)analyseFailureWithTask:(NSURLSessionDataTask *)task
                  failureError:(NSError *)error
                       failure:(void (^)(NSError *))failure;

/**
 * Addition which need to be appended (Query string) in NSMutableURLRequest HTTPBody.
 */
- (NSDictionary *)appendAdditionBaseParameters;

/**
 *  Addition which need to be appended in NSMutableURLRequest HTTPHeadfields
 */
- (NSDictionary *)appendAdditionHTTPHeaderFields;

/**
 *  Will send the request, the custom rules for final assembly together
 */
- (void)expendFinalRulesForWillSendRequest:(NSMutableURLRequest *)willSendRequest
                      withRelativeURL:(NSString *)relativeURLString
                      totalParameters:(NSDictionary *)totalParameters;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Task Control
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 *  Cancel the ongoing URLSessionTask which path is like urlPath.
 *  Invoke on MainThread.
 */
- (void)cancelURLSessionTaskWithURLPath:(NSString *)urlPath;

/**
 *  Cancel all ongoing requests
 *  Invoke on MainThread.
 */
- (void)cancelAllHTTPClientRequest;

@end
