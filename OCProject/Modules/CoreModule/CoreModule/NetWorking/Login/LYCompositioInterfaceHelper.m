//
//  LYCompositioInterfaceHelper.m
//  laoyuegou
//
//  Created by smalljun on 2017/11/1.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "LYCompositioInterfaceHelper.h"
//#import "LYAppUpdateManager.h"
//#import "LYPlayGameUtil.h"
//#import "LYLocalConfigurationDao.h"
//#import "LYCDNResourcesManager.h"
//#import "LYImageConfig.h"
//#import "LYPlayGameManager.h"
//#import "LYCouponsListPopupView.h"
//#import "LYSplashScreenManager.h"
//#import <LDMMPopupView/MMPopupWindow.h>

//#import "LYRNConstDefinition.h"
//#import "LYRNManager.h"
//#import "LYRNOpenNativeModule.h"
#import "LYDAOManager.h"

@implementation LYCompositioInterfaceHelper

+ (void)handleUserResourceCompositionData:(NSDictionary *)response
{
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *contentForDict = response[@"data"];
        
        [[LYDAOManager sharedInstance].localConfigurationDao saveData:contentForDict forKey: KRN_Cache_User_Sys_Config_Key];
        
        NSArray *allKeys = [contentForDict allKeys];
        
//        if ([allKeys containsObject:@"upgrade_force"]) {
//            NSDictionary *contentDict = contentForDict[@"upgrade_force"];
//            [LYAppUpdateManager checkAppUpgrade:contentDict];
//        }
        
        if ([allKeys containsObject:@"userinfo"]) {
            NSDictionary *contentDict = contentForDict[@"userinfo"];
            [[LYDAOManager sharedInstance].userProfileDAO updateLoginUserBaseProfile:contentDict completeBlock:nil];
        }
        
        if ([allKeys containsObject:@"admin_type"]) {
            
            NSString *adminType = [contentForDict[@"admin_type"] idStringValue];
            [[LYDAOManager sharedInstance].settingDAO saveAdminType:adminType withYardIds:contentForDict[@"admin_yard_id"]];
        }
        
        //首页引导按钮，1显示
        BOOL isGuide = NO;
        if ([allKeys containsObject:@"isGuide"]) {
            isGuide = [contentForDict[@"isGuide"] integerValue];
        }
        USER_SET_B(isGuide, @"HomePageIsGuideShow");

        //全局：1显示价格，0邀约
        BOOL isShow = NO;
        if ([allKeys containsObject:@"is_show_ios"]){
            isShow = [contentForDict[@"is_show_ios"] integerValue];
        }
        //预设值订单页面title,不然后面显示地方要加好多判断逻辑
        if(isShow){
            USER_SET(@"订单",@"ORDER_PRICE_IS_SHOW_TITLE")
        }else{
            USER_SET(@"邀约",@"ORDER_PRICE_IS_SHOW_TITLE")
        }
        USER_SET_B(isShow, @"GLOBAL_PRICE_IS_SHOW");
        
        [[LYDAOManager sharedInstance].settingDAO saveOrderShareInfo:contentForDict[@"orderShare"]];
        
        [LYUserConfInfoDao syncUserCompositionInfoFromContentDictionary:contentForDict];
        
//#if __has_include(<React/RCTRootView.h>)
//        LYRNManager *manager = [LYRNManager defaultManager];
//        if (manager.sharedBridge.valid) {
//            [[LYRNOpenNativeModule sharedInstance] loginLogoutNotifiy:@"2"];
//        }
//#endif
    }
}

