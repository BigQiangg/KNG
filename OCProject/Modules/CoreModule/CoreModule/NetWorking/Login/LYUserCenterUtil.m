//
//  LYUserCenterUtil.m
//  laoyuegou
//
//  Created by LiZ on 16/5/6.
//  Copyright © 2016年 HaiNanLexin. All rights reserved.
//
#import "LYUserCenterUtil.h"

#import "EncryptUtil.h"

#import "ChessOSSClient.h"
#import "ChessOSSPutNormalImage.h"
#import "ChessMapClient.h"
#import "HomeIndexUtil.h"
#import "LYXOREncryption.h"
#import "LYLocationHelper.h"

#import "LYImageFileUploadManager.h"
//#import "LYPlayGameUtil.h"
//#import "LYLocalConfigurationDao.h"
//#import "LYCDNResourcesManager.h"

@implementation LYUserCenterUtil

+ (instancetype)sharedInstance
{
    static LYUserCenterUtil *util = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[LYUserCenterUtil alloc] init];
    });
    return util;
}

- (void)requestUpdateUserAndDeviceInfo:(BOOL)isLogin
                          successBlock:(void (^)(id response))success
                         failtureBlock:(void (^)(NSError *error))failure
{
    NSString *idfa = [NSString idfaString];
    NSString *idfv = [NSString idfvString];
    NSString *idfaString = [EncryptUtil encryptWithText:idfa];
    NSString *idfvString = [EncryptUtil encryptWithText:idfv];
    
    [[NetworkCenter sharedInstance] POSTWithURLPath:isLogin == YES ? @"/setting/extInfo" : @"/loyouser/extInfo"
                                         parameters:@{@"i1":mAvailableString(idfaString),@"i2":mAvailableString(idfvString)}
                                            success:success
                                            failure:failure];
}

//20180528添加上报设备相关信息
- (void)requestUpdateDeviceLogWithSuccessBlock:(void (^)(id response))success
                         failtureBlock:(void (^)(NSError *error))failure
{
    NSDictionary *allParams = [[NetworkCenter sharedInstance] currentDeviceLogInfo];
    NSString *resultJsonStr = [allParams dictTranslateJsonString];
    NSString *resultJsonStrEncryp = [EncryptUtil encryptWithText:resultJsonStr];
    
    /*
    //看解密是否OK
    NSString *decode = [EncryptUtil decryptWithText:resultJsonStrEncryp];
    NSDictionary *decodeParam = [NSDictionary dictionaryWithJsonString:decode];
    */
    
    NSDictionary *resultParams = nil;
    if (resultJsonStrEncryp) {
        resultParams = @{
                         @"allInfo" : resultJsonStrEncryp,
                    };
    }
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/unLogin/iosSysDeviceInfo"
                                         parameters:resultParams
                                            success:success
                                            failure:failure];
}


//更新apns token
- (void)requestUpdateAPNSDeviceToken:(NSString *)deviceToken
                          loginState:(BOOL)isLogin
                        successBlock:(void (^)(id response))success
                       failtureBlock:(void (^)(NSError *error))failure
{
    NSString *urlPath = @"/setting/pushInfo";
    if (!isLogin) {
        urlPath = @"/loyouser/pushInfo";
    }
    
    [[NetworkCenter sharedInstance] POSTWithURLPath:urlPath
                                         parameters:@{@"device_token":deviceToken}
                                            success:success
                                            failure:failure];
}

- (void)requestHomepageData:(NSArray *)tagids
               successBlock:(void (^)(id response))success
              failtureBlock:(void (^)(NSError *error))failure
{
    NSArray *methods = @[
                         @{
                             @"method" : @"misc_cfg",
                             }
                         ];
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/apiList/request"
                                         parameters:@{@"methods":[methods arrayTranslateJsonString]}
                                            success:success
                                            failure:failure];
}

