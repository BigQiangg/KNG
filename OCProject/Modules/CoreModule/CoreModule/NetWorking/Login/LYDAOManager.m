//
//  LYDAOManager.m
//  Loyogou
//
//  Created by Calvin on 14/12/31.
//  Copyright (c) 2014年 yuexin. All rights reserved.
//

#import "LYDAOManager.h"
#import "LYLocalConfigurationDao.h"


@implementation LYDAOManager
SYNTHESIZE_SINGLETON(LYDAOManager)
@synthesize userProfileDAO = _userProfileDAO;
@synthesize settingDAO = _settingDAO;
@synthesize blockListDAO = _blockListDAO;
@synthesize timeLineDAO = _timeLineDAO;

@synthesize bufferDAO = _bufferDAO;
@synthesize redDotBusinessDao = _redDotBusinessDao;
@synthesize gameCenterDao = _gameCenterDao;

@synthesize localConfigurationDao = _localConfigurationDao;
@synthesize playGameDAO = _playGameDAO;

@synthesize collectDAO = _collectDAO;
@synthesize playGameAccountDao = _playGameAccountDao;
@synthesize loginBusinessManager = _loginBusinessManager;


- (void)initOnce{
    
}

- (UserProfileDAO *)userProfileDAO{
    if (_userProfileDAO == nil) {
        _userProfileDAO = [[UserProfileDAO alloc] init];
    }
    return _userProfileDAO;
}

- (SettingDAO *)settingDAO{
    if (_settingDAO == nil) {
        _settingDAO = [[SettingDAO alloc] init];
    }
    return _settingDAO;
}

- (BlockListDAO *)blockListDAO{
    if (_blockListDAO == nil) {
        _blockListDAO = [[BlockListDAO alloc] init];
    }
    return _blockListDAO;
}

- (LYTimeLineCache *)timeLineDAO
{
    if (_timeLineDAO == nil) {
        _timeLineDAO = [[LYTimeLineCache alloc] init];
    }
    return _timeLineDAO;
}


- (LYBufferDAO *)bufferDAO
{
    if (!_bufferDAO) {
        _bufferDAO = [LYBufferDAO sharedInstance];
    }
    return _bufferDAO;
}

- (LYRedDotBusinessDao *)redDotBusinessDao
{
    if (_redDotBusinessDao == nil) {
        _redDotBusinessDao = [[LYRedDotBusinessDao alloc] init];
    }
    return _redDotBusinessDao;
}

- (LYGameCenterDAO *)gameCenterDao {
    if (_gameCenterDao == nil) {
        _gameCenterDao = [[LYGameCenterDAO alloc] init];
    }
    return _gameCenterDao;
}

- (LYLocalConfigurationDao *)localConfigurationDao
{
    if (_localConfigurationDao == nil) {
        _localConfigurationDao = [LYLocalConfigurationDao new];
    }
    return _localConfigurationDao;
}

- (LYPlayGameDAO *)playGameDAO
{
    if (!_playGameDAO) {
        _playGameDAO = [LYPlayGameDAO new];
    }
    return _playGameDAO;
}

- (LYCollectFeedDAO *)collectDAO
{
    if (!_collectDAO) {
        _collectDAO = [LYCollectFeedDAO new];
    }
    return _collectDAO;
}

- (LYPlayGameAccountDao *)playGameAccountDao
{
    if (!_playGameAccountDao) {
        _playGameAccountDao = [[LYPlayGameAccountDao alloc] init];
    }
    return _playGameAccountDao;
}

- (LYLoginBusinessManager *)loginBusinessManager
{
    if (!_loginBusinessManager) {
        _loginBusinessManager = [[LYLoginBusinessManager alloc] init];
    }
    return _loginBusinessManager;
}

- (void)clearLoginBusinessManager
{
    _loginBusinessManager = nil;
}

@end