+ (void)handleAppResourceCompositionData:(NSDictionary *)response
{
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *contentForDict = response[@"data"];

        [[LYDAOManager sharedInstance].localConfigurationDao saveData:contentForDict forKey: KRN_Cache_Sys_Config_Key];
        
        NSArray *allKeys = [contentForDict allKeys];
        
        if ([allKeys containsObject:@"splash_cfg"]) {
            NSDictionary *contentDict = contentForDict[@"splash_cfg"];
            [[LYDAOManager sharedInstance].settingDAO setSplashOpenFrequencyWithUserInfo:contentDict];
        } else {
            [[LYDAOManager sharedInstance].settingDAO setSplashOpenFrequencyWithUserInfo:nil];
        }
        NSArray *schemaList = contentForDict[@"schema_list"];
        if (schemaList && [schemaList isKindOfClass:[NSArray class]]) {
            [LYDAOManager sharedInstance].settingDAO.urlSchemaBlackList = schemaList;
        } else {
            [LYDAOManager sharedInstance].settingDAO.urlSchemaBlackList = nil;
        }
        
        NSData * rnData = [contentForDict[@"rn_config_list"] dataUsingEncoding:NSUTF8StringEncoding];
        if (rnData) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:rnData options:NSJSONReadingMutableContainers error:nil];
            if (dict) {
                [[LYDAOManager sharedInstance].localConfigurationDao saveRNConfigListDict:dict];
            }
        }
        
        NSData * rnMap = [contentForDict[@"rn_contrast_map"] dataUsingEncoding:NSUTF8StringEncoding];
        if (rnMap) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:rnMap options:NSJSONReadingMutableContainers error:nil];
            if (dict) {
                [[LYDAOManager sharedInstance].localConfigurationDao saveProtocolConfigDict:dict];
            }
        }
        
        //快速回复热键
        [[LYDAOManager sharedInstance].settingDAO saveGodHotKeysDictionaryArray:contentForDict[@"play_reply"]];
        
        if ([allKeys containsObject:@"game_name"]) {
            NSDictionary *contentDict = contentForDict[@"game_name"];
            if (contentDict) {
//                [LYCDNResourcesManager saveConfigData:kConfigCenterImageUrlGameNameIcon data:contentForDict];
            }
        }
        
        if ([allKeys containsObject:@"all_icon"]) {
            NSDictionary *contentDict = contentForDict[@"all_icon"];
            if (contentDict) {
                
//                [LYCDNResourcesManager saveConfig:kConfigCenterImageUrlFiveCheckUpdateIcon data:contentDict];
                
//                [LYCDNResourcesManager saveConfig:kConfigCenterImageUrlFriendListIcon data:contentDict];
                
//                [LYCDNResourcesManager saveConfig:kConfigCenterImageUrlProfileBindlistIcon data:contentDict];
                
//                [LYCDNResourcesManager saveConfig:kConfigCenterImageUrlProfileQueryIcon data:contentDict];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:kSYNCCONFIGURATIONIMAGE object:nil];
            }
        }
        
        if ([allKeys containsObject:@"user_info_game_bg"]) {
            NSArray * userDetailGameBGImagesURLArrays = contentForDict[@"user_info_game_bg"];
            if (userDetailGameBGImagesURLArrays && [userDetailGameBGImagesURLArrays isKindOfClass:[NSArray class]] && [userDetailGameBGImagesURLArrays count]) {
                [[[LYDAOManager sharedInstance] localConfigurationDao] saveUDGameRoleBGImageURLsArray:userDetailGameBGImagesURLArrays];
            }
        }
        
        if ([allKeys containsObject:@"gift_box"]) {
            [[[LYDAOManager sharedInstance] localConfigurationDao] saveData:contentForDict[@"gift_box"] forKey:kBoxGiftShowKey];
        }
        
        if ([allKeys containsObject:@"power_gift"]) {
            [[[LYDAOManager sharedInstance] localConfigurationDao] saveData:contentForDict[@"power_gift"] forKey:kPowerGiftShowKey];
        }
        
        [LYUserConfInfoDao syncAppCompositionInfoFromContentDictionary:contentForDict];
    }
}

+ (void)handlePlayGameCompositionData:(NSDictionary *)response
{
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *contentForDict = response[@"data"];
        
        [[LYDAOManager sharedInstance].localConfigurationDao saveData:contentForDict forKey: KRN_Cache_Game_Sync_Key];

        NSArray *allKeys = [contentForDict allKeys];
        //去掉登录态  游戏数据更新
//        if ([allKeys containsObject:@"games"]) {
//            NSArray *contentDict = contentForDict[@"games"];
//            [LYPlayGameManager setGameArray:contentDict];
//        }
        if ([allKeys containsObject:@"god_status"]) {
            //大神状态
            NSString *godStatus = [contentForDict[@"god_status"] idStringValue];
            [[LYDAOManager sharedInstance].playGameDAO saveGodStatus:godStatus];
            LYGodStatus isGod = ([godStatus intValue] == LYGodStatusPassed || [godStatus intValue] == LYGodStatusFreeze);
            //如果是大神则同步大神信息
//            if (isGod) {
//                [LYPlayGameManager startSyncConfiguration];
//            }
        }
//        if ([allKeys containsObject:@"customer"]) {
//            NSString *customerId = contentForDict[@"customer"];
//            [LYPlayGameManager setPlayGamePayTranslationUserId:customerId];
//        }
//        if([allKeys containsObject:@"order_gifts"])
//        {
//            NSArray *contentDict = contentForDict[@"order_gifts"];
//            [LYPlayGameManager setOrderGiftsArray:contentDict];
//        }
    }
}


+ (void)handleVisitorPlayGameCompositionData:(NSDictionary *)response
{
    if (response && [response isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary *contentForDict = response[@"data"];
        NSArray *allKeys = [contentForDict allKeys];
//        if ([allKeys containsObject:@"games"]) {
//            NSArray *contentDict = contentForDict[@"games"];
//            [LYPlayGameManager setGameArray:contentDict];
//        }
//        if ([allKeys containsObject:@"customer"]) {
//            NSString *customerId = contentForDict[@"customer"];
//            [LYPlayGameManager setPlayGamePayTranslationUserId:customerId];
//        }
    }
}

+ (void)handlePlayGameNewCouponsListCompositionData:(NSDictionary *)response
{
//    if (response && [response isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *contentForDict = response[@"data"];
//        NSArray *allKeys = [contentForDict allKeys];
//        if ([allKeys containsObject:@"coupons"]) {
//            NSArray *contentDict = contentForDict[@"coupons"];
//            NSTimeInterval timeInterval = [LYSplashScreenManager sharedSplashScreenManager].timeInterval;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                BOOL isLogin = [LYUserConfInfoDao isExistLoginUser];
//                if (isLogin) {
//                    LYCouponsListPopupView *popup = [LYCouponsListPopupView alloc];
//                    [[popup initWithDataArray:contentDict] showWithBlock:^(MMPopupView *guide) {
//                        [MMPopupWindow sharedWindow].touchWildToHide = YES;
//                    }];
//                }
//            });
//            
//        }
//    }
}


@end