- (void)requestApiExtentionWithSuccessBlock:(void (^)(id response))success
                              failtureBlock:(void (^)(NSError *error))failure
{
    NSArray *methods = @[
                         @{
                             @"method" : @"profile_detail",
                             },
                         @{
                             @"method" : @"score_tip"
                             },
                         @{
                             @"method" : @"upgrade_force",
                             },
                         @{
                             @"method" : @"profile_bindList",
                             },
                         @{
                             @"method" : @"splash_cfg",
                             },
                         ];
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/apiList/requestMore"
                                         parameters:@{@"methods":[methods arrayTranslateJsonString]}
                                            success:success
                                            failure:failure];
}


- (void)requestValidatePhone:(NSString *)phone
                successBlock:(void (^)(id response))success
               failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/loyouser/validatePhone"
                                        parameters:@{@"identity":mAvailableString(phone)}
                                           success:success
                                           failure:failure];
    
}

-(void)requestBindSendCodeWithPhone:(NSString *)phone type:(NSString *)type
                       successBlock:(void (^)(id response))success
                      failtureBlock:(void (^)(NSError *error))failure{
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/loyouser/getBindCode"
                                        parameters:@{@"identity":mAvailableString(phone),@"type":mAvailableString(type)}
                                           success:success
                                           failure:failure];
    
}

-(void)requestOneClickLoginWithPhoneToken:(NSString *)phoneToken
                             successBlock:(void (^)(id response))success
                            failtureBlock:(void (^)(NSError *error))failure{
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/oneClickLogin/login"
                                         parameters:@{@"jverify_token":phoneToken,
                                                      }
                                            success:success
                                            failure:failure];
}

-(void)requestSetUserAccountInfoWithUser:(NSString *)nickname
                                    sex:(NSString *)sex
                               position:(NSString *)position
                                 avatar:(NSString *)avatar
                              auth_type:(NSString *)auth_type
                             successBlock:(void (^)(id response))success
                            failtureBlock:(void (^)(NSError *error))failure{
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/oneClickLogin/updateUserBaseInfo"
                                         parameters:@{@"nickname":nickname,
                                                      @"sex":sex,
                                                      @"position":position,
                                                      @"avatar":avatar,
                                                      @"auth_type":auth_type,
                                                      }
                                            success:success
                                            failure:failure];
}



//v2.5.3版本修改 新增字段confirm_bind; 3.0V新增userId对外字段，给非登录态使用
-(void)requestBindPhone:(NSString *)phone
                  code :(NSString *)code
                userId :(NSString *)userId
            confirmBind:(NSString *)confirm_bind
           successBlock:(void (^)(id response))success
          failtureBlock:(void (^)(NSError *error))failure
{
    NSString *path = @"/profile/bindPhone";
    if (![LYUserConfInfoDao isExistLoginUser]) {
        path = @"/loyouser/bindPhone";
    }
    [[NetworkCenter sharedInstance] GETWithURLPath:path
                                        parameters:@{@"identity":mAvailableString(phone),@"code":mAvailableString(code),@"confirm_bind":confirm_bind,@"user_id":mAvailableString(userId)}
                                           success:success
                                           failure:failure];
    
}

- (void)requestForgetSendCodeWithPhone:(NSString *)phone type:(NSString *)type
                          successBlock:(void (^)(id response))success
                         failtureBlock:(void (^)(NSError *error))failure
{
    NSString *path = @"/loyouser/justSendCode";
    [[NetworkCenter sharedInstance] GETWithURLPath:path
                                        parameters:@{@"identity":mAvailableString(phone),@"type":mAvailableString(type)}
                                           success:success
                                           failure:failure];
}

- (void)requestForgetPwdValidateCodeWithPhone:(NSString *)phone
                                         code:(NSString *)code
                                 successBlock:(void (^)(id response))success
                                failtureBlock:(void (^)(NSError *error))failure
{
    NSString *path = @"/loyouser/validateCode";
    [[NetworkCenter sharedInstance] GETWithURLPath:path
                                        parameters:@{@"identity":mAvailableString(phone),@"code":mAvailableString(code)}
                                           success:success
                                           failure:failure];
}

