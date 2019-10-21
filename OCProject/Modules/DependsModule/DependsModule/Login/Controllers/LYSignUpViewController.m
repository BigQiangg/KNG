//
//  LYSignUpViewController.m
//  laoyuegou
//
//  Created by smalljun on 2018/1/9.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import "LYSignUpViewController.h"

#import "LYNewLoginView.h"
#import "LYLoginPwdView.h"
#import "LYLoginCodeView.h"
#import "LYMobilePhoneLoginView.h"
#import <CoreModule/LYBase.h>

//#import <LDYYText/YYLabel.h>
//#import <LDYYText/NSAttributedString+YYText.h>
//#import "LYWebViewController.h"
//#import "LYSelectNationViewController.h"
//#import "LYFindThirdAccountViewController.h"
//#import "LYForgePwdViewController.h"
//#import "LYStoryboardManager.h"
//#import "LYUserCenterUtil.h"
//#import "LYWebUserAgentHelper.h"
//#import "EncryptUtil.h"
//#import "LYThirdAccoutLogicModel.h"
//
//#import "LYQQPlatformManager.h"
//#import "LYWXPlatformManager.h"


#define LYWechatAuthLoadingTime 4
@interface LYSignUpViewController () <CAAnimationDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labTip;
@property (strong,nonatomic) UIView *bgView;
@property (strong,nonatomic) LYNewLoginView *newLoginView;
@property (strong,nonatomic) LYLoginPwdView *loginPwdView;
@property (strong,nonatomic) LYLoginCodeView *loginCodeView;
@property (strong,nonatomic) LYMobilePhoneLoginView *mobilePhoneView;


//是否是来自登录的第一步
@property (assign, nonatomic) BOOL loginFirstStep;
//1手机号输入页面/2密码输入页面/3验证码输入页面 0 一键登录
@property (assign, nonatomic) int loginStatus;
@property (weak, nonatomic) IBOutlet UIView *labBg;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBg;
@property (copy, nonatomic) NSString *subtype;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBgConstraintBottom;
@property (assign, nonatomic) BOOL verifyCodeSyncing;

@end

@implementation LYSignUpViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [LYProgressHUD dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 0;
    shadow.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    shadow.shadowOffset =CGSizeMake(0,1);
    
//    NSAttributedString *attrString = [NSString getAttributedStringWithString:@"如遇到登录问题请加官方QQ群 205623917" lineSpace:4 withAttributeDict:@{NSFontAttributeName:LY_FONT_24,NSForegroundColorAttributeName:[UIColor whiteColor],NSShadowAttributeName: shadow}];
//    self.labTip.attributedText = attrString;
//
//    [LYThirdAccoutLogicModel setupJVERIFICATIONService];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg_line"]];
    
    [self.view addSubview:self.bgView];
    self.labBg.alpha = 0.3;
    self.labBg.layer.cornerRadius = 9;
    if (iPhone5 || iPhone4S) {
        self.imageViewBg.image = [UIImage imageNamed:@"login_bottom_image"];
    }
    if (iPhoneX) {
        self.imageViewBgConstraintBottom.constant = LY_IPHONE_BOTTOM_HEIGHT + 10;
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];

    self.subtype = kCATransitionFromRight;
    self.loginStatus = 1;
    self.canPopGR = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    [self.bgView addSubview:self.loginCodeView];
    [self.bgView addSubview:self.loginPwdView];
    [self.bgView addSubview:self.newLoginView];
//    [self.bgView addSubview:self.mobilePhoneView];
    
    self.loginPwdView.hidden = YES;
    self.loginCodeView.hidden = YES;
//    self.newLoginView.hidden = YES;
//    self.mobilePhoneView.hidden = NO;
    
    CGFloat height = mScreenHeight;
    WeakSelf(ws);
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@(0));
        make.width.mas_equalTo(ws.view);
        make.height.mas_equalTo(ws.view);
    }];
    [self.loginCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@(10));
        make.width.mas_equalTo(ws.view);
        make.height.equalTo(@(height));
    }];
    [self.loginPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@(10));
        make.width.mas_equalTo(ws.view);
        make.height.equalTo(@(height));
    }];
    [self.newLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@(10));
        make.width.mas_equalTo(ws.view);
        make.height.equalTo(@(height));
    }];
    
