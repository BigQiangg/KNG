
//
//  LYShareDefine.h
//  laoyuegou
//
//  Created by zwq on 2018/10/9.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#ifndef LYShareDefine_h
#define LYShareDefine_h


//账号配置相关
//账号配置相关
#define KGSinaWeibo_App_Key @"2569657981"
#define KGSinaWeibo_App_Secret @"6a697ef8617c7721cc91f54ee09b3dee"

#define KGQQ_App_Key @"101137147"
#define KGQQ_App_Secret @"0e06e671ca5598b30dbd51893d62b5e2"

//这个不用了
//HaiNanLexin 微信开发者id
#define HaiNan_WeiXin_App_Key @"wxe6e851e996ce64b9"
#define HaiNan_WeiXin_App_Secret @"6410e77c9613c770bb0e84340e72bd29"

//这个微信登陆分享
//上海竟跃 微信开发者id
#define JinYue_WeiXin_App_Key         @"wx27281e55f5191a85"               //APPID
#define JinYue_WeiXin_App_Secret      @"2d9f7882c26567cee1254f66248a2a2a" //appsecret

//这个微信支付专用
//海南捞月狗 微信开发者id
#define HaiNan_LYG_WeiXin_App_Key         @"wx8282dc353eefde2e"               //APPID
#define HaiNan_LYG_WeiXin_App_Secret      @"1a1adf5d85bf099b6070b5d99071bcd5" //appsecret

/**
 *  内容类型
 */
typedef NS_ENUM(NSUInteger, LYGContentType){
    
    /**
     *  自动适配类型，视传入的参数来决定
     */
    LYGContentTypeAuto         = 0,
    
    /**
     *  文本
     */
    LYGContentTypeText         = 1,
    
    /**
     *  图片
     */
    LYGContentTypeImage        = 2,
    
    /**
     *  网页
     */
    LYGContentTypeWebPage      = 3,
    
    /**
     *  应用
     */
    LYGContentTypeApp          = 4,
    
    /**
     *  音频
     */
    LYGContentTypeAudio        = 5,
    
    /**
     *  视频
     */
    LYGContentTypeVideo        = 6,
    
    /**
     *  文件类型(暂时仅微信可用)
     */
    LYGContentTypeFile         = 7
    
};

/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, LYGPlatformType){
    /**
     *  未知
     */
    LYGPlatformTypeUnknown             = 0,
    /**
     *  新浪微博
     */
    LYGPlatformTypeSinaWeibo           = 1,
    /**
     *  QQ空间
     */
    LYGPlatformSubTypeQZone            = 6,
    
    /**
     *  Facebook
     */
    LYGPlatformTypeFacebook            = 10,
    /**
     *  Twitter
     */
    LYGPlatformTypeTwitter             = 11,
    /**
     *  拷贝
     */
    LYGPlatformTypeCopy                = 21,
    /**
     *  微信好友
     */
    LYGPlatformSubTypeWechatSession    = 22,
    /**
     *  微信朋友圈
     */
    LYGPlatformSubTypeWechatTimeline   = 23,
    /**
     *  QQ好友
     */
    LYGPlatformSubTypeQQFriend         = 24,
    /**
     *  微信收藏
     */
    LYGPlatformSubTypeWechatFav        = 37,
    /**
     *  Facebook Messenger
     */
    LYGPlatformTypeFacebookMessenger   = 46,
    /**
     *  微信平台,
     */
    LYGPlatformTypeWechat              = 997,
    /**
     *  QQ平台
     */
    LYGPlatformTypeQQ                  = 998,
    /**
     *  任意平台
     */
    LYGPlatformTypeAny                 = 999
};


typedef NS_ENUM(NSInteger,LYGSharePlatform) {
    LYGSharePlatformLYG,
    LYGSharePlatformWeiXinCircle,
    LYGSharePlatformWeiXinFriend,
    LYGSharePlatformSina,
    LYGSharePlatformQQ,
    LYGSharePlatformQQZone,
    LYGSharePlatformCopyLink,
    LYGSharePlatformSavePic,
};

typedef NS_ENUM(NSInteger,LYGShareOption) {
    LYGShareOption_JuBao,
    LYGShareOption_LaHei,
};

typedef void(^ShareBlock)(NSInteger platform);
typedef void(^ShareOptBlock)(NSInteger option, BOOL optType);

#endif /* LYShareDefine_h */
