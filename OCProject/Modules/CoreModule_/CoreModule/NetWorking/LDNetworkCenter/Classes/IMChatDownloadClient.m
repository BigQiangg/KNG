//
//  IMChatAttachmentDownload.m
//  laoyuegou
//
//  Created by Xiangqi on 16/9/18.
//  Copyright © 2016年 HaiNanLexin. All rights reserved.
//

#import "IMChatDownloadClient.h"

#import "AFCustomResponseSerializer.h"

@interface IMChatDownloadClient ()

@end

@implementation IMChatDownloadClient

- (id)init
{
    if (self = [super init]) {
        [self rebuildHTTPSessionManagerWithBaseURL:nil configuration:nil];
        
        AFCustomResponseSerializer *normalResponseSerializer = [AFCustomResponseSerializer serializer];
//        normalResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream", @"image/jpg", @"text/plain",nil];
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