//    [self.mobilePhoneView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@0);
//        make.top.equalTo(@(10));
//        make.width.mas_equalTo(ws.view);
//        make.height.equalTo(@(height));
//    }];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.bgView addGestureRecognizer:swipeGesture];
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    [self.bgView addGestureRecognizer:swipeGesture];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    tap.delegate = self;
    [self.bgView addGestureRecognizer:tap];
    

//    [LYAnalyticsManager event:LYSENSORS_EVENT_LIVE_INSIGNUPF1
//               withProperties:nil];
}

#pragma mark - keyBoard button action

- (void)gestureAction:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)enterAgreementCenter {
    LYWebViewController *webVC =  [[LYWebViewController alloc] initWithTitle:@"用户协议" url:[LYURLLoader urlTransformation:LY_H5_AGREEMENT withParams:nil]];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)enterPriCenter {
    LYWebViewController *webVC =  [[LYWebViewController alloc] initWithTitle:@"隐私协议" url:[LYURLLoader urlTransformation:LY_H5_PRIACY_HELPER withParams:nil]];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)enterNationCodeCenter {
    WeakSelf(ws);
    UIViewController *vc = [LYStoryboardManager selectNationViewController];
    LYSelectNationViewController *selectNationVC = [(UINavigationController *)vc viewControllers][0];
    selectNationVC.block = ^(NSString *string){
        NSLog(@"nation code == %@",string);
        ws.newLoginView.nationCode = string;
    };
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)findThirdAccount {
    
    WeakSelf(ws);
    [LYAlertViewHelper showAlertAtController:self title:@"登录账号更改通知" subTitle:@"即日起，手机号将作为唯一登录账号，同时取消第三方登录。如您已经绑定手机号，请使用手机号进行登录；如尚未绑定，请立即进行绑定。" confirmTitle:@"我知道了" confirmBlock:^{
        LYFindThirdAccountViewController *findThirdAccountVC = [[LYFindThirdAccountViewController alloc] init];
        findThirdAccountVC.block = ^(NSString *nationCode, NSString *phone,NSString *pwd,BOOL isLogin) {

            //只有存在nationCode被单独拆分出来有值的时候才自动填充
            if ([nationCode length]) {
                ws.newLoginView.nationCode = nationCode;
                if ([phone length]) {
                    ws.newLoginView.phone = phone;
                }
            }
        };
        [ws.navigationController pushViewController:findThirdAccountVC animated:YES];
    }];
}

- (void)enterForgetPwd {
    LYForgePwdViewController *forgetPwdVC =  [[LYForgePwdViewController alloc] init];
    forgetPwdVC.nationCode = self.newLoginView.nationCode;
    forgetPwdVC.phone = self.newLoginView.currentPhone;
    [self.navigationController pushViewController:forgetPwdVC animated:YES];
}

- (void)pushFindThirdAccountViewController:(BOOL)isSkip
{
    LYFindThirdAccountViewController *findThirdAccountVC = [[LYFindThirdAccountViewController alloc] init];
    findThirdAccountVC.isEditor = YES;
    findThirdAccountVC.isSkip = isSkip;
    findThirdAccountVC.editorBlock = ^{
         [[NSNotificationCenter defaultCenter] postNotificationName:LY_LOGIN_CHANGE_NOTIFICATION object:@YES];
    };
    [self.navigationController pushViewController:findThirdAccountVC animated:YES];
}


- (void)oneClickLoginClickAction {
    [LYProgressHUD showAnimationWithMaskType:LYProgressHUDHUDMaskTypeClear];
//    [LYAnalyticsManager event:LYSENSORS_EVENT_LIVE_INSIGNUPF2
//               withProperties:@{
//                                @"clickMode":@"本机号码一键登录"
//                                }];
    [LYThirdAccoutLogicModel setNavigationBarJVERIFICATIONServiceisSpecial:YES];
    WeakSelf(ws);
    [LYThirdAccoutLogicModel pushJVERIFICATIONServiceController:self SuccessBlock:^(NSDictionary *result) {
        [LYThirdAccoutLogicModel setNavigationBarJVERIFICATIONServiceisSpecial:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result[@"code"] intValue] == 6000) {
                [ws requestOneClickLoginWithPhoneToken:result[@"loginToken"]];
            }
            else if ([result[@"code"] intValue] == 6002) {
                
            }
            else
            {
                
#if  (BUILD_EVO == 1 || BUILD_EVO == 3)
                [LYProgressHUD showWithText:[NSString stringWithFormat:@"一键登录异常%@-%@",result[@"code"],result[@"code"]]];
#else
               [LYProgressHUD showWithText:@"一键登录异常，请使用手机验证码登录"];
#endif
                
            }
        });
    }];
}

