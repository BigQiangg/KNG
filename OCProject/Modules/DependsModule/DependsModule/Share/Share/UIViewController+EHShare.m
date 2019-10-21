
//
//  UIViewController+EHShare.m
//  EHealth
//
//  Created by smalljun on 15/5/3.
//  Copyright (c) 2015年 laoyuegou. All rights reserved.
//

#import "UIViewController+EHShare.h"
#import "LYSelectShareWayController.h"
#import "LYForumDetailViewController.h"

#import <objc/runtime.h>
#import "NSString+LYVerify.h"
#import "LYShareChatIssueHelper.h"
#import "LYWebViewController.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "LYPlayerViewController.h"
#import "SJPickPhotoManager.h"

#import "LYSinaPlatformManager.h"
#import "NSString+MD5.h"
#import "LYSharePlatformView.h"
#import "LYShareUtil.h"


#import "IMChatSendHelper.h"
#import "IMChatMsgItem.h"
#import "LYBaseViewController.h"
#import "ChatGroupItem.h"
#import "IMChatExtension.h"

/*
 
 分享style的对应表如下：
 
 朋友圈 ：
 Image1 + title + url                           A
 
 微信好友：
 Image1 + title + content   + url               A
 
 Image1 + title  + url                          B
 
 Image1 + content + url（title处无留白）          C
 
 微博 ：
 Image2 + title + url                           A
 
 Image2 + content +url                          B
 
 QQ好友 ：
 Image1 + title + content  + url                A
 
 Image1 + title + url                           B
 
 Image1 + content + url（title处无留白）          C
 
 QQ空间 ：
 Image1 + title +content  + url                 A
 
 */

static char keyShareType;
@implementation UIViewController (EHShare)

- (LYGPlatformType)platformTransformShareType:(NSString *)platform
{
    LYGPlatformType type = LYGPlatformTypeSinaWeibo;
    switch ([platform integerValue]) {
        case LYSharePlatformAll:
            type = LYGPlatformTypeAny;
            break;
        case LYSharePlatformWeixiTimeline:
            type = LYGPlatformSubTypeWechatTimeline;
            break;
        case LYSharePlatformWeixiSession:
            type = LYGPlatformSubTypeWechatSession;
            break;
        case LYSharePlatformSinaWeibo:
            type = LYGPlatformTypeSinaWeibo;
            break;
        case LYSharePlatformQQ:
            type = LYGPlatformSubTypeQQFriend;
            break;
        case LYSharePlatformQZone:
            type = LYGPlatformSubTypeQZone;
            break;
        default:
            break;
    }
    return type;
}