//密码操作： 1重置类型 1.重置密码（未登录），2设置密码（登陆态）3 修改密码（登陆态）
- (void)requestResetPwdWithPhone:(NSString *)phone
                          newPwd:(NSString *)newPwd
                          oldPwd:(NSString *)oldPwd
                            type:(NSString *)type
                    successBlock:(void (^)(id response))success
                   failtureBlock:(void (^)(NSError *error))failure {
    NSString *path = @"/loyouser/ResetPassword";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:mAvailableString(phone) forKey:@"identity"];
    [params setValue:@([mAvailableString(type) intValue]) forKey:@"type"];
    [params setValue:[EncryptUtil encryptWithText:newPwd] forKey:@"password"];
    if (oldPwd) {
        [params setValue:[EncryptUtil encryptWithText:oldPwd] forKey:@"old_password"];
    }
    
    [[NetworkCenter sharedInstance] GETWithURLPath:path
                                        parameters:params
                                           success:success
                                           failure:failure];
}

- (void)requestForgetValidateCodeWithPhone:(NSString *)phone password:(NSString *)password
                                      code:(NSString *)code
                              successBlock:(void (^)(id response))success
                             failtureBlock:(void (^)(NSError *error))failure
{
    [self requestForgetValidateCodeWithPhone:phone password:password code:code userID:nil successBlock:success failtureBlock:failure];
}

- (void)requestForgetValidateCodeWithPhone:(NSString *)phone password:(NSString *)password
                                      code:(NSString *)code
                                    userID:(NSString *)userID
                              successBlock:(void (^)(id response))success
                             failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/loyouser/forgetValidateCode"
                                        parameters:@{@"identity":mAvailableString(phone),@"password":mAvailableString(password),@"code":mAvailableString(code),@"user_id":mAvailableString(userID)}
                                           success:success
                                           failure:failure];
}


- (void)requestLoginWithPhone:(NSString *)phone password:(NSString *)password
                 successBlock:(void (^)(id response))success
                failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/loyouser/login"
                                        parameters:@{@"identity":mAvailableString(phone),@"password":mAvailableString(password)}
                                           success:success
                                           failure:failure];
}

- (void)requestLogoutWithSuccessBlock:(void (^)(id response))success
                        failtureBlock:(void (^)(NSError *error))failure
{
    [[PlutoHTTPClient sharedInstance] POSTWithURLPath:@"/api/logout"
                                           parameters:nil
                                              success:success
                                              failure:failure];
}

////第三方账号登录接口，newAccount用来区分调用后台不同的接口，为Yes时，如果第三方账号还没注册过，后台会创建新用户，NO时，后台不创建用户，会告诉客户端这是一个还没注册的第三方账号，然后实现不同的业务逻辑
//- (void)requestThirdAccountRegisterWithType:(LYThirdPartyLoginENUM )type
//                           createNewAccoutn:(BOOL)newAccount
//                       identity:(NSString *)identity
//                       newIdentity:(NSString *)identity2
//                       password:(NSString *)password
//                         avatar:(NSString *)avatar
//                       nickname:(NSString *)nickname
//                         gender:(NSString *)gender
//                   successBlock:(void (^)(id response))success
//                  failtureBlock:(void (^)(NSError *error))failure
//{
//    [self requestThirdAccountRegisterWithType:type createNewAccoutn:newAccount identity:identity newIdentity:identity2 password:password avatar:avatar nickname:nickname gender:gender phone:nil verifyCode:nil confirmBind:@"1" signupPage:nil successBlock:success failtureBlock:failure];
//}
//
//- (void)requestThirdAccountRegisterWithType:(LYThirdPartyLoginENUM )type
//                           createNewAccoutn:(BOOL)newAccount
//                                   identity:(NSString *)identity
//                                newIdentity:(NSString *)identity2
//                                   password:(NSString *)password
//                                     avatar:(NSString *)avatar
//                                   nickname:(NSString *)nickname
//                                     gender:(NSString *)gender
//                                      phone:(NSString *)phone
//                                  verifyCode:(NSString *)verifyCode
//                                  confirmBind:(NSString *)confirm_bind
//                                signupPage:(NSNumber *)signupPage
//                               successBlock:(void (^)(id response))success
//                              failtureBlock:(void (^)(NSError *error))failure
//{
//    NSString *typeString;
//    switch (type) {
//        case LYThirdPartyLogin_EMAIL:
//            typeString = @"1";
//            break;
//        case LYThirdPartyLogin_FACEBOOK:
//            typeString = @"2";
//            break;
//        case LYThirdPartyLogin_QQ:
//            typeString = @"3";
//            break;
//        case LYThirdPartyLogin_WEXIN:
//            typeString = @"4";
//            break;
//        case LYThirdPartyLogin_WEIBO:
//            typeString = @"5";
//            break;
//        case LYThirdPartyLogin_XIAOMI:
//            typeString = @"6";
//            break;
//        case LYThirdPartyLogin_TWITTER:
//            typeString = @"7";
//            break;
//        default:
//            break;
//    }
//    
//    [[NetworkCenter sharedInstance] POSTWithURLPath:newAccount?@"/loyouser/loginExt":@"/loyouser/checkUniqueLoginExt"
//                                         parameters:@{@"type":typeString,
//                                                      @"identity":identity,
//                                                      @"new_identity":mAvailableString(identity2),
//                                                      @"password":password,
//                                                      @"avatar":mAvailableString(avatar),
//                                                      @"nickname":mAvailableString(nickname),
//                                                      @"gender":mAvailableString(gender),
//                                                      @"phone":mAvailableString(phone),
//                                                      @"code":mAvailableString(verifyCode),
//                                                      @"confirm_bind":mAvailableString(confirm_bind),
//                                                      @"signupPage":mAvailableString([self titleWithSignupType:signupPage])
//                                                      }
//                                            success:success
//                                            failure:failure];
//}