#pragma mark netwrok interface


-(void)requestOneClickLoginWithPhoneToken:(NSString *)phoneToken {
    [LYProgressHUD showAnimationWithMaskType:LYProgressHUDHUDMaskTypeClear];
    WeakSelf(ws);
    [[LYUserCenterUtil sharedInstance] requestOneClickLoginWithPhoneToken:mAvailableString(phoneToken) successBlock:^(id response) {
        [LYProgressHUD dismiss];
        NSDictionary *profile = response[@"data"];
        if ([[profile allKeys] containsObject:@"userinfo"]) {
            [ws updateOneClickLoginWithData:response];
        }
    } failtureBlock:^(NSError *error) {
        NSString *errMsg = error.localizedDescription;
        if (error.code == -6600) {
            [LYProgressHUD dismiss];
            [LYAlertViewHelper showAlertAtController:self title:@"账号异常" subTitle:mAvailableString(errMsg) confirmTitle:@"确认" confirmBlock:^{
                
            }];
        } else {
            [LYProgressHUD showWithText:errMsg];
        }
    }];
}

- (void)updateOneClickLoginWithData:(NSDictionary *)response
{
    BOOL isPlatform = [LYQQPlatformManager isInstalled] || [LYWXPlatformManager isInstalled];
    
    NSDictionary *profile = response[@"data"];
    [LYUserConfInfoDao saveUserPersistent:@{
                                            LY_USER_PHONE_CODE : @"+86",
                                            LY_USER_PHONE : mAvailableString(profile[@"userinfo"][@"unique_phone"]),
                                            }];
    NSInteger first = [profile[@"first"] intValue];
    if (isPlatform && first == 1) {
        first= [profile[@"is_show_auth_page"] intValue];
        if (first == 1) {
            [self pushFindThirdAccountViewController:[profile[@"is_show_skip_button"] intValue]];
            [[LYDAOManager sharedInstance].userProfileDAO updateUserFromData:profile];
            [LYWebUserAgentHelper updateWebUserAgent];
            return;
        }
    }
    [self saveLoginInfo:response registerStatus:NO];
}


-(void)requestGetAccountInfoWithNationcode:(NSString *)nationCode phone:(NSString *)phone {
    
    [LYProgressHUD showAnimationWithMaskType:LYProgressHUDHUDMaskTypeClear];
    [[LYUserCenterUtil sharedInstance] requestGetAccountInfoWithID:[NSString stringWithFormat:@"%@%@",nationCode,phone] withIDType:@"1" withThirdType:LYThirdPartyLogin_PHONE successBlock:^(id response) {

        [LYProgressHUD dismiss];
        NSDictionary *profile = response[@"data"];
        [self handleAccountTypeWithInfo:profile nationCode:nationCode phone:phone isRegister:NO];
    } failtureBlock:^(NSError *error) {
        NSString *errMsg = error.localizedDescription;
        if (error.code == -6600) {
            [LYProgressHUD dismiss];
            [LYAlertViewHelper showAlertAtController:self title:@"账号异常" subTitle:mAvailableString(errMsg) confirmTitle:@"确认" confirmBlock:^{
                
            }];
        } else {
            [LYProgressHUD showWithText:errMsg];
        }
    }];
    [LYAnalyticsManager event:LYSENSORS_EVENT_INSIGNUP_ONE
               withProperties:nil];
}

