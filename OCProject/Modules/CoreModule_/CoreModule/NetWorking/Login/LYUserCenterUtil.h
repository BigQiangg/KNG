//
//  LYUserCenterUtil.h
//  laoyuegou
//
//  Created by LiZ on 16/5/6.
//  Copyright © 2016年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "LYBaseResponseUtil.h"

@interface LYUserCenterUtil : NSObject

+ (instancetype)sharedInstance;

//更新用户和设备信息
- (void)requestUpdateUserAndDeviceInfo:(BOOL)isLogin
                          successBlock:(void (^)(id response))success
                         failtureBlock:(void (^)(NSError *error))failure;

//20180528添加上报设备相关信息
- (void)requestUpdateDeviceLogWithSuccessBlock:(void (^)(id response))success
                                 failtureBlock:(void (^)(NSError *error))failure;
//更新apns token
- (void)requestUpdateAPNSDeviceToken:(NSString *)deviceToken
                          loginState:(BOOL)isLogin
                        successBlock:(void (^)(id response))success
                       failtureBlock:(void (^)(NSError *error))failure;

- (void)requestHomepageData:(NSArray *)tagids
               successBlock:(void (^)(id response))success
              failtureBlock:(void (^)(NSError *error))failure;

//处理扩展配置相关的接口，方便后续扩展
- (void)requestApiExtentionWithSuccessBlock:(void (^)(id response))success
                              failtureBlock:(void (^)(NSError *error))failure;



//验证手机号
- (void)requestValidatePhone:(NSString *)phone
                successBlock:(void (^)(id response))success
               failtureBlock:(void (^)(NSError *error))failure;
//获取绑定手机验证码
-(void)requestBindSendCodeWithPhone:(NSString *)phone type:(NSString *)type
                       successBlock:(void (^)(id response))success
                      failtureBlock:(void (^)(NSError *error))failure;

//绑定手机号码
//v2.5.3版本修改 新增字段confirm_bind; 2.9.8V新增userId对外字段，给非登录态使用
-(void)requestBindPhone:(NSString *)phone
                   code:(NSString *)code
                 userId:(NSString *)userId
            confirmBind:(NSString *)confirm_bind
           successBlock:(void (^)(id response))success
          failtureBlock:(void (^)(NSError *error))failure;

- (void)requestForgetSendCodeWithPhone:(NSString *)phone
                                  type:(NSString *)type
                          successBlock:(void (^)(id response))success
                         failtureBlock:(void (^)(NSError *error))failure;

//忘记密码找回密码过程中验证码验证接口
- (void)requestForgetPwdValidateCodeWithPhone:(NSString *)phone
                                  code:(NSString *)code
                          successBlock:(void (^)(id response))success
                         failtureBlock:(void (^)(NSError *error))failure;

//设置新密码
- (void)requestForgetValidateCodeWithPhone:(NSString *)phone
                                  password:(NSString *)password
                                      code:(NSString *)code
                              successBlock:(void (^)(id response))success
                             failtureBlock:(void (^)(NSError *error))failure;

//密码操作： 1重置类型 1.重置密码（未登录），2设置密码（登陆态）3 修改密码（登陆态）    
- (void)requestResetPwdWithPhone:(NSString *)phone
                                  newPwd:(NSString *)newPwd
                                  oldPwd:(NSString *)oldPwd
                                      type:(NSString *)type
                              successBlock:(void (^)(id response))success
                             failtureBlock:(void (^)(NSError *error))failure;


- (void)requestForgetValidateCodeWithPhone:(NSString *)phone password:(NSString *)password
                                      code:(NSString *)code
                                    userID:(NSString *)userID
                              successBlock:(void (^)(id response))success
                             failtureBlock:(void (^)(NSError *error))failure;

//登录
- (void)requestLoginWithPhone:(NSString *)phone password:(NSString *)password
                 successBlock:(void (^)(id response))success
                failtureBlock:(void (^)(NSError *error))failure;