- (void)requestNewRegisterValidateCodeWithPhone:(NSString *)phone
                                        code:(NSString *)code
                                successBlock:(void (^)(id response))success
                               failtureBlock:(void (^)(NSError *error))failure
{
    NSString *idfa = [NSString idfaString];
    NSString *idfv = [NSString idfvString];
    NSString *idfaString = [EncryptUtil encryptWithText:idfa]?:@"";
    NSString *idfvString = [EncryptUtil encryptWithText:idfv]?:@"";
    
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/loyouser/newLogin" parameters:@{@"phone":mAvailableString(phone),@"password":@"",@"code":mAvailableString(code),@"i1":idfaString,@"i2":idfvString,@"bindId" : @"",@"wishGame" : @"",@"registerUnSupportGameId" : @"",@"signupPage" : @""}
                                           success:success
                                           failure:failure];
}


- (void)requestFeedbackWithContent:(NSString *)content
                         contactUs:(NSString *)contactUs
                          feedFrom:(NSString *)feedFrom
                           avatars:(NSArray *)avatars
                      successBlock:(void (^)(id response))success
                     failtureBlock:(void (^)(NSError *error))failure
{
    if ([avatars count]) { 
        [LYImageFileUploadManager lyImageFileUploadDataArray:avatars
                                                     imgSize:CGSizeMake(1280, 1280)
                                                   issueType:ChessOSSIssueReport_Feedback
                                                  imgPathKey:@"k"
                                                attributeDic:@{@"using_type":@5}
                                                     success:^(NSString *imgArrayJson, NSArray *imgArray)
         {
            [[NetworkCenter sharedInstance] POSTWithURLPath:@"/setting/newFeedBack"
                                                 parameters:@{@"content":mAvailableString(content),
                                                              @"phone":mAvailableString(contactUs),
                                                              @"feed_from":mAvailableString(feedFrom),
                                                              @"pic_arr":mAvailableString(imgArrayJson)}
                                                    success:success
                                                    failure:failure];
        } failure:^(NSError *error)
         {
            NSString *errMsg = @"图片上传失败";
            NSDictionary *info = [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
            NSError *err = [NSError errorWithDomain:@"LYFeedCenterUtilDomain" code:-1 userInfo:info];
            failure(err);
        }];
    } else {
        [[NetworkCenter sharedInstance] POSTWithURLPath:@"/setting/newFeedBack"
                                             parameters:@{@"content":mAvailableString(content),
                                                          @"phone":mAvailableString(contactUs),
                                                          @"feed_from":mAvailableString(feedFrom)}
                                                success:success
                                                failure:failure];
    }
}


- (void)requestUploadCurrentLocationSuccessBlock:(void (^)(id response))success
                                    failureBlock:(void (^)(NSError *error))failure
{
    [self requestUploadCurrentLocationFromAMapSuccessBlock:success failureBlock:failure];
}

//海外封装苹果自带地图
- (void)requestUploadCurrentLocationFromAppleSuccessBlock:(void (^)(id response))success
                                    failureBlock:(void (^)(NSError *error))failure
{
    [[LYLocationHelper sharedInstance] getUserLocation:^(CLLocation *location,NSError *errorLoc) {
        if (location && !errorLoc) {
            
            [[LYLocationHelper sharedInstance] reverseGeocodeCoordinate:location completionHandler:^(NSDictionary *address, NSError *error) {
                if (![address count] || error) {
                    if (failure) failure(error);
                } else {
                    
                    NSString *latitudeAndLongtitude = [NSString stringWithFormat:@"%lf|%lf",location.coordinate.latitude,location.coordinate.longitude];
                    
                    NSString *countryCode = address[@"CountryCode"]?:@"";
                    NSString *country = address[@"Country"]?:@"";
                    NSString *area = address[@"City"]?:@"";
                    NSString *subLocality = address[@"SubLocality"]?:@"";
                    
                    //记录这个变化的城市code，海外版记录的是countryCode
                    [LYDAOManager sharedInstance].userProfileDAO.postionCitCode = countryCode;
                    
                    latitudeAndLongtitude = [latitudeAndLongtitude stringByAppendingFormat:@"|%@|%@|%@|%@", countryCode, country, area, subLocality];
                    [self requestUploadCurrentLocationWithLocationGeocoderString:latitudeAndLongtitude successBlock:success failureBlock:failure];
                }
            }];
        }
    }];
}

//国内封装高德地图
- (void)requestUploadCurrentLocationFromAMapSuccessBlock:(void (^)(id response))success
                                             failureBlock:(void (^)(NSError *error))failure
{
    [[ChessMapClient sharedInstance] requestLocationWithReGeocode:YES
                                                  completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                                                      if (!location) {
                                                          //定位失败
                                                          if (failure) failure(error);
                                                          
                                                          return;
                                                      }
                                                      
                                                      NSString *latitudeAndLongtitude = [NSString stringWithFormat:@"%lf|%lf",location.coordinate.latitude,location.coordinate.longitude];
                                                      
                                                      [LYDAOManager sharedInstance].userProfileDAO.postionLatitude = location.coordinate.latitude;
                                                      [LYDAOManager sharedInstance].userProfileDAO.postionLongitude = location.coordinate.longitude;
                                                      
                                                      if (regeocode) {
                                                          NSString *cityCode = regeocode.citycode;
                                                          NSString *city = regeocode.city;
                                                          NSString *adCode = regeocode.adcode;
                                                          NSString *district = regeocode.district;
                                                          
                                                          //记录这个变化的城市code
                                                          [LYDAOManager sharedInstance].userProfileDAO.postionCitCode = cityCode;
                                                          [LYDAOManager sharedInstance].userProfileDAO.postionCityName = city;
                                                          
                                                          if ([cityCode length] && [city length] && [adCode length] && [district length]) {
                                                              latitudeAndLongtitude = [latitudeAndLongtitude stringByAppendingFormat:@"|%@|%@|%@|%@", cityCode, city, adCode, district];
                                                          }
                                                      }
                                                      
                                                      [self requestUploadCurrentLocationWithLocationGeocoderString:latitudeAndLongtitude successBlock:success failureBlock:failure];
                                                  }];
}

