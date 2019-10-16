//
//  LYDAOManager.h
//  Loyogou
//
//  Created by Calvin on 14/12/31.
//  Copyright (c) 2014年 yuexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingletonArc.h"
#import "UserProfileDAO.h"
#import "SettingDAO.h"
#import "BlockListDAO.h"
#import "LYTimeLineCache.h"

#import "LYBufferDAO.h"

#import "LYRedDotBusinessDao.h"
#import "LYPlayGameDAO.h"
#import "LYCollectFeedDAO.h"
#import "LYPlayGameAccountDao.h"

#import "LYGameCenterDAO.h"
#import "LYLocalConfigurationDao.h"

typedef  NS_ENUM(NSUInteger , LYTranslatorState){
    LYTranslatorStateNone = 0,
    LYTranslatorStateWorking = 1,
    LYTranslatorStateDone = 2,
};
@interface LYDAOManager : NSObject
SYNTHESIZE_SINGLETON_HEADER(LYDAOManager)

@property (nonatomic,readonly)UserProfileDAO *userProfileDAO;

@property (nonatomic,readonly)SettingDAO *settingDAO;

@property (nonatomic,readonly)BlockListDAO *blockListDAO;

@property (nonatomic,readonly)LYTimeLineCache *timeLineDAO;

@property (nonatomic, readonly) LYBufferDAO *bufferDAO;

@property (nonatomic,readonly) LYRedDotBusinessDao *redDotBusinessDao;

@property (nonatomic,readonly) LYGameCenterDAO *gameCenterDao;

@property (nonatomic,readonly) LYLocalConfigurationDao *localConfigurationDao;

@property (nonatomic,readonly) LYPlayGameDAO *playGameDAO;

@property (nonatomic,readonly) LYCollectFeedDAO *collectDAO;

@property (nonatomic,readonly) LYPlayGameAccountDao *playGameAccountDao;
@property (nonatomic,readonly) LYLoginBusinessManager *loginBusinessManager;

- (void)clearLoginBusinessManager;

@end
