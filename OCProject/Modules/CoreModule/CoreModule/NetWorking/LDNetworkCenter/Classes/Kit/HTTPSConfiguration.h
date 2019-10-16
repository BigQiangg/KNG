//
//  HTTPSConfiguration.h
//  laoyuegou
//
//  Created by Xiangqi on 2017/4/19.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPSessionManager;

@interface HTTPSConfiguration : NSObject

- (id)initWithAFHTTPSessionManager:(AFHTTPSessionManager *)sessionManager;

@end
