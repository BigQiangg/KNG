//
//  LYCompositioInterfaceHelper.h
//  laoyuegou
//
//  Created by smalljun on 2017/11/1.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>

//处理组合接口的工具
@interface LYCompositioInterfaceHelper : NSObject

+ (void)handleUserResourceCompositionData:(NSDictionary *)response;

+ (void)handleAppResourceCompositionData:(NSDictionary *)response;

+ (void)handlePlayGameCompositionData:(NSDictionary *)response;

+ (void)handlePlayGameNewCouponsListCompositionData:(NSDictionary *)response;

//游客身份的陪玩游戏合并数据
+ (void)handleVisitorPlayGameCompositionData:(NSDictionary *)response;

@end
