//
//  LYWXPlatformManager.h
//  laoyuegou
//
//  Created by Dombo on 2017/8/3.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYShareConfig.h"
#import "WXApi.h"
#import "LYShareDefine.h"
#import "LYWXPlatformManager.h"

@class LYWXPlatformManager;

@protocol LYWXPlatfromDelegate <NSObject>

- (void)lyWXPlatfromManager:(LYWXPlatformManager *)manager sendAuthResp:(SendAuthResp *)authResp;
@end

@interface LYWXPlatformManager : NSObject

+ (NSString *)jinYue_WeiXinKey;

+ (NSString *)jinYue_WeiXinSecret;

+ (NSString *)haiNan_WeiXinKey;

+ (NSString *)haiNan_WeiXinSecret;

+ (NSString *)haiNan_LYG_WeiXinKey;

+ (NSString *)haiNan_LYG_WeiXinSecret;

+ (instancetype)sharedInstance;
+ (void)registerAppWithWeChat; //!< 微信app 注册

+ (void)registerAppPayWithWeChat;

#pragma mark - Appdelegate 回调
+ (BOOL)LYWXPlatformManagerApplication:(UIApplication *)application
                            handleOpenURL:(NSURL *)url;

+ (BOOL)LYWXPlatformManagerApplication:(UIApplication *)application
                                  openURL:(NSURL *)url
                        sourceApplication:(NSString *)sourceApplication
                               annotation:(id)annotation;

#pragma mark - Method
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
               forPlatformSubType:(LYGPlatformType)platformSubType;


+(BOOL)lySendAuthReq:(SendAuthReq*)req viewController:(UIViewController*)viewController;

#pragma mark - Delegate
@property (nonatomic, assign) id <LYWXPlatfromDelegate> authDelegate;//!< 登录回调代理

#pragma mark - Block
typedef void (^success)(id obj);

- (void)setPaySuccess:(success)success; //!< 支付成功回调block

+ (BOOL)isInstalled;

@end