//登出
- (void)requestLogoutWithSuccessBlock:(void (^)(id response))success
                        failtureBlock:(void (^)(NSError *error))failure;

////第三方登录，identity2目前只提供微信用来appkey迁移使用，代表是上海竞跃下的appkey取到的openid
//- (void)requestThirdAccountRegisterWithType:(LYThirdPartyLoginENUM )type
//               createNewAccoutn:(BOOL)newAccount
//                       identity:(NSString *)identity
//                    newIdentity:(NSString *)identity2
//                       password:(NSString *)password
//                         avatar:(NSString *)avatar
//                       nickname:(NSString *)nickname
//                         gender:(NSString *)gender
//                   successBlock:(void (^)(id response))success
//                  failtureBlock:(void (^)(NSError *error))failure;
//
////神测 signupPage    进入注册页面    1.消息屏，2.我屏-顶部，3.我屏-绑定角色，4.游戏切换，5.其他
//- (void)requestThirdAccountRegisterWithType:(LYThirdPartyLoginENUM )type
//                           createNewAccoutn:(BOOL)newAccount
//                                   identity:(NSString *)identity
//                                newIdentity:(NSString *)identity2
//                                   password:(NSString *)password
//                                     avatar:(NSString *)avatar
//                                   nickname:(NSString *)nickname
//                                     gender:(NSString *)gender
//                                      phone:(NSString *)phone
//                                 verifyCode:(NSString *)verifyCode
//                                confirmBind:(NSString *)confirm_bind
//                                 signupPage:(NSNumber *)signupPage
//                               successBlock:(void (^)(id response))success
//                              failtureBlock:(void (^)(NSError *error))failure;

-(void)requestOneClickLoginWithPhoneToken:(NSString *)phoneToken
                             successBlock:(void (^)(id response))success
                            failtureBlock:(void (^)(NSError *error))failure;

-(void)requestSetUserAccountInfoWithUser:(NSString *)nickname
                                    sex:(NSString *)sex
                               position:(NSString *)position
                                 avatar:(NSString *)avatar
                              auth_type:(NSString *)auth_type
                           successBlock:(void (^)(id response))success
                          failtureBlock:(void (^)(NSError *error))failure;


//2.9.8新的登录注册接口
- (void)requestNewRegisterValidateCodeWithPhone:(NSString *)phone
                                        code:(NSString *)code
                                successBlock:(void (^)(id response))success
                               failtureBlock:(void (^)(NSError *error))failure;

//意见反馈
- (void)requestFeedbackWithContent:(NSString *)content
                         contactUs:(NSString *)contactUs
                          feedFrom:(NSString *)feedFrom
                           avatars:(NSArray *)avatars
                      successBlock:(void (^)(id response))success
                     failtureBlock:(void (^)(NSError *error))failure;

//上传位置
- (void)requestUploadCurrentLocationSuccessBlock:(void (^)(id response))success
                                    failureBlock:(void (^)(NSError *error))failure;

//上传通讯录
- (void)requestUploadPhoneContacts:(NSDictionary *)contacts
                      successBlock:(void (^)(id response))success
                     failtureBlock:(void (^)(NSError *error))failure;
//上传头像
- (void)requestUploadAvatar:(UIImage *)image
               successBlock:(void (^)(id response))success
              failtureBlock:(void (^)(NSError *error))failure;

//上传相册
- (void)requestUploadAlbums:(NSArray <UIImage *>*)images
               successBlock:(void (^)(id response))success
              failtureBlock:(void (^)(NSError *error))failure;

//修改资料
- (void)requestModifyUserProfile:(NSDictionary *)dictParam
                    successBlock:(void (^)(id response))success
                   failtureBlock:(void (^)(NSError *error))failure;
//修改资料 V2
- (void)requestModifyUserProfileV2:(NSDictionary *)dictParam
                      successBlock:(void (^)(id response))success
                     failtureBlock:(void (^)(NSError *error))failure;

