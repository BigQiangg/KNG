//
//  LYWXPlatformManager.m
//  laoyuegou
//
//  Created by Dombo on 2017/8/3.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "LYWXPlatformManager.h"
#import "LYShareConfig.h"

@interface LYWXPlatformManager ()<
WXApiDelegate
>
@property (nonatomic, copy) success suceeess;
@property (nonatomic, strong) UIActivityIndicatorView *activity;
//@property (nonatomic, strong) UIView *tempView;
@end

@implementation LYWXPlatformManager

#pragma mark - key

+ (NSString *)jinYue_WeiXinKey {
    return JinYue_WeiXin_App_Key;
}

+ (NSString *)jinYue_WeiXinSecret {
    return JinYue_WeiXin_App_Secret;
}

+ (NSString *)haiNan_WeiXinKey {
    return HaiNan_WeiXin_App_Key;
}

+ (NSString *)haiNan_WeiXinSecret {
    return HaiNan_WeiXin_App_Secret;
}

+ (NSString *)haiNan_LYG_WeiXinKey {
    return HaiNan_LYG_WeiXin_App_Key;
}

+ (NSString *)haiNan_LYG_WeiXinSecret {
    return HaiNan_LYG_WeiXin_App_Secret;
}

#pragma mark - sharedInstance
+ (instancetype)sharedInstance
{
    static LYWXPlatformManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LYWXPlatformManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activity.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2 - 50);//只能设置中心，不能设置大小
        [self.activity setHidesWhenStopped:YES];
    }
    return self;
}

#pragma mark - method
+ (void)registerAppWithWeChat {
    [WXApi registerApp:[LYWXPlatformManager jinYue_WeiXinKey]];
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
}

+ (void)registerAppPayWithWeChat {
    [WXApi registerApp:[LYWXPlatformManager haiNan_LYG_WeiXinKey]];
    //向微信注册支持的文件类型
    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
    
    [WXApi registerAppSupportContentFlag:typeFlag];
}

#pragma mark - appdelegate call-back
+ (BOOL)LYWXPlatformManagerApplication:(UIApplication *)application
                            handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:[LYWXPlatformManager sharedInstance]];
}

+ (BOOL)LYWXPlatformManagerApplication:(UIApplication *)application
                                  openURL:(NSURL *)url
                        sourceApplication:(NSString *)sourceApplication
                               annotation:(id)annotation
{
      return [WXApi handleOpenURL:url delegate:[LYWXPlatformManager sharedInstance]];
}

#pragma mark - send method
/**
 *  设置微信分享参数
 *
 *  @param text         文本
 *  @param title        标题
 *  @param url          分享链接
 *  @param thumbImage   缩略图，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、LYGImage
 *  @param image        图片，可以为UIImage、NSString（图片路径）、NSURL（图片路径）、LYGImage
 *  @param musicFileURL 音乐文件链接地址
 *  @param extInfo      扩展信息
 *  @param fileData     文件数据，可以为NSData、UIImage、NSString、NSURL（文件路径）、LYGData、LYGImage
 *  @param emoticonData 表情数据，可以为NSData、UIImage、NSURL（文件路径）、LYGData、LYGImage
 *  @param type         分享类型，支持LYGContentTypeText、LYGContentTypeImage、LYGContentTypeWebPage、LYGContentTypeApp、LYGContentTypeAudio和LYGContentTypeVideo
 *  @param platformType 平台子类型，只能传入LYGPlatformSubTypeWechatSession、LYGPlatformSubTypeWechatTimeline和LYGPlatformSubTypeWechatFav其中一个
 *
 *  分享文本时：
 *  设置type为LYGContentTypeText, 并填入text参数
 *
 *  分享图片时：
 *  设置type为LYGContentTypeImage, 非gif图片时：填入title和image参数，如果为gif图片则需要填写title和emoticonData参数
 *
 *  分享网页时：
 *  设置type为LYGContentTypeWebPage, 并设置text、title、url以及thumbImage参数，如果尚未设置thumbImage则会从image参数中读取图片并对图片进行缩放操作。
 *
 *  分享应用时：
 *  设置type为LYGContentTypeApp，并设置text、title、extInfo（可选）以及fileData（可选）参数。
 *
 *  分享音乐时：
 *  设置type为LYGContentTypeAudio，并设置text、title、url以及musicFileURL（可选）参数。
 *
 *  分享视频时：
 *  设置type为LYGContentTypeVideo，并设置text、title、url参数
 */
