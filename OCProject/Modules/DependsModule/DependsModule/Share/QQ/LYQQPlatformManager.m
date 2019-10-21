//
//  LYQQPlatformManager.m
//  laoyuegou
//
//  Created by zwq on 2018/10/9.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import "LYQQPlatformManager.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface LYQQPlatformManager () <TencentSessionDelegate,QQApiInterfaceDelegate>

@end

@implementation LYQQPlatformManager {
    TencentOAuth * auth;
}

+ (BOOL)isInstalled{
    return [QQApiInterface isQQInstalled];
}

#pragma mark - appdelegate call-back
+ (BOOL)lyQQPlatformManagerApplication:(UIApplication *)application
                           handleOpenURL:(NSURL *)url {
//    return [TencentOAuth HandleOpenURL:url];
//    return [QQApiInterface handleOpenURL:url delegate:self];
    return [[LYQQPlatformManager sharedInstance] handleOpenURL:url];
}

+ (BOOL)lyQQPlatformManagerApplication:(UIApplication *)application
                                 openURL:(NSURL *)url
                       sourceApplication:(NSString *)sourceApplication
                              annotation:(id)annotation
{
//        return [TencentOAuth HandleOpenURL:url];
//    return [QQApiInterface handleOpenURL:url delegate:self];
    return [[LYQQPlatformManager sharedInstance] handleOpenURL:url];
}

- (BOOL)handleOpenURL:(NSURL *) url{
    return [QQApiInterface handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url] ;
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp{
    NSLog(@"%@",resp);
    if (resp.result.integerValue == 0) {
        [SVProgressHUD showImage:nil status:@"分享成功"];
    }else{
        //用户自己取消分享
        if(resp.result.integerValue != -4){
            [SVProgressHUD showImage:nil status:@"分享失败"];
        }
    }
}
static LYQQPlatformManager * _sharedInstance;
+ (LYQQPlatformManager*)sharedInstance{
    if (!_sharedInstance) {
        _sharedInstance = [[LYQQPlatformManager alloc] init];
    }
    return _sharedInstance;
}

+ (void)registerAppWithQQ{
    [[LYQQPlatformManager sharedInstance] registerAppWithQQ];
}

- (void)registerAppWithQQ{
    auth = [[TencentOAuth alloc] initWithAppId:KGQQ_App_Key andDelegate:self];
}


+ (BOOL)isQQCallBack:(NSString *) url{
    return ([url hasPrefix:@"tencent101137147"] || [url hasPrefix:@"QQ06073AFB"]);
}

/**
 *  设置微信分享参数
 *
 *  @param text         文本
 *  @param title        标题
 *  @param url          分享链接
 *  @param thumbImage   缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、LYGImage
 *  @param image        图片，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、LYGImage
 *  @param type         分享类型，支持LYGContentTypeText、LYGContentTypeImage、LYGContentTypeWebPage、LYGContentTypeApp、LYGContentTypeAudio和LYGContentTypeVideo
 *  @param platformType 平台子类型，只能传入LYGPlatformSubTypeWechatSession、LYGPlatformSubTypeWechatTimeline和LYGPlatformSubTypeWechatFav其中一个
 *  分享网页时：
 *  设置type为LYGContentTypeWebPage, 并设置text、title、url以及thumbImage参数，如果尚未设置thumbImage则会从image参数中读取图片并对图片进行缩放操作。
 */
+ (void)lySetupQQParamsByText:(NSString *)text
                            title:(NSString *)title
                              url:(NSURL *)url
                            image:(id)image
                       thumbImage:(id)thumbImage
                             type:(LYGContentType)type
               forPlatformSubType:(LYGPlatformType)platformSubType{
    SendMessageToQQReq *req = nil;
    switch (type) {
        case LYGContentTypeImage:
        {   
            QQApiImageObject *imgObj = [QQApiImageObject objectWithData:[LYQQPlatformManager imageData:image]
                                                       previewImageData:[LYQQPlatformManager thumbData:thumbImage]
                                                                  title:title
                                                            description:text];
            req = [SendMessageToQQReq reqWithContent:imgObj];
        }
            break;
        case LYGContentTypeWebPage:
        {
            //如果url地址为空，则直接分享纯文本
            if ([[url absoluteString] length]) {
                QQApiNewsObject *newsObj = [QQApiNewsObject
                                            objectWithURL:url
                                            title:title
                                            description:text
                                            previewImageData:[LYQQPlatformManager thumbData:image]];
                req = [SendMessageToQQReq reqWithContent:newsObj];
            } else {
                
                NSString *content = text;
                if (![text length]) {
                    content = title?:@"";
                }
                QQApiTextObject *obj = [QQApiTextObject objectWithText:content];
                req = [SendMessageToQQReq reqWithContent:obj];
            }
        }
            break;
            
        default:
            break;
    }
    
    if (platformSubType == LYGPlatformSubTypeQZone) {
        //将内容分享到qzone
        QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    }else if(platformSubType == LYGPlatformSubTypeQQFriend){
        //将内容分享到qq
        QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    }
}

+ (NSData *)thumbData:(id)image {
    UIImage *desImage = [[UIImage alloc] initWithData:[LYQQPlatformManager imageData:image]];
    UIImage *thumbImg = [LYQQPlatformManager thumbImageWithImage:desImage limitSize:CGSizeMake(100, 100)];
    return UIImageJPEGRepresentation(thumbImg, 1);
}


+ (UIImage *)thumbImageWithImage:(UIImage *)scImg limitSize:(CGSize)limitSize {
    if (scImg.size.width <= limitSize.width && scImg.size.height <= limitSize.height)
    {
        return scImg;
    }
    
    CGSize thumbSize;
    if (scImg.size.width / scImg.size.height > limitSize.width / limitSize.height)
    {
        thumbSize.width = limitSize.width;
        thumbSize.height = limitSize.width / scImg.size.width * scImg.size.height;
    }
    else
    {
        thumbSize.height = limitSize.height;
        thumbSize.width = limitSize.height / scImg.size.height * scImg.size.width;
    }
    
    UIGraphicsBeginImageContext(thumbSize);
    [scImg drawInRect:(CGRect){CGPointZero,thumbSize}];
    UIImage *thumbImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return thumbImg;
}

#pragma mark - config
+ (NSData *)imageData:(id)image {
    NSLog(@"----------------------------------------------");
    NSData *data ;
    if ([image isKindOfClass:[NSString class]])
    {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image]];
    }
    else if ([image isKindOfClass:[NSURL class]])
    {
        data = [NSData dataWithContentsOfURL:image];
    }
    else if ([image isKindOfClass:[UIImage class]])
    {
        data = UIImagePNGRepresentation(image);
    }
    NSLog(@"===================================================");
    NSData * imgData = UIImageJPEGRepresentation([UIImage imageWithData:data], 0.8);
    if (!imgData) {
        imgData = UIImageJPEGRepresentation([UIImage imageNamed:@"img_default_yuanzi_share"], 0.8);
    }
    return imgData;
}