- (void)requestLoginAccountWithNationCode:(NSString *)nationCode phone:(NSString *)phone password:(NSString *)pwd {
    [self.view endEditing:YES];
    [LYProgressHUD showAnimationWithMaskType:LYProgressHUDHUDMaskTypeClear];
    [[LYUserCenterUtil sharedInstance] requestLoginWithPhone:[NSString stringWithFormat:@"%@%@",nationCode,phone]
                                                    password:[EncryptUtil encryptWithText:pwd]
                                                successBlock:^(id response)
     {
         [LYProgressHUD dismiss];
         NSDictionary *profile = response[@"data"];
         if ([[profile allKeys] containsObject:@"userinfo"]) {
             [LYUserConfInfoDao saveUserPersistent:@{
                                                     LY_USER_PHONE_CODE : nationCode,
                                                     LY_USER_PHONE : phone,
                                                     }];
             
             
             [self saveLoginInfo:response registerStatus:NO];
         }
     } failtureBlock:^(NSError *error) {
         
         NSString *errMsg = error.localizedDescription;
         [LYProgressHUD showWithText:errMsg];
     }];
}

- (void)requestLoginAccountWithNationCode:(NSString *)nationCode phone:(NSString *)phone verifyCode:(NSString *)code {
    [self.view endEditing:YES];
    
    NSLog(@"code == %@",code);
    
    //iOS12短信自动填充完，textFieldDidChange会执行两次，通过这个来规避
    if (!self.verifyCodeSyncing) {
        self.verifyCodeSyncing = YES;
        WeakSelf(ws);
        [LYProgressHUD showAnimationWithMaskType:LYProgressHUDHUDMaskTypeClear];
        [[LYUserCenterUtil sharedInstance] requestNewRegisterValidateCodeWithPhone:[NSString stringWithFormat:@"%@%@",nationCode,phone] code:code successBlock:^(id response) {
            self.verifyCodeSyncing = NO;
            [LYProgressHUD dismiss];
            NSDictionary *profile = response[@"data"];
            if ([[profile allKeys] containsObject:@"userinfo"]) {
                [ws updateOneClickLoginWithData:response];
            }
         
        } failtureBlock:^(NSError *error) {
            self.verifyCodeSyncing = NO;
            
            //code为kLYNetworkCodeUserActionForbid时，NetworkCenter底层会处理统一弹出错误提示，避免两次重复弹框
            if (error.code == kLYNetworkCodeUserActionForbid){
                [LYProgressHUD dismiss];
            } else {
                NSString *errMsg = error.localizedDescription;
                [LYProgressHUD showWithText:errMsg];
                if (error.code == -6) {
                    [self.loginCodeView clearAllText:YES];
                }
            }
        }];
    }
}

- (void)requestSendCodeWithType:(NSInteger)type {
    NSString *phone = [NSString stringWithFormat:@"%@%@",self.newLoginView.nationCode,self.newLoginView.currentPhone];
    NSString *tip = type?@"正在为您发送语音验证码，请稍候":@"验证码发送成功，请查收";
    
    [LYProgressHUD showAnimationWithMaskType:LYProgressHUDHUDMaskTypeClear];

    [[LYUserCenterUtil sharedInstance] requestBindSendCodeWithPhone:phone type:[NSString stringWithFormat:@"%ld",type] successBlock:^(id response) {
        [LYProgressHUD dismiss];
        [SVProgressHUD showImage:nil status:tip maskType:SVProgressHUDMaskTypeBlack];
    } failtureBlock:^(NSError *error) {
        [LYProgressHUD dismiss];
        [SVProgressHUD showImage:nil status:error.localizedDescription];
    }];
}

- (void)handleAccountTypeWithInfo:(NSDictionary *)dict nationCode:(NSString *)nationCode phone:(NSString *)phone isRegister:(BOOL)isRegister {
    
    LYGAccountType accountType = [dict[@"use_type"] integerValue];
    //有绑定有密码就去登陆密码页面
    if (accountType == LYGAccountTypePhoneBindAndHasPwd) {
        
        NSLog(@"去密码登陆页面");
        self.loginFirstStep = YES;
        self.loginStatus = 2;
        self.subtype = kCATransitionFromRight;
        [self switchSceneAnimation:YES];
    } else {
        NSLog(@"去验证码登陆页面");
        self.loginFirstStep = YES;
        self.loginStatus = 3;
        self.subtype = kCATransitionFromRight;
        [self switchSceneAnimation:YES];
    }
}

