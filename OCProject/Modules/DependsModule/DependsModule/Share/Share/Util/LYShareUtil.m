//
//  LYShareUtil.m
//  laoyuegou
//
//  Created by zwq on 2018/10/8.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import "LYShareUtil.h"
//#import "WXApi.h"
#import "LYQQPlatformManager.h"
#import "LYSinaPlatformManager.h"
#import "EnvironmentConst.h"
#import "LYWXPlatformManager.h"

@implementation LYShareUtil

static LYShareUtil * _sharedInstance;
+ (LYShareUtil *)sharedInstance{
    if (!_sharedInstance) {
        _sharedInstance = [[LYShareUtil alloc] init];
    }
    return _sharedInstance;
}

+ (void)registerShareSdks{
    [[LYShareUtil sharedInstance] registerShareSdks];
}

- (void)registerShareSdks{
    //初始化微信支付功能
    [LYWXPlatformManager registerAppWithWeChat];
    [LYQQPlatformManager registerAppWithQQ];
    [LYSinaPlatformManager registerAppWithSinaWeiBo];
}

+ (void)shareToLYGFriend:(LYShareConfig *) obj{
}

+ (void)shareToWXCircle:(LYShareConfig *) obj{
    NSString *title = obj.title;
    NSString *content = obj.content;
    NSURL *url = [NSURL URLWithString:obj.url];
    NSString *imageUrl = obj.imageUrl;
    
    if(obj.largeImage != nil){
        [LYWXPlatformManager lySetupWeChatParamsByText:content title:title url:nil thumbImage:obj.large_smallImage image:obj.largeImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:LYGContentTypeImage forPlatformSubType:LYGPlatformSubTypeWechatTimeline];
    }
    else if (obj.large.length > 0)
    {
        //执行这部是为了处理分享的时候，是否需要执行JS分享回调，目前认为只要点击第三方分享就处理为分享成功回调
//        [self didShareStateChangedWithShareType:platformType responseState:SSDKResponseStateBegin error:nil];
        
        [LYWXPlatformManager lySetupWeChatParamsByText:content title:title url:url thumbImage:obj.large_small image:obj.large musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:LYGContentTypeImage forPlatformSubType:LYGPlatformSubTypeWechatTimeline];
        return;
    }
    
    if ([obj.shareStyle isEqualToString:@"A"])
    {
        //执行这部是为了处理分享的时候，是否需要执行JS分享回调，目前认为只要点击第三方分享就处理为分享成功回调
//        [self didShareStateChangedWithShareType:platformType responseState:SSDKResponseStateBegin error:nil];
        [LYWXPlatformManager lySetupWeChatParamsByText:nil title:title url:url thumbImage:nil image:imageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:LYGContentTypeWebPage forPlatformSubType:LYGPlatformSubTypeWechatTimeline];
        return;
    }
}

+ (void)shareToWXFriend:(LYShareConfig *) obj{
    
    NSString *title = obj.title;
    NSString *content = obj.content;
    NSURL *url = [NSURL URLWithString:obj.url];
    NSString *imageUrl = obj.imageUrl;

    if(obj.largeImage != nil){
        [LYWXPlatformManager lySetupWeChatParamsByText:content title:title url:nil thumbImage:obj.large_smallImage image:obj.largeImage musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:LYGContentTypeImage forPlatformSubType:LYGPlatformSubTypeWechatSession];
    }
    else if (obj.large.length >0) {
        [LYWXPlatformManager lySetupWeChatParamsByText:content title:title url:url thumbImage:obj.large_small image:obj.large musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:LYGContentTypeImage forPlatformSubType:LYGPlatformSubTypeWechatSession];
        
        //执行这部是为了处理分享的时候，是否需要执行JS分享回调，目前认为只要点击第三方分享就处理为分享成功回调
//        [self didShareStateChangedWithShareType:type responseState:SSDKResponseStateBegin error:nil];
        return;
    }
    else if ([obj.shareStyle isEqualToString:@"A"])
    {
        [LYWXPlatformManager lySetupWeChatParamsByText:content title:title url:url thumbImage:nil image:imageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:LYGContentTypeWebPage forPlatformSubType:LYGPlatformSubTypeWechatSession];
    }
    else if ([obj.shareStyle isEqualToString:@"B"])
    {
        [LYWXPlatformManager lySetupWeChatParamsByText:nil title:title url:url thumbImage:nil image:imageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:LYGContentTypeWebPage forPlatformSubType:LYGPlatformSubTypeWechatSession];
    }
    else
    {
        [LYWXPlatformManager lySetupWeChatParamsByText:content title:nil url:url thumbImage:nil image:imageUrl musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:LYGContentTypeWebPage forPlatformSubType:LYGPlatformSubTypeWechatSession];
    }
}