- (void)requestUploadCurrentLocationWithLocationGeocoderString:(NSString *)locationGeocoderString successBlock:(void (^)(id response))success failureBlock:(void (^)(NSError *error))failure
{
    
    //URL Encode
    NSString *latitudeAndLongtitude = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)locationGeocoderString, NULL, CFSTR(":/?#[]@!$&’'()*+,;="), kCFStringEncodingUTF8));
    
    //对位置信息，加密并base64 encode
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSString *timestampStr = [NSString stringWithFormat:@"%lld",(long long)(timestamp *1000)]; //毫秒
    NSString *encrypted = [LYXOREncryption encryptDecrypt:latitudeAndLongtitude withKey:timestampStr];
    
    NSData *basicAuthCredentials = [encrypted dataUsingEncoding:NSUTF8StringEncoding];
    basicAuthCredentials = [basicAuthCredentials base64EncodedDataWithOptions:0];
    NSString *lonAndLatBase64Str = [[NSString alloc] initWithData:basicAuthCredentials encoding:NSUTF8StringEncoding];
    
    [[PlutoHTTPClient sharedInstance] POSTWithURLPath:@"/api/user/sharelocation"
                                           parameters:@{@"pb":lonAndLatBase64Str,
                                                        @"t":timestampStr}
                                              success:success
                                              failure:failure];
}