- (NSDictionary *)allShareISSContent:(NSArray *)params
{
    NSMutableDictionary *dictStype = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    NSString *title = [NSString stringFilterArray:params withKeyWord:LY_SHARE_TITLE_PREFIX]?:@"";
    NSString *shareUrl = [NSString stringFilterArray:params withKeyWord:LY_SHARE_URL_PREFIX]?:@"";
    NSString *shareContent = [NSString stringFilterArray:params withKeyWord:LY_SHARE_CONTENT_PREFIX]?:@"";
    NSString *imageUrl = [NSString stringFilterArray:params withKeyWord:LY_SHARE_IMAGE_URL_PREFIX]?:@"";
    NSString *imageUrlSina = [NSString stringFilterArray:params withKeyWord:LY_SHARE_IMAGE_SINA_URL_PREFIX]?:@"";
    NSString *large = [NSString stringFilterArray:params withKeyWord:LY_SHARE_LARGE_PREFIX]?:@"";
    NSString *large_small = [NSString stringFilterArray:params withKeyWord:LY_SHARE_LARGE_SMALL_PREFIX]?:@"";
    
    NSDictionary *shareDict = @{
                                @"title" : title,
                                @"shareUrl" : shareUrl,
                                @"shareContent" : shareContent,
                                @"imageUrl" : imageUrl,
                                @"imageUrlSina" : imageUrlSina,
                                @"large" : large,
                                @"large_small" : large_small
                                };
    
    NSString *typeStyle = [NSString stringFilterArray:params withKeyWord:LY_SHARE_TYPE_PREFIX]?:@"-1";
    self.shareWebType = typeStyle;
    
    //qq, qzone, wechat, moments, sina, chat
    LYShareConfig *shareConfigQQ = [LYShareConfig shareConfigWithDict:shareDict withParams:params withSuffix:@"qq" withStylePrefix:LY_SHARE_QQ_STYLE_PREFIX];
    LYShareConfig *shareConfigQzone = [LYShareConfig shareConfigWithDict:shareDict withParams:params withSuffix:@"qzone" withStylePrefix:LY_SHARE_QZone_STYLE_PREFIX];
    LYShareConfig *shareConfigWechat = [LYShareConfig shareConfigWithDict:shareDict withParams:params withSuffix:@"wechat" withStylePrefix:LY_SHARE_Wechat_STYLE_PREFIX];
    LYShareConfig *shareConfigWeixinTimeline= [LYShareConfig shareConfigWithDict:shareDict withParams:params withSuffix:@"moments" withStylePrefix:LY_SHARE_WeiXinTimeLine_STYLE_PREFIX];
    LYShareConfig *shareConfigSina = [LYShareConfig shareConfigWithDict:shareDict withParams:params withSuffix:@"sina" withStylePrefix:LY_SHARE_WeiBo_STYLE_PREFIX];
    LYShareConfig *shareConfigFriend = [LYShareConfig shareConfigWithDict:shareDict withParams:params withSuffix:@"chat" withStylePrefix:nil];
    
    LYShareConfig *shareConfigDefaultShare = [LYShareConfig shareConfigWithDict:shareDict withParams:params withSuffix:@"defaultShare" withStylePrefix:nil];
    
    dictStype[LY_SHARE_QQ_STYLE_PREFIX] = shareConfigQQ;
    dictStype[LY_SHARE_QZone_STYLE_PREFIX] = shareConfigQzone;
    dictStype[LY_SHARE_WeiBo_STYLE_PREFIX] = shareConfigSina;
    dictStype[LY_SHARE_Wechat_STYLE_PREFIX] = shareConfigWechat;
    dictStype[LY_SHARE_WeiXinTimeLine_STYLE_PREFIX] = shareConfigWeixinTimeline;
    dictStype[LY_SHARE_Friend_STYLE_PREFIX] = shareConfigFriend;
    dictStype[LY_SHARE_DEFAULT_SHARE_STYLE_PREFIX] = shareConfigDefaultShare;
    
    NSString *customURL = [NSString stringFilterArray:params withKeyWord:LY_SHARE_CUSTOM_URL_PREFIX]?:@"";
    NSString *customTitle = [NSString stringFilterArray:params withKeyWord:LY_SHARE_CUSTOM_TITLE_PREFIX]?:@"";
    if ([customURL length] && [customTitle length]) {
        NSMutableDictionary *dictCustom = [NSMutableDictionary dictionary];
        dictCustom[LY_SHARE_CUSTOM_URL_PREFIX] = customURL;
        dictCustom[LY_SHARE_CUSTOM_TITLE_PREFIX] = customTitle;
        NSString *customLogo = [NSString stringFilterArray:params withKeyWord:LY_SHARE_CUSTOM_URL_PREFIX]?:@"";
        dictCustom[LY_SHARE_CUSTOM_LOGO_PREFIX] = customLogo;
        dictStype[LY_SHARE_CUSTOM_URL_PREFIX] = dictCustom;
    }
    
    return dictStype;
}
-(void)showShareImageWithShare:(LYShare *)share{
        NSMutableDictionary *dictExten = nil;
        if (share) {
            dictExten = [NSMutableDictionary dictionary];
            share.title = share.title ?:@"";
            share.content = share.content ?:@"";
            share.ext = share.ext ?:@"";
            share.picUrl = share.picUrl ?:@"";
            dictExten[@"shareFriend"] = [share copy];
        }
    self.extensionInfo = dictExten;

    [self shareImageWithShare:share];
}


-(void)showAudioCallShareImageWithShare:(LYShare *)share{
    NSMutableDictionary *dictExten = nil;
    if (share) {
        dictExten = [NSMutableDictionary dictionary];
        share.title = share.title ?:@"";
        share.content = share.content ?:@"";
        share.ext = share.ext ?:@"";
        share.picUrl = share.picUrl ?:@"";
        dictExten[@"shareFriend"] = [share copy];
    }
    self.extensionInfo = dictExten;
    
    [self shareImageAudioCallWithShare:share];
}

