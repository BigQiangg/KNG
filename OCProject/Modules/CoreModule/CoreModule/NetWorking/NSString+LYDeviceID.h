//
//  NSString+LYDeviceID.h
//  laoyuegou
//
//  Created by smalljun on 15/9/11.
//  Copyright (c) 2015年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LYDeviceID)

+ (NSString *)macString;
+ (NSString *)idfaString;
+ (NSString *)idfvString;
+ (NSString *)getUUIDString;

@end