- (void)getUserInfoResponse:(APIResponse *)response{
    /*
     NSString *avatar = user.icon;
     if (type == LYThirdPartyLogin_QQ) { //针对qq头像做特殊处理，默认user.icon是空间头像
     if (user.rawData[@"figureurl_qq_2"]) {
     avatar = user.rawData[@"figureurl_qq_2"];
     }
     }
     
     NSString *userId = [NSString stringWithFormat:@"%@",user.uid];
     
     [self requestThirdAccountRegisterWithType:type identity:userId newIdentity:newIdentity password:@"" avatar:avatar nickname:user.nickname gender:[NSString stringWithFormat:@"%lu",user.gender+1] a3:a3];*/
    if(response.errorMsg.integerValue == 0){
        NSDictionary * dic = response.jsonResponse;
        LYThirdUserModel * user = [[LYThirdUserModel alloc] init];
        user.uid = auth.openId;
        user.nickname = [dic objectForKey:@"nickname"];
        user.gender = LYThirdGenderUnknown;
        NSString * gender = [dic objectForKey:@"gender"];
        if(gender){
            if([gender isEqualToString:@"男"]){
                user.gender = LYThirdGenderMale;
            }else if([gender isEqualToString:@"女"]){
                user.gender = LYThirdGenderFemale;
            }
            else
            {
                user.gender = LYThirdGenderUnknown;
            }
        }
        user.rawData = dic;
//        LYThirdCredential * credentila = [[LYThirdCredential alloc] init];
        if (self.loginCallBack) {
            self.loginCallBack(user, LYThirdLoginCodeSuccess, @"登录成功");
        }
    }else{
        self.loginCallBack(nil, LYThirdLoginCodeFail, @"登录失败");
    }
    
}

//登陆完成调用

- (void)tencentDidLogin

{
    
//    resultLable.text =@"登录完成";
    
    
    
    if (auth.accessToken && 0 != [auth.accessToken length])
        
    {
        [auth getUserInfo];//这个方法返回BOOL
        
        //  记录登录用户的OpenID、Token以及过期时间
        
//        tokenLable.text =tencentOAuth.accessToken;
        
    }
    
    else
        
    {
        if (self.loginCallBack) {
            self.loginCallBack(nil, LYThirdLoginCodeFail, @"登录失败");
        }
//        tokenLable.text =@"登录不成功没有获取accesstoken";
        
    }
    
}


//非网络错误导致登录失败：

-(void)tencentDidNotLogin:(BOOL)cancelled

{
    
    NSLog(@"tencentDidNotLogin");
    
    if (cancelled)
        
    {
        if (self.loginCallBack) {
            self.loginCallBack(nil, LYThirdLoginCodeCancel, @"用户取消登录");
        }
//        resultLable.text =@"用户取消登录";
        
    }else{
        if (self.loginCallBack) {
            self.loginCallBack(nil, LYThirdLoginCodeFail, @"登录失败");
        }
//        resultLable.text =@"登录失败";
        
    }
    
}
// 网络错误导致登录失败：

-(void)tencentDidNotNetWork

{
    if (self.loginCallBack) {
        self.loginCallBack(nil, LYThirdLoginCodeNoNetWork, @"无网络连接，请设置网络");
    }
    NSLog(@"tencentDidNotNetWork");
    
//    resultLable.text =@"无网络连接，请设置网络";
    
}

+ (void)authorizeLoginWithCallBack:(LYThirdLoginCallBack) loginCallBack{
    [[LYQQPlatformManager sharedInstance] authorizeLoginWithCallBack:loginCallBack];
}


- (void)authorizeLoginWithCallBack:(LYThirdLoginCallBack) loginCallBack{
    self.loginCallBack = loginCallBack;
    NSArray * permissions= [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",@"add_t",nil];
    
    [auth authorize:permissions inSafari:NO];
}
@end