static NSString * shareType = @"";
static NSString * shareID = @"";
- (void)showShareWithUrlScheme:(NSString *)urlSchemeAction withShare:(LYShare *)share
{
    shareType = share.shareFor;
    NSDictionary *shareContent = [self shareUrlSchemeAction:urlSchemeAction];
    NSDictionary *dictStyle = shareContent[@"dictStype"];
    if (shareContent) {
        NSMutableDictionary *dictExten = nil;
        if (share) {
            dictExten = [NSMutableDictionary dictionary];
            dictExten[@"shareContent"] = shareContent;
            dictExten[@"jsValue"] = shareContent[@"jsValue"];

            LYShareConfig *shareConfigFriend = dictStyle[LY_SHARE_Friend_STYLE_PREFIX];

            if (shareConfigFriend) {
                LYShare *friendShare = [share copy];
                friendShare.title = shareConfigFriend.title;
                [friendShare replaceContent:shareConfigFriend.content];
                friendShare.shareUrl = shareConfigFriend.url;
                friendShare.picUrl = shareConfigFriend.imageUrl;
                dictExten[@"shareFriend"] = friendShare;
            }
        }
        self.extensionInfo = dictExten;
        [self shareWithShareType:[shareContent[@"shareType"] intValue] withDictStyle:dictStyle optionBlock:share.optBlock optionDic:share.optDic];
    }
}

- (void)shareToSinglePlatformWithShareType:(LYGPlatformType)type withShareConfig:(LYShareConfig *)shareConfig{
    shareType = @"内容";
    switch (type) {
        case LYGPlatformTypeSinaWeibo:
        {
            shareWay = @"微博";
            [LYShareUtil shareToPlatform:LYGSharePlatformSina withObj:shareConfig];
        }
            break;
        case LYGPlatformSubTypeQZone:
        {
            shareWay = @"qq空间";
            [LYShareUtil shareToPlatform:LYGSharePlatformQQZone withObj:shareConfig];
        }
            break;
        case LYGPlatformSubTypeQQFriend:
        {
            shareWay = @"QQ";
            [LYShareUtil shareToPlatform:LYGSharePlatformQQ withObj:shareConfig];
        }
            break;
        case LYGPlatformSubTypeWechatTimeline:
        {
            shareWay = @"微信朋友圈";
            [LYShareUtil shareToPlatform:LYGSharePlatformWeiXinCircle withObj:shareConfig];
        }
            break;
        case LYGPlatformSubTypeWechatSession:
        {
            shareWay = @"微信好友";
            [LYShareUtil shareToPlatform:LYGSharePlatformWeiXinFriend withObj:shareConfig];
        }
            break;
        default:
            break;
    }
    [LYAnalyticsManager event:LYSENSORS_EVENT_SHARE
               withProperties:@{@"shareTitle":SAFE_STRING(shareConfig.title),
                                @"sharetype":mAvailableString(shareType),
                                @"shareway":mAvailableString(shareWay),
//                                @"shareID":@"",
                                }];
}