+ (void)shareToSina:(LYShareConfig *) obj{
    NSString *title = obj.title;
    NSString *content = obj.content;
    NSString *imageUrl = obj.imageUrl;
    if(obj.largeImage != nil){
        [LYSinaPlatformManager lySetupSinaWeiboShareParamsByText:content
                                                           title:title
                                                           image:obj.largeImage
                                                             url:nil
                                                        latitude:0
                                                       longitude:0
                                                        objectID:nil
                                                            type:LYShareContentTypeImage];
        BOOL isInstallClient = [LYSinaPlatformManager isWeiboAppInstalled];
        if (isInstallClient) {
            [LYSinaPlatformManager openWeiboApp];
        } else {
            NSLog(@"没有安装微博");
            return;
        }
    }
    else if (obj.large.length >0) {
        //执行这部是为了处理分享的时候，是否需要执行JS分享回调，目前认为只要点击第三方分享就处理为分享成功回调
        //        [self didShareStateChangedWithShareType:type responseState:SSDKResponseStateBegin error:nil];
        [LYSinaPlatformManager lySetupSinaWeiboShareParamsByText:content
                                                           title:title
                                                           image:obj.large
                                                             url:nil
                                                        latitude:0
                                                       longitude:0
                                                        objectID:nil
                                                            type:LYShareContentTypeImage];
        BOOL isInstallClient = [LYSinaPlatformManager isWeiboAppInstalled];
        if (isInstallClient) {
            [LYSinaPlatformManager openWeiboApp];
        } else {
            NSLog(@"没有安装微博");
            return;
        }
        return;
    }
    else
    {
        NSString *contentString = [NSString stringWithFormat:@"%@ %@",content,obj.url?:@""];
        if ([obj.shareStyle isEqualToString:@"A"]) {
            contentString = [NSString stringWithFormat:@"%@ %@",title,obj.url?:@""];
        }
        [LYSinaPlatformManager lySetupSinaWeiboShareParamsByText:contentString
                                                           title:nil
                                                           image:imageUrl
                                                             url:nil
                                                        latitude:0
                                                       longitude:0
                                                        objectID:nil
                                                            type:LYShareContentTypeImage];
        BOOL isInstallClient = [LYSinaPlatformManager isWeiboAppInstalled];
        
        //执行这部是为了处理分享的时候，是否需要执行JS分享回调，目前认为只要点击第三方分享就处理为分享成功回调
//        [self didShareStateChangedWithShareType:platformType responseState:SSDKResponseStateBegin error:nil];
        if (isInstallClient) {
            [LYSinaPlatformManager openWeiboApp];
        } else {
            NSLog(@"没安装微博");
        }
    }
    
    BOOL isInstallClient = [LYSinaPlatformManager isWeiboAppInstalled];
    if (isInstallClient) {
        [LYSinaPlatformManager openWeiboApp];
    } else {
        NSLog(@"没有安装微博");
    }
}