- (void)requestUploadPhoneContacts:(NSDictionary *)contacts successBlock:(void (^)(id response))success
                     failtureBlock:(void (^)(NSError *error))failure
{
    if ([NSJSONSerialization isValidJSONObject:contacts]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contacts options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [[NetworkCenter sharedInstance] POSTWithURLPath:@"/friend/uploadContacts"
                                             parameters:@{@"contacts":mAvailableString(json)}
                                                success:success
                                                failure:failure];
    }
}

- (void)requestUploadAvatar:(UIImage *)image
               successBlock:(void (^)(id response))success
              failtureBlock:(void (^)(NSError *error))failure
{    
    [LYImageFileUploadManager lyImageFileUploadProgressImage:image
                                                     imgSize:CGSizeMake(640, 640)
                                                attributeDic:@{@"using_type":@4}
                                              uploadProgress:nil
                                                     success:success
                                                     failure:^(NSError *error) {
                                                         failure(error);
                                                     }];
}

- (void)requestUploadAlbums:(NSArray <UIImage *>*)images
               successBlock:(void (^)(id response))success
              failtureBlock:(void (^)(NSError *error))failure
{
    [LYImageFileUploadManager lyImageFileUploadDataArray:images
                                                 imgSize:CGSizeMake(1280, 1280)//CGSizeMake(640, 640)
                                               issueType:ChessOSSIssueAvatar
                                              imgPathKey:@"l"
                                            attributeDic:@{@"using_type":@6}
                                                 success:^(NSString *imgArrayJson, NSArray *imgArray)
     {
         if (success)
         {
             success(imgArray);
         }
     } failure:^(NSError *error) {
         failure(error);
     }];
}

- (void)requestModifyUserProfile:(NSDictionary *)dictParam successBlock:(void (^)(id response))success
                   failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/profile/modify"
                                         parameters:dictParam
                                            success:success
                                            failure:failure];
}
- (void)requestModifyUserProfileV2:(NSDictionary *)dictParam successBlock:(void (^)(id response))success
                   failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/profile/userEdit"
                                        parameters:dictParam
                                           success:success
                                           failure:failure];
}

- (void)requestSearchAllWithContent:(NSString *)content
                        withIsHistoryWordUsed:(BOOL)isHistoryWordUsed
                       successBlock:(void (^)(id response))success
                      failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/search/all"
                                        parameters:@{@"name":mAvailableString(content),@"isHistoryWordUsed":@(isHistoryWordUsed)}//,@"type":@"1"
                                           success:success
                                           failure:failure];
}

- (void)requestSearchMoreWithType:(NSNumber *)type
                          content:(NSString *)content
                             page:(NSInteger)page
                     successBlock:(void (^)(id response))success
                    failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/search/more"
                                        parameters:@{@"name":mAvailableString(content),
                                                     @"page":@(page),@"type":type}
                                           success:success
                                           failure:failure];
}

- (void)requestSearchUserWithContent:(NSString *)content
                        successBlock:(void (^)(id response))success
                       failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/search/user"
                                        parameters:@{@"name":mAvailableString(content)}
                                           success:success
                                           failure:failure];
    
}