#pragma mark - 分享功能实现
- (void)share:(LYShareConfig *) share toPlatform:(LYGSharePlatform) platform{
    NSString * shareTitle = share.title;
    BOOL shouldAddSenser = YES;
    //神策埋点
    switch (platform) {
        case LYGSharePlatformWeiXinCircle:
        {
            shareWay = @"微信朋友圈";
        }
            break;
        case LYGSharePlatformWeiXinFriend:
        {
            shareWay = @"微信好友";
        }
            break;
        case LYGSharePlatformSina:
        {
            shareWay = @"微博";
        }
            break;
        case LYGSharePlatformQQ:
        {
            shareWay = @"QQ";
        }
            break;
        case LYGSharePlatformQQZone:
        {
            shareWay = @"qq空间";
        }
            break;
        case LYGSharePlatformCopyLink:
        {
            shareWay = @"复制链接";
            shouldAddSenser = NO;
        }
            break;
        case LYGSharePlatformSavePic:{
            shareWay = @"保存图片到相册";
        }
            break;
        case LYGSharePlatformLYG:{
            shareWay = @"好友";
            if(!LY_CHECK_STRING(shareTitle)){
                LYShareConfig * sharee = self.extensionInfo[@"shareFriend"];
                shareTitle = sharee.title;
            }
        }
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LYNotifitionShareChoosed" object:@(platform)];
    
    //复制链接不埋点
    if (shouldAddSenser) {
        [LYAnalyticsManager event:LYSENSORS_EVENT_SHARE
                   withProperties:@{
                                    @"shareTitle":SAFE_STRING(shareTitle),
                                    @"sharetype":mAvailableString(shareType),
                                    @"shareway":mAvailableString(shareWay),
                                    @"shareID":mAvailableString(shareID),
                                    }];
    }
    

    if (platform == LYGSharePlatformLYG) {
        //捞月狗好友
        [self selectChatIssueSection];
    } else if(platform == LYGSharePlatformCopyLink){
        //拷贝链接
        [self shareCopy:share.url];
    } else if(platform == LYGSharePlatformSavePic){
        //保存图片到相册
        [self savePhoto:share.largeImage];
    } else{
        //分享到其他平台
        [LYShareUtil shareToPlatform:platform withObj:share];
    }
}

- (void)showShareWithUrlScheme:(NSString *)urlSchemeAction
{
    [self showShareWithUrlScheme:urlSchemeAction withShare:nil];
}

//分享Scheme处理
- (NSDictionary *)shareUrlSchemeAction:(NSString *)urlSchemeAction
{
    NSDictionary *dictContent = nil;
    if ([urlSchemeAction rangeOfString:LY_SHARE_URL_SCHEME_CUSTOM].location != NSNotFound ||
        [urlSchemeAction rangeOfString:LY_SHOW_SHARE_URL_SCHEME_CUSTOM].location != NSNotFound)
    {
        NSString *urlScheme = [NSString stringByUnescapingFromURLArgument:urlSchemeAction];
        
        NSArray *array = nil;
        if ([urlSchemeAction rangeOfString:LY_SHOW_SHARE_URL_SCHEME_CUSTOM].location != NSNotFound) {
            array = [urlScheme componentsSeparatedByString:LY_SHOW_SHARE_URL_SCHEME_CUSTOM];
        } else {
            array = [urlScheme componentsSeparatedByString:LY_SHARE_URL_SCHEME_CUSTOM];
        }
        
        if ([array count] > 0) {
            NSString *paramString = [array objectAtIndex:1];
            
            //&&作为参数之间的分隔符
            NSArray *params = [paramString componentsSeparatedByString:@"&&"];
            NSString *platform = [NSString stringFilterArray:params withKeyWord:LY_SHARE_PLATFORM_PREFIX];
            
            if ([platform length] > 0) {
                
                LYGPlatformType type = [self platformTransformShareType:platform];
                
                NSString *imageUrl = [NSString stringFilterArray:params withKeyWord:LY_SHARE_IMAGE_URL_PREFIX];
                NSString *imageUrlSina = [NSString stringFilterArray:params withKeyWord:LY_SHARE_IMAGE_SINA_URL_PREFIX];
                
                NSDictionary *dictStype = [self allShareISSContent:params];
                NSString *jsValue = [NSString stringFilterArray:params withKeyWord:LY_SHARE_JS_PARAM_PREFIX];
                
                NSString *large = [NSString stringFilterArray:params withKeyWord:LY_SHARE_LARGE_PREFIX];
                NSString *largeSmall = [NSString stringFilterArray:params withKeyWord:LY_SHARE_LARGE_SMALL_PREFIX];
                
                NSString *filePath = [NSString stringFilterArray:params withKeyWord:LY_SHARE_LARGE_FILE_PATH];
                
                LYShareConfig *shareConfigDefault = dictStype[LY_SHARE_DEFAULT_SHARE_STYLE_PREFIX];
                LYShare *share = [[LYShare alloc] init];
                share.title = shareConfigDefault.title?:@"";
                share.picUrl = imageUrl?:@"";
                share.content = shareConfigDefault.content?:@"";
                share.shareUrl = shareConfigDefault.url?:@"";
                share.sinaPicUrl = imageUrlSina?:@"";
                share.platform = platform?:@"";
                share.shareType = self.shareWebType?:@"";
                share.large = large?:@"";
                share.large_small = largeSmall?:@"";
                
                share.filePath = filePath ?:@""; // 
                
                dictContent = @{
                                @"shareType" : @(type),
                                @"dictStype" : dictStype,
                                @"shareModel" : share,
                                @"jsValue" : jsValue?:@"",
                                };
            }
        }
    }
    return dictContent;
}

-(void)shareImageWithShare:(LYShare *)share{
    shareType = @"截屏";
    if(LY_CHECK_STRING(share.shareFor)){
        shareType = share.shareFor;
    }
    WeakSelf(weakSelf);
    //选择分享平台
    LYShareConfig * config = [[LYShareConfig alloc] init];
    config.title = share.title ?:@"";
    config.content = share.content ?:@"" ;
    config.large_smallImage = share.smallShareImage;
    config.largeImage = [share.largeShareImage copy];
    
    
    NSMutableArray * platformArray = [NSMutableArray arrayWithArray:@[
                                                                      @(LYGSharePlatformLYG),
                                                                      @(LYGSharePlatformWeiXinFriend),
                                                                      @(LYGSharePlatformWeiXinCircle),
                                                                      @(LYGSharePlatformQQ),
                                                                      @(LYGSharePlatformQQZone),
                                                                      @(LYGSharePlatformSina),]];
    
    if((share.type.integerValue != kLYTimeLineShareTypeScreenShot)){
        
        if (share.type.integerValue == kLYTimeLineShareTypeLOL) {
            if (share.smallShareImage) { // LOL 类型,有图就显示
                [platformArray addObject:@(LYGSharePlatformSavePic)];
            }
        } else {
            [platformArray addObject:@(LYGSharePlatformSavePic)];
        }
    }
    
    [[LYSharePlatformView setPlatform:platformArray
                               finish:^(NSInteger platform) {
                                   [weakSelf share:config toPlatform:platform];
                               }] show];
}



-(void)shareImageAudioCallWithShare:(LYShare *)share{
    shareType = @"截屏";
    if(LY_CHECK_STRING(share.shareFor)){
        shareType = share.shareFor;
    }
    
    if(LY_CHECK_STRING(share.shareID)){
        shareID = share.shareID;
    }
    
    WeakSelf(weakSelf);
    //选择分享平台
    LYShareConfig * config = [[LYShareConfig alloc] init];
    config.title = share.title ?:@"";
    config.content = share.content ?:@"" ;
    config.large_smallImage = share.smallShareImage;
    config.largeImage = [share.largeShareImage copy];
    
    
    NSMutableArray * platformArray = [NSMutableArray arrayWithArray:@[
                                                                      @(LYGSharePlatformWeiXinFriend),
                                                                      @(LYGSharePlatformWeiXinCircle),
                                                                      @(LYGSharePlatformQQ),
                                                                      @(LYGSharePlatformQQZone),
                                                                      @(LYGSharePlatformSina),]];
    
    if((share.type.integerValue != kLYTimeLineShareTypeScreenShot)){
        
        if (share.type.integerValue == kLYTimeLineShareTypeLOL) {
            if (share.smallShareImage) { // LOL 类型,有图就显示
                [platformArray addObject:@(LYGSharePlatformSavePic)];
            }
        }else if (share.type.integerValue == kLYTimeLineShareTypeAudioCall) {
        
        } else {
            [platformArray addObject:@(LYGSharePlatformSavePic)];
        }
    }
    
    [[LYSharePlatformView setPlatform:platformArray
                               finish:^(NSInteger platform) {
                                   [weakSelf share:config toPlatform:platform];
                               }] show];
}


static NSString * shareWay = @"";
#pragma mark -- 分享入口 选择分享
- (void)shareWithShareType:(LYGPlatformType)type withDictStyle:(NSDictionary *)dictStyle optionBlock:(ShareOptBlock) optionBlock optionDic:(NSDictionary *) optDic;
{
    if (type == LYGPlatformTypeAny) {
        WeakSelf(weakSelf);
        //选择分享平台
        [[LYSharePlatformView setPlatform:@[@(LYGSharePlatformLYG),
                                            @(LYGSharePlatformWeiXinFriend),
                                            @(LYGSharePlatformWeiXinCircle),
                                            @(LYGSharePlatformQQ),
                                            @(LYGSharePlatformQQZone),
                                            @(LYGSharePlatformSina),
                                            @(LYGSharePlatformCopyLink)]
                                   finish:^(NSInteger platform) {
                                       LYShareConfig *share = nil;
                                       switch (platform) {
                                           case LYGSharePlatformWeiXinCircle:
                                           {
                                               share = dictStyle[LY_SHARE_WeiXinTimeLine_STYLE_PREFIX];
                                           }
                                               break;
                                           case LYGSharePlatformWeiXinFriend:
                                           {
                                               share = dictStyle[LY_SHARE_Wechat_STYLE_PREFIX];
                                           }
                                               break;
                                           case LYGSharePlatformSina:
                                           {
                                               share = dictStyle[LY_SHARE_WeiXinTimeLine_STYLE_PREFIX];
                                           }
                                               break;
                                           case LYGSharePlatformQQ:
                                           {
                                               share = dictStyle[LY_SHARE_QQ_STYLE_PREFIX];
                                           }
                                               break;
                                           case LYGSharePlatformQQZone:
                                           {
                                               share = dictStyle[LY_SHARE_QZone_STYLE_PREFIX];
                                           }
                                               break;
                                           case LYGSharePlatformCopyLink:
                                           {
                                               share = dictStyle[LY_SHARE_DEFAULT_SHARE_STYLE_PREFIX];
                                           }
                                               break;
                                               
                                           default:
                                               break;
                                       }
                                       [weakSelf share:share toPlatform:platform];
                                   } optionBlock:optionBlock optionDic:optDic] show];
    } else {
        
        LYShareConfig *shareConfig = nil;
        if (type == LYGPlatformSubTypeQQFriend) {
            shareConfig = dictStyle[LY_SHARE_QQ_STYLE_PREFIX];
        } else if (type == LYGPlatformSubTypeQZone){
            shareConfig = dictStyle[LY_SHARE_QZone_STYLE_PREFIX];
        } else if (type == LYGPlatformTypeSinaWeibo) {
        }
        [self shareToSinglePlatformWithShareType:type withShareConfig:shareConfig];
    }
}

- (void)executeJSCallBackWithType:(NSInteger)type
{
    if ([self isKindOfClass:[LYWebViewController class]]) {
        
        NSMutableDictionary *extensionInfo = self.extensionInfo;
        NSDictionary *dictStyle = extensionInfo[@"shareContent"][@"dictStype"];
        
        NSString *key = nil;
        switch (type) {
            case LYGPlatformTypeSinaWeibo:
                key = LY_SHARE_WeiBo_STYLE_PREFIX;
                break;
            case LYGPlatformSubTypeWechatSession:
                key = LY_SHARE_Wechat_STYLE_PREFIX;
                break;
            case LYGPlatformSubTypeWechatTimeline:
                key = LY_SHARE_WeiXinTimeLine_STYLE_PREFIX;
                break;
            case LYGPlatformSubTypeQQFriend:
                key = LY_SHARE_QQ_STYLE_PREFIX;
                break;
            case LYGPlatformSubTypeQZone:
                key = LY_SHARE_QZone_STYLE_PREFIX;
                break;
            case 1001:
                key = LY_SHARE_Friend_STYLE_PREFIX;
                break;
            case 1002:
                key = LY_SHARE_CUSTOM_URL_PREFIX;
                break;
            default:
                break;
        }
        
        NSString *jsValue = nil;
        if (key) {
            LYShareConfig *shareConfig = [dictStyle objectForKey:key];
            if (shareConfig && [shareConfig isKindOfClass:[LYShareConfig class]]) {
                jsValue = shareConfig.jsParam;
            }
        }
        
        LYWebViewController *webView = (LYWebViewController *)self;
        if (![jsValue length]) {
            jsValue = extensionInfo[@"jsValue"];
        }
        [webView executeJSCallBack:jsValue];
    }
}

- (void)shareLogStatics:(LYGPlatformType)type
{
    LYSharedType lyShareType = LYSharedTypeCopy;
    NSString *share =@"share_qq";
    switch (type) {
        case LYGPlatformSubTypeWechatTimeline:
        {
            lyShareType = LYSharedTypeWeChatMoment;
            share = @"share_moment";
            break;
        }
        case LYGPlatformSubTypeWechatSession:
        {
            lyShareType = LYSharedTypeWeChatFriend;
            share = @"share_wechat";
            break;
        }
        case LYGPlatformSubTypeQQFriend:
        {
            lyShareType = LYSharedTypeQQ;
            share = @"share_qq";
            break;
        }
        case LYGPlatformSubTypeQZone:
        {
            lyShareType = LYSharedTypeQZone;
            share = @"share_qzone";
            break;
        }
        case LYGPlatformTypeCopy:
        {
            lyShareType = LYSharedTypeCopy;
            share = @"share_url";
            
            break;
        }
        case LYGPlatformTypeSinaWeibo:
        {
            lyShareType = LYSharedTypeWeibo;
            share = @"share_weibo";
            break;
        }
        default:
            break;
    }
}

- (void)setShareWebType:(NSString *)shareWebType
{
    objc_setAssociatedObject(self, &keyShareType, shareWebType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)shareWebType
{
    NSString *type = objc_getAssociatedObject(self, &keyShareType);
    if ([type length] == 0) {
        type = @"-1";
    }
    
    return type;
}

- (void)loadCustomUrl:(NSString *)url
{
    [SVProgressHUD showImage:nil status:@"分享成功"];
    if ([url length]) {
        [self executeJSCallBackWithType:1002];
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] delegate:nil];
    }
}