+ (void)shareToQQFriend:(LYShareConfig *) obj{
    
    NSString *title = obj.title? obj.title : @" ";
    NSString *content = obj.content ? obj.content : @"";
    NSURL *url = obj.url?[NSURL URLWithString:obj.url]:nil;
    NSString *imageUrl = obj.imageUrl ? obj.imageUrl : @"";
    if(obj.largeImage != nil){
        [LYQQPlatformManager lySetupQQParamsByText:content title:title url:url image:obj.largeImage thumbImage:obj.large_smallImage type:LYGContentTypeImage forPlatformSubType:LYGPlatformSubTypeQQFriend];
    }
    else if (obj.large.length >0) {
        [LYQQPlatformManager lySetupQQParamsByText:content title:title url:url image:obj.large thumbImage:obj.large_small type:LYGContentTypeImage forPlatformSubType:LYGPlatformSubTypeQQFriend];

        return;
    }
    else if ([obj.shareStyle isEqualToString:@"C"])
    {
        [LYQQPlatformManager lySetupQQParamsByText:content title:@" " url:url image:imageUrl thumbImage:nil type:LYGContentTypeWebPage forPlatformSubType:LYGPlatformSubTypeQQFriend];

    }
    else if ([obj.shareStyle isEqualToString:@"B"])
    {
        [LYQQPlatformManager lySetupQQParamsByText:nil title:title url:url image:imageUrl thumbImage:nil type:LYGContentTypeWebPage forPlatformSubType:LYGPlatformSubTypeQQFriend];

    }
    else
    {
        [LYQQPlatformManager lySetupQQParamsByText:content title:title url:url image:imageUrl thumbImage:nil type:LYGContentTypeWebPage forPlatformSubType:LYGPlatformSubTypeQQFriend];
    }
}

+ (void)shareToQQZone:(LYShareConfig *) obj{
    NSString *title = obj.title? obj.title : @"";
    NSString *content = obj.content ? obj.content : @"";
    NSURL *url = obj.url?[NSURL URLWithString:obj.url]:nil;
    NSString *imageUrl = obj.imageUrl ? obj.imageUrl : @"";
    
    if(obj.largeImage != nil){
        [LYQQPlatformManager lySetupQQParamsByText:content title:title url:url image:obj.largeImage thumbImage:obj.large_smallImage type:LYGContentTypeImage forPlatformSubType:LYGPlatformSubTypeQZone];
    }
    else if (obj.large.length >0) {
        [LYQQPlatformManager lySetupQQParamsByText:content title:title url:url image:obj.large thumbImage:obj.large_small type:LYGContentTypeImage forPlatformSubType:LYGPlatformSubTypeQZone];
        
        return;
    }
    else
    {
        if (![title length]) {
            title = content;
            content = @"";
        }
        [LYQQPlatformManager lySetupQQParamsByText:content title:title url:url image:imageUrl thumbImage:nil type:LYGContentTypeWebPage forPlatformSubType:LYGPlatformSubTypeQZone];
    }
}

+ (void)shareToCopyLink:(LYShareConfig *) obj{
    
}

+ (void) shareToPlatform:(LYGSharePlatform) platform withObj:(LYShareConfig *) obj{
    switch (platform) {
        case LYGSharePlatformLYG:
            [LYShareUtil shareToLYGFriend:obj];
            break;
        case LYGSharePlatformWeiXinCircle:
            [LYShareUtil shareToWXCircle:obj];
            break;
        case LYGSharePlatformWeiXinFriend:
            [LYShareUtil shareToWXFriend:obj];
            break;
        case LYGSharePlatformSina:
            [LYShareUtil shareToSina:obj];
            break;
        case LYGSharePlatformQQ:
            [LYShareUtil shareToQQFriend:obj];
            break;
        case LYGSharePlatformQQZone:
            [LYShareUtil shareToQQZone:obj];
            break;
        case LYGSharePlatformCopyLink:
            [LYShareUtil shareToCopyLink:obj];
            break;
        default:
            break;
    }
}

+ (BOOL) hasInstallPlatform:(LYGSharePlatform) platform{
    switch (platform) {
        case LYGSharePlatformLYG:
            return YES;
            break;
        case LYGSharePlatformWeiXinCircle:
        case LYGSharePlatformWeiXinFriend:{
            return [LYWXPlatformManager isInstalled];
        }
            break;
        case LYGSharePlatformSina:
            return [LYSinaPlatformManager isWeiboAppInstalled];
            break;
        case LYGSharePlatformQQ:
        case LYGSharePlatformQQZone:{
            if ([LYQQPlatformManager isInstalled]) {
                return YES;
            }else{
                return NO;
            }
        }
            break;
        case LYGSharePlatformCopyLink:
        case LYGSharePlatformSavePic:
            return YES;
            break;
        default:
            break;
    }
    return NO;
}

@end
