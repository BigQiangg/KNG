//
//  NetworkHelper.h
//  laoyuegou
//
//  Created by SmallJun on 2019/7/11.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkHelper : NSObject

#pragma mark - 保存和读取UUID

+(void)saveUUIDToKeyChain;

+(NSString *)readUUIDFromKeyChain;

@end
