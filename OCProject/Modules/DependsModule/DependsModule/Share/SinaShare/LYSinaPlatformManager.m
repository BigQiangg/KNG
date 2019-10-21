//
//  LYSinaPlatformManager.m
//  laoyuegou
//
//  Created by Dombo on 2017/12/28.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "LYSinaPlatformManager.h"
//#import <WeiboSDK.h>
#import "WeiboSDK.h"
#import "LYLoginStatusManager.h"
#import <CoreModule/NSString+MD5.h>
#import "LYShareDefine.h"

//#define kSinaWeiBo_App_Key @"wb2569657981"
//#define kSinaWeiBo_App_Key  @"wb2045436852"
//#define KGSinaWeibo_App_Key @"2569657981"
//#define KGSinaWeibo_App_Secret @"6a697ef8617c7721cc91f54ee09b3dee"

@interface LYSinaPlatformManager()
<WeiboSDKDelegate> {
    NSString *_wbToken;
}
@end

@implementation LYSinaPlatformManager

#pragma mark - sharedInstance
+ (instancetype)sharedInstance
{
    static LYSinaPlatformManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LYSinaPlatformManager alloc] init];
    });
    return manager;
}

- (void)sinaWeiBoToken:(NSString *)token {
    _wbToken = token;
}

- (NSString *)weiboToken {
    return _wbToken;
}

#pragma mark - reset
- (void)resetSinaWeiBoKey {
    _wbToken = @"";
}

#pragma mark -
+ (void)registerAppWithSinaWeiBo {
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:KGSinaWeibo_App_Key]; 
}

+ (void)authorizeLoginWithDelegate:(id)delegate {
    
    [LYSinaPlatformManager sharedInstance].delegate = delegate;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"http://www.laoyuegou.com";
    request.scope = @"all";
    [LYLoginStatusManager registeredLoginStatePlatfromKey:LYLoginPlatfrom_Weibo];
    [WeiboSDK sendRequest:request];
}

+ (NSString *)sinaWeiBoKey {
    return @"wb2569657981";
}

#pragma mark -

#pragma mark - appdelegate call-back
+ (BOOL)lySinaPlatformManagerApplication:(UIApplication *)application
                         handleOpenURL:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:[LYSinaPlatformManager sharedInstance]];
}

+ (BOOL)lySinaPlatformManagerApplication:(UIApplication *)application
                               openURL:(NSURL *)url
                     sourceApplication:(NSString *)sourceApplication
                            annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:[LYSinaPlatformManager sharedInstance]];
}


#pragma mark - shareMethod
/**
 *  设置新浪微博分享参数
 *
 *  @param text      文本
 *  @param title     标题
 *  @param image     图片对象，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、SSDKImage
 *  @param url       分享链接
 *  @param latitude  纬度
 *  @param longitude 经度
 *  @param objectID  对象ID，标识系统内内容唯一性，应传入系统中分享内容的唯一标识，没有时可以传入nil
 *  @param type      分享类型，仅支持Text、Image、WebPage（客户端分享时）类型
 */
+ (void)lySetupSinaWeiboShareParamsByText:(NSString *)text
                                      title:(NSString *)title
                                      image:(id)image
                                        url:(NSURL *)url
                                   latitude:(double)latitude
                                  longitude:(double)longitude
                                   objectID:(NSString *)objectID
                                       type:(LYShareContentType)type {
    
    if (![LYSinaPlatformManager isWeiboAppInstalled])
    {
#warning 遗留问题
        [[UINavigationBar appearance] setTranslucent:YES]; // 这个影响了webview中的内容高度，有问题，后期统一调整
    }
    
    WBMessageObject *message = [WBMessageObject message];
    
    switch (type) {
        case LYShareContentTypeAuto: {
            break;
        }
        case LYShareContentTypeText: {
            message.text = text;
            break;
        }
        case LYShareContentTypeImage: {
            message.text = text;
            WBImageObject *imageObject = [WBImageObject object];
            imageObject.imageData = [LYSinaPlatformManager imageData:image];
            message.imageObject = imageObject;
            break;
        }
        case LYShareContentTypeWebPage: {
//            message.text = text;
            WBWebpageObject * webPageObject = [WBWebpageObject object];
            webPageObject.objectID = [url.absoluteString MD5Digest];
            webPageObject.title = title;
            webPageObject.description = text;
            webPageObject.thumbnailData = [LYSinaPlatformManager thumbData:[LYSinaPlatformManager imageData:image]];
            webPageObject.webpageUrl = url.absoluteString;
            message.mediaObject = webPageObject;
            break;
        }
        case LYShareContentTypeApp: {
            break;
        }
        case LYShareContentTypeAudio: {
            break;
        }
        case LYShareContentTypeVideo: {
            break;
        }
        case LYShareContentTypeFile: {
            break;
        }
    }
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://www.sina.com";
    authRequest.scope = @"all";
    
    NSString *accessToken = [[LYSinaPlatformManager sharedInstance] weiboToken];
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:accessToken];
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