- (void)saveLoginInfo:(NSDictionary *)infoDict registerStatus:(BOOL)registerStatus {
    NSDictionary *profile = infoDict[@"data"];
    [[LYDAOManager sharedInstance].userProfileDAO updateUserFromData:profile];
    [LYWebUserAgentHelper updateWebUserAgent];
    if (!registerStatus) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LY_LOGIN_SUCCESS_NOTIFICATION object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:LY_LOGIN_CHANGE_NOTIFICATION object:@YES];
}

//登录注册场景切换
- (void)switchSceneAnimation:(BOOL)animation {
    [self.view endEditing:YES];
    
    CATransition *animationObj = [CATransition animation];
    animationObj.delegate = self;
    [animationObj setDuration:0.2f];
    [animationObj setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    /*动画效果
     kCATransitionPush推出|kCATransitionReveal底部显出来
     */
    [animationObj setType:kCATransitionPush];
    
    [animationObj setSubtype:self.subtype];
    
    NSUInteger index1 = [[self.bgView subviews] count] - 1;
    NSUInteger index2 = [[self.bgView subviews] indexOfObject:self.newLoginView];
    if (self.loginStatus == 1) {
        [LYAnalyticsManager event:LYSENSORS_EVENT_INSIGNUPNEW
                   withProperties:@{
                                    @"signupPage":@"进入注册/登录页面"
                                    }];
//        [LYAnalyticsManager event:LYSENSORS_EVENT_LIVE_INSIGNUPF2
//                   withProperties:@{
//                                    @"clickMode":@"手机验证登录"
//                                    }];
        index2 = [[self.bgView subviews] indexOfObject:self.newLoginView];
    } else if (self.loginStatus == 2) {
        index2 = [[self.bgView subviews] indexOfObject:self.loginPwdView];
    } else if (self.loginStatus == 3) {
        index2 = [[self.bgView subviews] indexOfObject:self.loginCodeView];
    }
//    else if (self.loginStatus == 0) {
//        index2 = [[self.bgView subviews] indexOfObject:self.mobilePhoneView];
//    }
    
    [self.bgView exchangeSubviewAtIndex:index1 withSubviewAtIndex:index2];
    [self.bgView.layer addAnimation:animationObj forKey:@"Reveal"];
}

#pragma mark CAAnimation Delegate

- (void)animationDidStart:(CAAnimation *)anim {
    
    if (self.loginStatus == 1) {
        self.newLoginView.hidden = NO;
        self.loginPwdView.hidden = YES;
        self.loginCodeView.hidden = YES;
        self.mobilePhoneView.hidden = YES;
    } else if (self.loginStatus == 2) {
        self.newLoginView.hidden = YES;
        self.loginPwdView.hidden = NO;
        self.loginCodeView.hidden = YES;
        self.mobilePhoneView.hidden = YES;
    } else if (self.loginStatus == 3) {
        self.newLoginView.hidden = YES;
        self.loginPwdView.hidden = YES;
        self.loginCodeView.hidden = NO;
        self.mobilePhoneView.hidden = YES;
        
        [self requestSendCodeWithType:0];
    }
//    else if (self.loginStatus == 0) {
//        self.newLoginView.hidden = YES;
//        self.loginPwdView.hidden = YES;
//        self.loginCodeView.hidden = YES;
//        self.mobilePhoneView.hidden = NO;
//    }
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (self.loginStatus == 2) {
        [self.loginPwdView becomeFirstResponder];
    } else if (self.loginStatus == 3) {
        [self.loginCodeView becomeFirstResponder];
    }
}

#pragma mark - subviews getters

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (LYNewLoginView *)newLoginView {
    if (!_newLoginView) {
        _newLoginView = [[[NSBundle mainBundle] loadNibNamed:@"LYNewLoginView" owner:nil options:nil] firstObject];
        
        NSDictionary *dict = [LYUserConfInfoDao queryUserPersistent];
        _newLoginView.nationCode = dict[LY_USER_PHONE_CODE]?:@"+86";
        _newLoginView.phone =  dict[LY_USER_PHONE]?:@"";
        
        WeakSelf(ws);
        _newLoginView.openWebViewBlock = ^(NSString *urlString) {
            LYWebViewController *webVC =  [[LYWebViewController alloc] initWithTitle:@"用户协议" url:[LYURLLoader urlTransformation:urlString withParams:nil]];
            [ws.navigationController pushViewController:webVC animated:YES];
        };
        _newLoginView.codeBlock = ^{
            [ws enterNationCodeCenter];
        };
        _newLoginView.findThirdAccountBlock = ^{
            [ws findThirdAccount];
        };
        _newLoginView.nextBlock = ^(NSString *nationCode, NSString *phone) {
            [ws requestGetAccountInfoWithNationcode:nationCode phone:phone];
        };
        
//        _newLoginView.backBlock = ^{
//            ws.loginStatus = 0;
//            ws.subtype = kCATransitionFromLeft;
//            [ws switchSceneAnimation:YES];
//        };
    }
    
    return _newLoginView;
}

- (LYLoginPwdView *)loginPwdView {
    if (!_loginPwdView) {
        _loginPwdView = [[[NSBundle mainBundle] loadNibNamed:@"LYLoginPwdView" owner:nil options:nil] firstObject];
        
        WeakSelf(ws);
        _loginPwdView.backBlock = ^{
            ws.loginStatus = 1;
            ws.subtype = kCATransitionFromLeft;
            [ws switchSceneAnimation:YES];
        };
        _loginPwdView.pwdBlock = ^(NSString * _Nonnull pwd) {
            
            [ws requestLoginAccountWithNationCode:ws.newLoginView.nationCode phone:ws.newLoginView.currentPhone password:pwd];
        };
        _loginPwdView.voiceCodeBlock = ^{
            ws.loginStatus = 3;
            ws.loginFirstStep = NO;
            ws.subtype = kCATransitionFromRight;
            [ws switchSceneAnimation:YES];
        };
        _loginPwdView.forgetPwdBlock= ^{
            [ws enterForgetPwd];
        };
    }
    
    return _loginPwdView;
}

- (LYLoginCodeView *)loginCodeView {
    if (!_loginCodeView) {
        _loginCodeView = [[[NSBundle mainBundle] loadNibNamed:@"LYLoginCodeView" owner:nil options:nil] firstObject];
        
        WeakSelf(ws);
        _loginCodeView.backBlock = ^{
            
            //如果是来自第一步跳转进入验证码，则直接回登录手机号输入首页，否则会输入密码页面
            if (ws.loginFirstStep) {
                ws.loginStatus = 1;
            } else {
                ws.loginStatus = 2;
            }
            
            ws.subtype = kCATransitionFromLeft;
            [ws switchSceneAnimation:YES];
        };
        _loginCodeView.codeBlock = ^(NSString * _Nonnull code) {
            [ws requestLoginAccountWithNationCode:ws.newLoginView.nationCode phone:ws.newLoginView.currentPhone verifyCode:code];
        };
        _loginCodeView.voiceCodeBlock = ^{
            [ws requestSendCodeWithType:1];
        };
    }
    
    return _loginCodeView;
}


//- (LYMobilePhoneLoginView *)mobilePhoneView {
//    if (!_mobilePhoneView) {
//        _mobilePhoneView = [[[NSBundle mainBundle] loadNibNamed:@"LYMobilePhoneLoginView" owner:nil options:nil] firstObject];
//        WeakSelf(ws);
//        _mobilePhoneView.codeBlock = ^{
//            ws.loginStatus = 1;
//            ws.subtype = kCATransitionFromRight;
//            [ws switchSceneAnimation:YES];
//        };
//        _mobilePhoneView.findThirdAccountBlock = ^{
//            [ws findThirdAccount];
//        };
//        _mobilePhoneView.nextBlock = ^{
//            [ws oneClickLoginClickAction];
//        };
//
//    }
//    return _mobilePhoneView;
//}

- (NSString *)currentpageName {
    return self.loginStatus?@"登录":@"注册";
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch {
    UIView *view = touch.view;
    if ([view isKindOfClass:[YYLabel class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)hiddenNav {
    return YES;
}

@end
