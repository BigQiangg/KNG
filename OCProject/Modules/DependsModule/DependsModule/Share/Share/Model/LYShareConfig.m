
//
//  LYShareConfig.m
//  laoyuegou
//
//  Created by smalljun on 16/4/6.
//  Copyright © 2016年 HaiNanLexin. All rights reserved.
//

#import "LYShareConfig.h"
#import "FriendItem.h"

@implementation LYShareConfig

//分享规则参考邮件，首先分享有统一默认的title、url、content、image，然后可以各自配置各分享平台的属性，后者优先级高
+ (LYShareConfig *)shareConfigWithDict:(NSDictionary *)dict withParams:(NSArray *)params withSuffix:(NSString *)suffix withStylePrefix:(NSString *)prefix
{
    LYShareConfig *shareConfig = [[LYShareConfig alloc] init];
    
    NSString *title = [NSString stringFilterArray:params withKeyWord:[NSString stringWithFormat:@"title_%@=",suffix]];
    NSString *shareUrl = [NSString stringFilterArray:params withKeyWord:[NSString stringWithFormat:@"share_url_%@=",suffix]];
    NSString *shareContent = [NSString stringFilterArray:params withKeyWord:[NSString stringWithFormat:@"share_content_%@=",suffix]];
    NSString *imageUrl = [NSString stringFilterArray:params withKeyWord:[NSString stringWithFormat:@"imageurl_%@=",suffix]];
    
    NSString *jsParam = [NSString stringFilterArray:params withKeyWord:[NSString stringWithFormat:@"jsParam_%@=",suffix]];
    
    NSString *large = [NSString stringFilterArray:params withKeyWord:[NSString stringWithFormat:@"large_%@=",suffix]];
    NSString *large_small = [NSString stringFilterArray:params withKeyWord:[NSString stringWithFormat:@"large_small_%@=",suffix]];
    
    if (![imageUrl length]) {
        imageUrl = dict[@"imageUrl"];
    }
    
    NSString *style = [NSString stringFilterArray:params withKeyWord:prefix]?:@"A";
    shareConfig.shareStyle = style;
    shareConfig.imageUrl = imageUrl;
    shareConfig.jsParam = jsParam;
    
    shareConfig.title = title?:dict[@"title"];
    shareConfig.url = shareUrl?:dict[@"shareUrl"];
    shareConfig.content = shareContent?:dict[@"shareContent"];
    shareConfig.large = large?:dict[@"large"];
    shareConfig.large_small = large_small?:dict[@"large_small"];
    return shareConfig;
}

+ (LYShareConfig *)shareConfigWithGroup:(LYGPlatformType)type url:(NSString *)url
{
    NSMutableDictionary *dictGroup = [NSMutableDictionary dictionary];
    dictGroup[@"title"] = @"游戏玩家的社交，我在捞月狗等你";
    dictGroup[@"content"] =[NSString stringWithFormat:@"我的捞月狗狗号 %@ ，游戏玩家都在用，快来体验吧",[LYDAOManager sharedInstance].userProfileDAO.loginUser.gouhao];
    dictGroup[@"url"] = url;
    NSString *imageURL = nil;
    NSString *style = nil;
    if (type == LYGPlatformTypeSinaWeibo) {
        imageURL = @"http://imgd3.laoyuegou.com/junebride/_fm_share.jpg";
        style = @"B";
    } else {
        imageURL = @"http://imgd3.laoyuegou.com/junebride/logo_small.png";
        style = @"A";
    }
    dictGroup[@"imageURL"] = imageURL;
    dictGroup[@"style"] = style;
    return [LYShareConfig shareConfigWithContentDict:dictGroup];
}

+ (LYShareConfig *)shareConfigWithGroup:(LYGPlatformType)type shareModel:(LYShare *)shareModel
{
    NSMutableDictionary *dictGroup = [NSMutableDictionary dictionary];
    dictGroup[@"title"] = shareModel.title;
    dictGroup[@"content"] = shareModel.content;
    dictGroup[@"url"] = shareModel.shareUrl;
    NSString *imageURL = nil;
    NSString *style = nil;
    if (type == LYGPlatformTypeSinaWeibo) {
        imageURL = shareModel.sinaPicUrl;
        style = @"B";
    } else {
        imageURL = shareModel.picUrl;
        style = @"A";
    }
    dictGroup[@"imageURL"] = imageURL;
    dictGroup[@"style"]  = style;
    return [LYShareConfig shareConfigWithContentDict:dictGroup];
}


+ (LYShareConfig *)shareConfigWithContentDict:(NSDictionary *)dict
{
    LYShareConfig *shareConfig = [[LYShareConfig alloc] init];
    
    NSString *title = dict[@"title"];
    NSString *shareUrl = dict[@"url"];
    NSString *shareContent = dict[@"content"];
    NSString *imageUrl = dict[@"imageURL"];
    
    shareConfig.shareStyle = dict[@"style"];
    shareConfig.imageUrl = imageUrl;
    
    shareConfig.title = title;
    shareConfig.url = shareUrl;
    shareConfig.content = shareContent;
    
    return shareConfig;
}

+ (LYShareConfig *)shareConfigWithCDKey:(LYGPlatformType)type content:(NSString *)content
{
    NSMutableDictionary *dictGroup = [NSMutableDictionary dictionary];
    dictGroup[@"content"] = mAvailableString(content);
    NSString *style = @"A";
    dictGroup[@"style"] = style;
    return [LYShareConfig shareConfigWithContentDict:dictGroup];
}


@end
