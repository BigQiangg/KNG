//
//  LYLoginStatusManager.m
//  laoyuegou
//
//  Created by Dombo on 2018/1/29.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import "LYLoginStatusManager.h"


@implementation LYLoginStatusManager

+ (NSString *)keyWithLoginStatePlatfromKey:(LYLoginPlatfromType)platfromType {
    NSString *tag;
    switch (platfromType)
    {
        case LYLoginPlatfrom_Default:
        {
            tag = @"";
            break;
        }
        case LYLoginPlatfrom_Weibo:
        {
            tag = @"WeiXinLoginTag";
            break;
        }
        case LYLoginPlatfrom_WeiXin:
        {
            tag = @"WeiBoLoginTag";
            break;
        }case LYLoginPlatfrom_QQ:{
            tag = @"QQLoginTag";
            break;
        }
    }
    return tag;
}

+ (void)registeredLoginStatePlatfromKey:(LYLoginPlatfromType)platfromType
{
    NSString *tag = [LYLoginStatusManager keyWithLoginStatePlatfromKey:platfromType];
    [[NSUserDefaults standardUserDefaults] setValue:tag forKey:tag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)resetLoginStatePlatfromKey:(LYLoginPlatfromType)platfromType
{
    NSString *tag = [LYLoginStatusManager keyWithLoginStatePlatfromKey:platfromType];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:tag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)loginSuccessfulPlatfromKey:(LYLoginPlatfromType)platfromType {
    NSString *tag = [LYLoginStatusManager keyWithLoginStatePlatfromKey:platfromType];
    if (tag.length >0)
    {
        [LYLoginStatusManager resetLoginStatePlatfromKey:platfromType];
        return NO;
    }
    return YES;
}

+ (void)checkLoginSuccessful {
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        NSString *tipString;
//        if (![LYLoginStatusManager loginSuccessfulPlatfromKey:LYLoginPlatfrom_WeiXin]) {
//            tipString = @"微信授权登录失败";
//            [LYProgressHUD dismiss];
//        }
//        if (![LYLoginStatusManager loginSuccessfulPlatfromKey:LYLoginPlatfrom_Weibo]) {
//            tipString = @"微博授权登录失败";
//            [LYProgressHUD dismiss];
//        }
//        
//        if (tipString.length >0)
//        {
//            [SVProgressHUD showInfoWithStatus:tipString];
//        }
//    });
}
@end
