//
//  UIViewController+EHShare.h
//  EHealth
//
//  Created by smalljun on 15/5/3.
//  Copyright (c) 2015年 laoyuegou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYShare.h"
#import "LYShareConfig.h"

/**
 *  扩展的自定义分享界面item，添加的点击事件
 */
typedef NS_ENUM(NSInteger, LYShareClickHandlerType){
    /**
     *  内部好友
     */
    kLYShareClickHandlerTypeInnerFriends,
    kLYShareClickHandlerTypeInnerTimeLine,
};

typedef NS_ENUM(NSInteger, LYSharePlatform) {
    LYSharePlatformAll = 0,
    LYSharePlatformWeixiTimeline = 1,        /**< 微信朋友圈 */
    LYSharePlatformWeixiSession = 2,         /**< 微信好友 */
    LYSharePlatformSinaWeibo = 3,
    LYSharePlatformQQ = 4,
    LYSharePlatformQZone = 5,
};

@interface UIViewController (EHShare)

@property (nonatomic,copy) NSString *shareWebType;

- (void)showShareWithUrlScheme:(NSString *)urlSchemeAction withShare:(LYShare *)share;
- (NSDictionary *)shareUrlSchemeAction:(NSString *)urlSchemeAction;

- (void)shareToSinglePlatformWithShareType:(LYGPlatformType)type withShareConfig:(LYShareConfig *)shareConfig;


-(void)showShareImageWithShare:(LYShare *)share;

-(void)showAudioCallShareImageWithShare:(LYShare *)share;

@end
