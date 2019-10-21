//
//  UserProfileDAO.m
//  laoyuegou
//
//  Created by Calvin on 15/4/28.
//  Copyright (c) 2015年 HaiNanLexin. All rights reserved.
//

#import "UserProfileDAO.h"
#import "HomeIndexUtil.h"

@implementation UserProfileDAO

- (id)init{
    self = [super init];
    if (self != nil) {
        [self load];
    }
    return self;
}

- (void)cleanData:(LYDidFinishStoreUserDataBlock)block
{
    [self clearCurrentUser];
    if (block){
        block ();
    }
}

-(void)store{
  
}

-(void)clean{

}

-(void)dispatchLoad{
    
}

-(void) freeMemory{

}

- (void)cleanMob
{
   
}

- (void)updateUserFromData:(NSDictionary *)userDict
{
    [self updateLoginUserBaseProfile:userDict[@"userinfo"] completeBlock:nil];
    if (userDict) {
        [LYUserConfInfoDao saveUserBaseInfoWithUid:userDict[@"userinfo"][@"user_id"]
                                             token:userDict[@"token"]
                                               pwd:userDict[@"password"]
                                     imAccessToken:userDict[@"access_token"]];
        
        [LYUserConfInfoDao saveUserPersistent:@{
                                                LY_USER_NICKNAME : userDict[@"userinfo"][@"username"]?:@"",
                                                    LY_USER_AVATAR : userDict[@"userinfo"][@"avatar"]?:@"",
                                                }];
    }
    
    //若不存在Config 初始化Config
    [LYUserConfInfoDao readConfigurationFromFile];
}

- (void)updateLoginUserBaseProfile:(NSDictionary *)userInfo completeBlock:(ChessMulticastInvokeBlock)completeBlock
{
    NSError *error = nil;
    FriendItem *friendItem = [MTLJSONAdapter modelOfClass:[FriendItem class] fromJSONDictionary:userInfo error:&error];
    
    [LYUserConfInfoDao saveHasPwd:[userInfo[@"hasPwd"] boolValue]];
    if (!error && friendItem) {
        
        //把登录用户自己更新到好友列表
        [[[RosterUtil sharedInstance] storage] saveMyFriendListItems:@[friendItem] completeBlock:completeBlock];
        [self updateLoginUserWithItem:friendItem];
    } else {
        if (completeBlock) completeBlock(YES,nil);
    }
}

- (void)updateLoginUserWithItem:(FriendItem *)friendItem {
    
    if (friendItem) {
        self.loginUser = friendItem;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:LY_LOGIN_USERINFO_CHANGE_NOTIFICATION object:nil];
        });
    }
}

- (void)clearCurrentUser{
    
    [[LYDAOManager sharedInstance].loginBusinessManager userDidLogout];
    [[LYDAOManager sharedInstance] clearLoginBusinessManager];
    [LYUserConfInfoDao deleteUserBaseInfo];
    [LYUserConfInfoDao clearConfigaruation];
}

- (FriendItem *)loginUser
{
    if (!_loginUser) {
        NSString *uid = [LYUserConfInfoDao queryUserID];
        if ([uid length]) {
            _loginUser = [[[RosterUtil sharedInstance] storage] syncFetchFriendItemWithUserId:uid waitUntil:NO];
        } else {
            _loginUser = nil;
        }
    }

    return _loginUser;
}

@end
