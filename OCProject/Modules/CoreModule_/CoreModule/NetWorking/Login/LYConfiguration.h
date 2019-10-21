//
//  LYConfiguration.h
//  laoyuegou
//
//  Created by smalljun on 15/7/21.
//  Copyright (c) 2015年 HaiNanLexin. All rights reserved.
//

#import "MTLModel.h"
#import "MTLJSONAdapter.h"

@interface LYConfiguration : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString * appVersion;    //记录app版本号，用于升级等作用
@property (nonatomic, strong) NSString * pid;           //userid
@property (nonatomic, strong) NSNumber * mainSwitch;    //推送消息全局免打扰开关  0:代表开启APNs， 1:代表 屏蔽APNs
@property (nonatomic, strong) NSNumber * showAnonymous; //推送消息是否匿名显示，即显示“您有一条新消息”
@property (nonatomic, strong) NSNumber * sound;         //开启声音
@property (nonatomic, strong) NSNumber * shaking;       //开启振动

@end