+ (NSData *)thumbData:(id)image {
    UIImage *desImage = [[UIImage alloc] initWithData:[LYSinaPlatformManager imageData:image]];
    UIImage *thumbImg = [LYSinaPlatformManager thumbImageWithImage:desImage limitSize:CGSizeMake(100, 100)];
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

#pragma mark - WeiboSDKDelegate
/**
 收到一个来自微博客户端程序的请求
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

/**
 收到一个来自微博客户端程序的响应
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if (![LYSinaPlatformManager isWeiboAppInstalled])
    {
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%ld", (long)response.statusCode];
        NSLog(@"%@",strMsg);
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showImage:nil status:@"分享成功"];
                });
            });
        } else if (response.statusCode != WeiboSDKResponseStatusCodeUserCancel && response.statusCode != WeiboSDKResponseStatusCodeUnknown){
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showImage:nil status:@"分享失败"];
                });
            });
        }
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        NSLog(@"accessToken == %@",[(WBAuthorizeResponse *)response accessToken]);
        NSLog(@"userID == %@",[(WBAuthorizeResponse *)response userID]);
        NSLog(@"refreshToken == %@",[(WBAuthorizeResponse *)response refreshToken]);
        NSLog(@"userInfo == %@", response.userInfo);
        NSString *userId = [(WBAuthorizeResponse *)response userID];
        NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
        
        if (userId.length > 0 && accessToken.length >0)
        {
            if (![LYSinaPlatformManager isWeiboAppInstalled]) {
                [LYProgressHUD showAnimationWithMaskType:LYProgressHUDHUDMaskTypeClear];
            }
            
            [LYLoginStatusManager resetLoginStatePlatfromKey:LYLoginPlatfrom_Weibo];
            
            SinaUserInfoModel *model = [SinaUserInfoModel new];
            [[LYSinaPlatformManager sharedInstance] sinaWeiBoToken:accessToken];
            
            WeakSelf(weakSelf)
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@&btn=login",accessToken,userId]];
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSLog(@"从服务器获取到数据");
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
                NSString *avatar = [dict objectForKey:@"avatar_large"];
                NSString *name = [dict objectForKey:@"name"];
                NSString *gender  = [dict objectForKey:@"gender"];
                
                model.name = name;
                model.avatar_large = avatar;
                model.genderStr = gender;
                model.uid = userId;
                model.accessToken = accessToken;
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(lySinaPlatformManager:userInfoModel:)]) {
                    [weakSelf.delegate lySinaPlatformManager:self userInfoModel:model];
                } else {
                    [LYProgressHUD dismiss];
                }
            }];
            [sessionDataTask resume];
        }
        else
        {
            [LYProgressHUD dismiss];
            if (self.delegate && [self.delegate respondsToSelector:@selector(lySinaPlatformManager:authorizeLoginStatus:)]) {
                [self.delegate lySinaPlatformManager:self authorizeLoginStatus:UserActionStatus_Failure];
            }
        }
    }
}

#pragma mark - sdf
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


#pragma mark - Judge
+ (BOOL)isWeiboAppInstalled {
    return [WeiboSDK isWeiboAppInstalled];
}

+ (BOOL)openWeiboApp {
    return [WeiboSDK openWeiboApp];
}
@end


@implementation SinaUserInfoModel

- (void)setGenderStr:(NSString *)genderStr {
    _genderStr = genderStr;
    
    if ([genderStr isEqualToString:@"m"])
    {// 男
        _gender = @"1";
    }
    else if ([genderStr isEqualToString:@"f"])
    {// 女
        _gender = @"2";
    }
    else
    {// 未知
        _gender = @"3";
    }
}
@end