+ (void)lySetupWeChatParamsByText:(NSString *)text
                              title:(NSString *)title
                                url:(NSURL *)url
                         thumbImage:(id)thumbImage
                              image:(id)image
                       musicFileURL:(NSURL *)musicFileURL
                            extInfo:(NSString *)extInfo
                           fileData:(id)fileData
                       emoticonData:(id)emoticonData
                               type:(LYGContentType)type
                 forPlatformSubType:(LYGPlatformType)platformSubType {
    [LYWXPlatformManager registerAppWithWeChat];
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    switch (type) {
        case LYGContentTypeText:
        {
            
            req.text = text;
            req.bText = YES;
            req.scene =[LYWXPlatformManager sceneType:platformSubType];
//            [WXApi sendReq:req];
        }
            break;
        case LYGContentTypeImage:
        {
            WXMediaMessage *message = [WXMediaMessage message]; 
            message.thumbData = [LYWXPlatformManager thumbData:thumbImage];
            WXImageObject *imageObject = [WXImageObject object];
            imageObject.imageData = [LYWXPlatformManager imageData:image];
            message.mediaObject = imageObject;
//            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene =[LYWXPlatformManager sceneType:platformSubType];
//            [WXApi sendReq:req];
        }
            break;
        case LYGContentTypeAudio:
        {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = title;
            message.description = text;
            message.thumbData = [LYWXPlatformManager thumbData:image];
            WXMusicObject *ext = [WXMusicObject object];
            ext.musicUrl = [url description];
            ext.musicLowBandUrl = ext.musicUrl;
//            ext.musicDataUrl =
            message.mediaObject = ext;
            
//            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene =[LYWXPlatformManager sceneType:platformSubType];
//            [WXApi sendReq:req];
        }
            break;
        case LYGContentTypeFile:
        {
            
        }
            break;
        case LYGContentTypeVideo:
        {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = title;
            message.description = text; 
            message.thumbData = [LYWXPlatformManager thumbData:image];
            WXVideoObject *videoObject = [WXVideoObject object];
            videoObject.videoUrl = [url description];
//            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.bText = NO;
            req.message = message;
            req.scene =[LYWXPlatformManager sceneType:platformSubType];
//            [WXApi sendReq:req];
        }
            break;
        case LYGContentTypeWebPage:
        {
            //如果url地址为空，则直接分享纯文本
            if ([url absoluteString]) {
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = title;
                message.description = text;
                message.thumbData = [LYWXPlatformManager thumbData:image];
                WXWebpageObject *webpageObject = [WXWebpageObject object];
                webpageObject.webpageUrl = [url description];
                message.mediaObject = webpageObject;
                //            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
                req.bText = NO;
                req.message = message;
                req.scene = [LYWXPlatformManager sceneType:platformSubType];
            } else {
                NSString *content = text;
                if (![text length]) {
                    content = title?:@"";
                }
                req.text = text;
                req.bText = YES;
                req.scene =[LYWXPlatformManager sceneType:platformSubType];
            }
        }
            break;
        case LYGContentTypeAuto:
        {
            
        }
            break;
        case LYGContentTypeApp:
        {
            
        }
            break;
        default:
            break;
    }
//    [[LYWXPlatformManager sharedInstance].activity stopAnimating];
//    [[LYWXPlatformManager sharedInstance].activity removeFromSuperview]; 
    [WXApi sendReq:req];
}



+(BOOL)lySendAuthReq:(SendAuthReq*)req viewController:(UIViewController*)viewController
{
    return [WXApi sendAuthReq:req viewController:viewController delegate:[LYWXPlatformManager sharedInstance]];
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

+ (int)sceneType:(LYGPlatformType)platformSubType {
    int type;
    if (platformSubType == LYGPlatformSubTypeWechatSession)
    {
        type =  WXSceneSession;
    }
    else
    {
        type = WXSceneTimeline;
    }
    return type;
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

+ (NSData *)thumbData:(id)image {
    UIImage *desImage = [[UIImage alloc] initWithData:[LYWXPlatformManager imageData:image]];
    UIImage *thumbImg = [LYWXPlatformManager thumbImageWithImage:desImage limitSize:CGSizeMake(100, 100)];
    return UIImageJPEGRepresentation(thumbImg, 1);
}

//enum WXErrCode {
//    WXSuccess = 0,
//    WXErrCodeCommon = -1,
//    WXErrCodeUserCancel = -2,
//    WXErrCodeSentFail = -3,
//    WXErrCodeAuthDeny = -4,
//    WXErrCodeUnsupport = -5,
//};
#pragma mark - call-back
-(void) onResp:(BaseResp*)resp {
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    { 
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        NSLog(@"%@",strMsg);
        if (resp.errCode == 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD showImage:nil status:@"分享成功"];
                });
            });
        }else {
            
            if (resp.errCode != WXErrCodeUserCancel) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD showImage:nil status:@"分享失败"];
                    });
                });
            }
        }
    }
    else if ([resp isKindOfClass:[SendAuthResp class]])
    {
        NSLog(@"登录");
        if (_authDelegate && [_authDelegate respondsToSelector:@selector(lyWXPlatfromManager:sendAuthResp:)])
        {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [_authDelegate lyWXPlatfromManager:self sendAuthResp:authResp];
        } 
    }
}

#pragma mark - block
- (void)setPaySuccess:(success)success {
    _suceeess = success;
}

+ (BOOL)isInstalled{
    if ([WXApi isWXAppInstalled]) {
        return YES;
    }else{
        return NO;
    }
}

@end