- (void)requestReportUser:(NSDictionary *)reportDict
                withImage:(UIImage *)image
             successBlock:(void (^)(id response))success
            failtureBlock:(void (^)(NSError *error))failure
{
    [LYImageFileUploadManager lyImageFileUploadImage:image
                                              imgSize:CGSizeMake(640, 640)
                                            issueType:ChessOSSIssueReport_Feedback
                                           imgPathKey:@"k"
                                        attributeDic:@{@"using_type":@5}
                                              success:^(NSString *imgUrl)
    {
        NSMutableDictionary *mut = [NSMutableDictionary dictionaryWithDictionary:reportDict];
        [mut setValue:imgUrl forKey:@"avatar"];
        [[NetworkCenter sharedInstance] POSTWithURLPath:@"/setting/report"
                                             parameters:mut
                                                success:success
                                                failure:failure];
      }
                                             failure:^(NSError *error)
    {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestReportChatMessageWithType:(NSInteger)type
                                reportID:(NSString *)rid
                                 content:(NSString*)content
                            successBlock:(void (^)(id response))success
                           failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/setting/chatReport"
                                         parameters:@{@"type":@(type),
                                                      @"report_id":mAvailableString(rid),
                                                      @"content":mAvailableString(content)}
                                            success:success
                                            failure:failure];
}

- (void)requestSplashInfoWithSuccessBlock:(void (^)(id response))success
                            failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/unLogin/splash"
                                        parameters:nil
                                           success:success
                                           failure:failure];
}

//设置客户端全局APNs开关
- (void)setClientAPNsEnableAvoid:(BOOL)enableAvoid
                    successBlock:(void (^)(id response))success
                   failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/setting/setNotify"
                                         parameters:@{@"notify": [NSNumber numberWithBool:enableAvoid]}
                                            success:success
                                            failure:failure];
}

//客户端全局APNs开关
- (void)getClientAPNsSuccessBlock:(void (^)(id response))success
                    failtureBlock:(void (^)(NSError *error))failure
{
    [[PlutoHTTPClient sharedInstance] GETWithURLPath:@"api/notify/settings" parameters:nil success:success failure:failure];
}

//客户端APNs设置
- (void)setClientAPNsSuccessReport:(NSDictionary *)reportDict
                      successBlock:(void (^)(id response))success
                     failtureBlock:(void (^)(NSError *error))failure
{
    [[PlutoHTTPClient sharedInstance] POSTWithURLPath:@"api/notify/settings" parameters:reportDict success:success failure:failure];
}

//前后台切换时，向服务器报告前后台状态，服务器据此状态进行判断是否推送
- (void)setClientBackedState:(NSDictionary *)reportDict
                successBlock:(void (^)(id response))success
               failtureBlock:(void (^)(NSError *error))failure{
    [[PlutoHTTPClient sharedInstance] POSTWithURLPath:@"api/notify/backend" parameters:reportDict success:success failure:failure];
}

//上报本地APP badge 数目， 使服务端APNs 起始 badge数目与客户端同步
- (void)syncAppBadgeCount:(NSUInteger)appBadgeCount
             successBlock:(void (^)(id response))success
            failtureBlock:(void (^)(NSError *error))failure
{
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/imApiToken/messagesReceived"
                                         parameters:@{@"count": [NSNumber numberWithUnsignedInteger:appBadgeCount]}
                                            success:success
                                            failure:failure];
}

- (void)requestUploadImage:(UIImage *)image
              successBlock:(void (^)(NSString *imageURL))success
             failtureBlock:(void (^)(NSError *error))failure
{
    [LYImageFileUploadManager lyImageFileUploadImage:image
                                             imgSize:CGSizeMake(640, 640)
                                           issueType:ChessOSSIssueAvatar
                                          imgPathKey:@"k"
                                        attributeDic:@{@"using_type":@6}
                                             success:^(NSString *imgUrl) {
                                                 if (success) {
                                                     success(imgUrl);
                                                 }
                                             }
                                             failure:^(NSError *error) {
                                                 if (failure) {
                                                     failure(error);
                                                 }
                                             }];
}

//合并接口（一）
- (void)requestUserResourceCompositionSuccessBlock:(void (^)(id response))success
                                     failtureBlock:(void (^)(NSError *error))failure
{
    //    合并接口配置参数
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/apiList/userSysConfig"
                                         parameters:nil
                                            success:success
                                            failure:failure];
}