//点击聊天icon
- (void)selectChatIssueSection
{
    LYSelectShareWayController *vc = [[LYSelectShareWayController alloc] initWithStyle:UITableViewStylePlain];
    LYBaseNavigationController *nav = [[LYBaseNavigationController alloc] initWithRootViewController:vc];
    vc.share = self.extensionInfo[@"shareFriend"];
    
    WeakSelf(ws);
    vc.selectedShareWayBlock = ^(id obj, NSString *text) {
        NSMutableDictionary *extensionInfo = self.extensionInfo;
        extensionInfo[@"shareText"] = text;
        extensionInfo[@"friend"] = obj;

         [LYShareChatIssueHelper sendShareMessageWithExtension:extensionInfo];
         NSLog(@"%@",text);
        
        [ws executeJSCallBackWithType:1001];
    };
    
    vc.shareCardBlock = ^(FriendItem *friend, id selectedParameter) {
        [ws sendCardMessage:friend To:selectedParameter];
    };
    vc.shareWeddingBlock = ^(LYShare *share, id selectedParameter){
        [ws sendWeddingMessage:share To:selectedParameter];
    };
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    if ([self isKindOfClass:[LYPlayerViewController class]]) {
        
        [self presentViewController:nav animated:YES completion:NULL];
    } else {
        [self.navigationController presentViewController:nav animated:YES completion:NULL];
    }
}

