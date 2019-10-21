//
//  LYRecordDownloadClient.m
//  laoyuegou
//
//  Created by Jinxiansen on 2017/11/17.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "LYRecordDownloadClient.h"
#import "AFCustomResponseSerializer.h"

@implementation LYRecordDownloadClient

- (id)init
{
    if (self = [super init]) {
        [self rebuildHTTPSessionManagerWithBaseURL:nil configuration:nil];
        AFCustomResponseSerializer *normalResponseSerializer = [AFCustomResponseSerializer serializer];
        [self setResponseSerializer:normalResponseSerializer];
    }
    
    return self;
}

- (void)analyseTaskResponseWithTask:(NSURLSessionDataTask *)task
                      reponseObject:(id)responseObject
                            success:(void (^)(id response))success
                            failure:(void (^)(NSError *error))failure
{
    if (success) success(responseObject);
}

- (void)analyseFailureWithTask:(NSURLSessionDataTask *)task
                  failureError:(NSError *)error
                       failure:(void (^)(NSError *))failure
{
    if (failure) failure(nil);
}

@end