//合并接口（二）
- (void)requestAppResourceCompositionSuccessBlock:(void (^)(id response))success
                                    failtureBlock:(void (^)(NSError *error))failure
{
    NSString *playPriceVer = [[LYDAOManager sharedInstance].playGameDAO allPlayGameConfigObjectForKey:LY_PLAY_GAME_UIIL_DATA_VERSION]?:@"1";
    NSNumber *playStoryVer = (NSNumber *)[[LYDAOManager sharedInstance].playGameDAO allPlayGameConfigObjectForKey:storyVersion]?:@1;
    NSString *gameNameVer = [[[LYDAOManager sharedInstance] localConfigurationDao] readDataVersionString];
//    if (![gameNameVer length]) {
//        [LYCDNResourcesManager saveGameNameCache];
//    }
    NSDictionary *allIconVerDict = [[[LYDAOManager sharedInstance] localConfigurationDao] readImageVersion];
    NSString *allIconVer = @"";
    if (allIconVerDict) {
        allIconVer = [allIconVerDict dictTranslateJsonString];
    } else {
//        [LYCDNResourcesManager saveGameIconsCache];
    }
    NSDictionary *params = @{
                             @"all_icon" : allIconVer?:@"",
                             @"game_name" : gameNameVer,
                             @"play_price" : playPriceVer,
                             @"play_story" : playStoryVer,
                             };
    [[NetworkCenter sharedInstance] POSTWithURLPath:@"/cache/sysConfig"
                                         parameters:params
                                            success:success
                                            failure:failure];
}

- (void)requestGetAccountInfoWithID:(NSString *)accountID withIDType:(NSString *)idType withThirdType:(LYThirdPartyLoginENUM )type  successBlock:(void (^)(id response))success failtureBlock:(void (^)(NSError *error))failure {
    
    NSDictionary *params = @{
                             @"identity" : mAvailableString(accountID),
                             @"id_type" : mAvailableString(idType),
                             @"third_Type" : @(type),
                             };
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/loyouser/getAccountInfo"
                                        parameters:params
                                           success:success
                                           failure:failure];
}

- (NSString *)titleWithSignupType:(NSNumber *)type {
    NSString *title = @"其他";
    
//    LYSignupComeFromMessageHomePage = 1,             //消息屏
//    LYSignupComeFromMePageTop = 2,                           //2.我屏-顶部
//    LYSignupComeFromMePageBindRole = 3,                           //3.我屏-绑定角色
//    LYSignupComeFromSwitchGame = 4,                           //4.游戏切换
//    LYSignupComeFromOther = 5,                           //5.其他
    switch (type.integerValue) {
        case LYSignupComeFromMessageHomePage:
            title = @"消息屏";
            break;
        case LYSignupComeFromMePageTop:
            title = @"我屏-顶部";
            break;
        case LYSignupComeFromMePageBindRole:
            title = @"我屏-绑定角色";
            break;
        case LYSignupComeFromSwitchGame:
            title = @"游戏切换";
            break;
        case LYSignupComeFromOther:
            title = @"其他";
            break;
        default:
            title = @"其他";
            break;
    }
    return title;
}


//获取我屏用户数据
+ (void)requestMeUserInfoDataSuccess:(responseBlock)success
                             failure:(requestFailureBlock)failure {
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:[LYUserConfInfoDao queryUserID] forKey:@"user_id"];
    [dict setValue:[LYUserConfInfoDao queryUserID] forKey:@"query_user_id"];
    [dict setValue:[version idStringValue] forKey:@"appver"];
    
    [[NetworkCenter sharedInstance] GETWithURLPath:@"/unLogin/newUserInfo"
                                        parameters:dict
                                           success:success
                                           failure:failure];
}

//获取电竞用户id列表
+ (void)requestEsportUsersSuccess:(responseBlock)success
                             failure:(requestFailureBlock)failure {
    [[PHPNetworkCenter sharedInstance] GETWithURLPath:@"/account/dianjingusers"
                                        parameters:nil
                                           success:success
                                           failure:failure];
}


@end
