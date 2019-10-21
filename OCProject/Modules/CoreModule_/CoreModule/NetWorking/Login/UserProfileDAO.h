//
//  UserProfileDAO.h
//  laoyuegou
//
//  Created by Calvin on 15/4/28.
//  Copyright (c) 2015年 HaiNanLexin. All rights reserved.
//

#import "BaseDAO.h"
#import "LYConfiguration.h"
//#import "LYGameRole.h"
#import "FriendItem.h"
#import "RosterUtil.h"

typedef void(^LYDidFinishStoreUserDataBlock)(void);

@interface UserProfileDAO : BaseDAO

@property (nonatomic,strong) FriendItem *loginUser;

@property (nonatomic,copy) NSString *postionCitCode;
//记录app活动期间用户的最近位置的城市code，方便拉去最近的附近流数据
@property (nonatomic,copy) NSString *postionCityName;
@property (nonatomic,assign) double postionLongitude;
@property (nonatomic,assign) double postionLatitude;

- (void)cleanMob;

- (id)init;

- (void)cleanData:(LYDidFinishStoreUserDataBlock)block;

- (void)updateLoginUserWithItem:(FriendItem *)friendItem;

- (void)updateUserFromData:(NSDictionary *)userDict;

- (void)updateLoginUserBaseProfile:(NSDictionary *)userInfo completeBlock:(ChessMulticastInvokeBlock)completeBlock;

- (void)clearCurrentUser;

@end
