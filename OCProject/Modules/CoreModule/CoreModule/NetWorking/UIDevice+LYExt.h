//
//  UIDevice+LYExt.h
//  laoyuegou
//
//  Created by smalljun on 15/5/13.
//  Copyright (c) 2015年 HaiNanLexin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (LYExt)

+ (NSString *)appName;
+ (NSString *)appShortVersion;
+ (NSString *)appBuildVersion;
//传给接口使用的
+ (NSString *)LYGAPPVersion;
+ (CGSize)nativeScreenSize;
+ (NSString *)getNetworkType;

+ (NSString *)deviceModel;
//运营商名称
+ (NSString *)carrierName;

+ (NSString *)carrier;

//获取磁盘可用空间大小
+ (uint64_t)getFreeDiskspace;

@end