//首页搜索,isHistoryWordUsed    是否使用历史词
- (void)requestSearchAllWithContent:(NSString *)content
              withIsHistoryWordUsed:(BOOL)isHistoryWordUsed
                       successBlock:(void (^)(id response))success
                      failtureBlock:(void (^)(NSError *error))failure;

//搜索更多
- (void)requestSearchMoreWithType:(NSNumber *)type
                          content:(NSString *)content
                             page:(NSInteger)page
                     successBlock:(void (^)(id response))success
                    failtureBlock:(void (^)(NSError *error))failure;

//搜索用户
- (void)requestSearchUserWithContent:(NSString *)content
                        successBlock:(void (^)(id response))success
                       failtureBlock:(void (^)(NSError *error))failure;

//举报用户
- (void)requestReportUser:(NSDictionary *)reportDict
                withImage:(UIImage *)image
             successBlock:(void (^)(id response))success
            failtureBlock:(void (^)(NSError *error))failure;

//举报聊天内容
- (void)requestReportChatMessageWithType:(NSInteger)type
                                reportID:(NSString *)rid
                                 content:(NSString*)content
                            successBlock:(void (^)(id response))success
                           failtureBlock:(void (^)(NSError *error))failure;

//获取广告闪屏的数据
- (void)requestSplashInfoWithSuccessBlock:(void (^)(id response))success
                            failtureBlock:(void (^)(NSError *error))failure;

//设置客户端全局APNs开关    NO:不屏蔽        YES: 屏蔽推送
- (void)setClientAPNsEnableAvoid:(BOOL)enableAvoid
                    successBlock:(void (^)(id response))success
                   failtureBlock:(void (^)(NSError *error))failure;

//客户端全局APNs开关
- (void)getClientAPNsSuccessBlock:(void (^)(id response))success
                    failtureBlock:(void (^)(NSError *error))failure;

//前后台切换时，向服务器报告前后台状态，服务器据此状态进行判断是否推送
- (void)setClientBackedState:(NSDictionary *)reportDict
                successBlock:(void (^)(id response))success
               failtureBlock:(void (^)(NSError *error))failure;

//客户端APNs设置
- (void)setClientAPNsSuccessReport:(NSDictionary *)reportDict
                      successBlock:(void (^)(id response))success
                     failtureBlock:(void (^)(NSError *error))failure;

//上报本地APP badge 数目， 使服务端APNs 起始 badge数目与客户端同步
- (void)syncAppBadgeCount:(NSUInteger)appBadgeCount
             successBlock:(void (^)(id response))success
            failtureBlock:(void (^)(NSError *error))failure;

//上传一张图片得到它的原图URL
- (void)requestUploadImage:(UIImage *)image
              successBlock:(void (^)(NSString *imageURL))success
             failtureBlock:(void (^)(NSError *error))failure;

//合并接口（一）
- (void)requestUserResourceCompositionSuccessBlock:(void (^)(id response))success
                                     failtureBlock:(void (^)(NSError *error))failure;
//合并接口（二）
- (void)requestAppResourceCompositionSuccessBlock:(void (^)(id response))success
              failtureBlock:(void (^)(NSError *error))failure;


/**
 v3.0

 @param accountID     手机号或者三方key
 @param idType 1手机 2三方
 @param type 第三方类型
 @param success
 @param failure
 */
- (void)requestGetAccountInfoWithID:(NSString *)accountID withIDType:(NSString *)idType withThirdType:(LYThirdPartyLoginENUM )type  successBlock:(void (^)(id response))success failtureBlock:(void (^)(NSError *error))failure ;


//获取我屏用户数据
+ (void)requestMeUserInfoDataSuccess:(responseBlock)success
                             failure:(requestFailureBlock)failure;

//获取电竞用户id列表
+ (void)requestEsportUsersSuccess:(responseBlock)success
                          failure:(requestFailureBlock)failure;

@end
