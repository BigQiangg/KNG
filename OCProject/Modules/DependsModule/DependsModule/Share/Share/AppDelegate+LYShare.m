//
//  AppDelegate+LYShare.m
//  laoyuegou
//
//  Created by smalljun on 15/6/30.
//  Copyright (c) 2015年 HaiNanLexin. All rights reserved.
//

#import "AppDelegate+LYShare.h"
#import "LYShareUtil.h"

@implementation AppDelegate (LYShare)

/**
 *  初始化分享配置
 */
- (void)initShareSDK
{
    [LYShareUtil registerShareSdks];
}

@end