#pragma mark 复制到剪切板
- (void)shareCopy:(NSString *)shareContent
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = shareContent;
    [SVProgressHUD showImage:nil status:@"复制成功"];
}

#pragma mark 保存图像
- (void)savePhoto:(UIImage *)image
{
   // WeakSelf(ws);
    [[SJPickPhotoManager pickPhotoManager] createAlbum:image completionBlock:^{
        [LYProgressHUD showWithMaskType:LYProgressHUDHUDMaskTypeNone withTitle:@"保存成功"];
    }];
}

-(void)sendWeddingMessage:(LYShare *)share To:(id)obj{ //lcb wedding
    NSString *chatId = @"";
    NSString *pushTitle;
    NSMutableDictionary *ext;
    
    IMChatMsgType controllerType = IMChatMsgTypePrivate;
    NSString * nick = @"";
    
    if ([obj isKindOfClass:[ChatGroupItem class]]) {
        controllerType = IMChatMsgTypeGroup;
        ChatGroupItem * group = obj;
        chatId = group.groupId;
        nick = group.groupNickname;
    }else if([obj isKindOfClass:[FriendItem class]]){
        controllerType = IMChatMsgTypePrivate;
        FriendItem * user = obj;
        chatId = user.userId;
        nick = user.name;
    }
    
    pushTitle = @"我们结婚啦";
    NSDictionary *dict = [IMChatExtension generateExtensionDictionaryWithNickname:nick];
    ext = [NSMutableDictionary dictionaryWithDictionary:dict];
    [ext setValue:share.roomId forKey:@"room_id"];
    [ext setValue:[NSString stringWithFormat:@"%ld",IMChatMsgContentCardWedding] forKey:@"card_type"];
    FriendItem *leftItem = share.userInfos.firstObject;
    NSDictionary *leftdict=nil;
    if (leftItem) {
       leftdict = @{@"avatar":mAvailableString(leftItem.avatar),@"username":mAvailableString(leftItem.name)};
    }
    FriendItem *rightItem = share.userInfos.lastObject;
    NSDictionary *rightdict =nil;
    if (rightItem) {
        rightdict = @{@"avatar":mAvailableString(rightItem.avatar),@"username":mAvailableString(rightItem.name)};
    }
    NSMutableArray *userAry =[NSMutableArray arrayWithObjects:leftdict,rightdict, nil];
    if (userAry && userAry.count>0) {
        [ext setObject:userAry forKey:@"room_users"];
    }
    NSString *msgBody = [NSString stringWithFormat:@"%@(若不能正常显示请升级至最新版本)",pushTitle];
    [IMChatSendHelper sendCardMessageWithString:msgBody
                                       toChatId:chatId
                                    messageType:controllerType
                                            ext:ext
                             savedCompleteBlock:^(BOOL success, NSError *error) {
                                 [SVProgressHUD showImage:nil status:@"分享成功"];
                             }];
    //有文本发文本信息。
    if (![NSString LY_isNULLStringWhenTrimString:share.content]) {
        [IMChatSendHelper sendTextMessageWithString:share.content
                                           toChatId:chatId
                                        messageType:controllerType
                                                ext:ext
                                 savedCompleteBlock:nil];
    }
}
-(void)sendCardMessage:(FriendItem *) friend To:(id)obj
{
    
    NSString *chatId = @"";
    NSString *pushTitle;
    NSMutableDictionary *ext;
    
    NSString *uid = @"";
    NSString *type = @"";
    
    IMChatMsgType controllerType = IMChatMsgTypePrivate;
    NSString * nick = @"";
    
    if ([obj isKindOfClass:[ChatGroupItem class]]) {
        controllerType = IMChatMsgTypeGroup;
        ChatGroupItem * group = obj;
        chatId = group.groupId;
        nick = group.groupNickname;
    }else if([obj isKindOfClass:[FriendItem class]]){
        controllerType = IMChatMsgTypePrivate;
        FriendItem * user = obj;
        chatId = user.userId;
        nick = user.name;
    }
    
    pushTitle = @"[个人名片]";
    NSDictionary *dict = [IMChatExtension generateExtensionDictionaryWithNickname:nick];
    ext = [NSMutableDictionary dictionaryWithDictionary:dict];
    [ext setValue:[NSString stringWithFormat:@"%ld",IMChatMsgContentCardPerson] forKey:@"card_type"];
    [ext setValue:userSmallAvatarUrl(friend.userId,friend.avatarUpdatetime)?:@"" forKey:@"user_avatar"];
    [ext setValue:[NSString stringWithFormat:@"%@",friend.gender] forKey:@"p_c_gender"];
    [ext setValue:friend.name forKey:@"p_c_nick_name"];
    [ext setValue:friend.position  forKey:@"p_c_location"];
    [ext setValue:[NSString stringWithFormat:@"%@",friend.gameStars] forKey:@"p_c_game_star"];
    [ext setValue:friend.userId forKey:@"user_id"];
    [ext setValue:friend.avatarUpdatetime forKey:@"ut"];
    [ext setValue:[NSString stringWithFormat:@"%@",friend.privacy] forKey:@"p_c_location_privacy"];
    [ext setValue:friend.gameIds?:@[] forKey:@"p_c_game_icons"];
    //兼容2.3.9
    [ext setValue:@"1" forKey:@"personal_card_flag"];
    [ext setValue:friend.gouhao forKey:@"p_c_gou_id"];
    
    //用户的版主、女神等标示符图片url,例如：@"http://static.lygou.cc/app/ap/2.png"
    [ext setValue:friend.markPic forKey:@"pTag"];
    
    uid = friend.userId;
    type = @"1";
    
    NSString *msgBody = [NSString stringWithFormat:@"%@(若不能正常显示请升级至最新版本)",pushTitle];
    [IMChatSendHelper sendCardMessageWithString:msgBody
                                       toChatId:chatId
                                    messageType:controllerType
                                            ext:ext
                             savedCompleteBlock:^(BOOL success, NSError *error) {
                                 [SVProgressHUD showImage:nil status:@"分享成功"];
                                 }];
}


@end
