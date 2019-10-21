//
//  LYShare.h
//  laoyuegou
//
//  Created by smalljun on 16/1/21.
//  Copyright © 2016年 HaiNanLexin. All rights reserved.
//

#import <CoreModule/MTLModel.h>
#import "LYShareDefine.h"
#import "FriendItem.h"

@interface LYShare : MTLModel

//0默认，1基于动态发表的动态，2基于话题分享发表的动态，3基于h5发表的动态，5基于h5原生发表的动态
@property (nonatomic,copy) NSNumber *type;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *picUrl;
@property (nonatomic,copy) NSString *ext;       //ext会type类型不同，代表不同意义

@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic,copy) NSString *sinaPicUrl;
@property (nonatomic,copy) NSString *platform;
@property (nonatomic,copy) NSString *shareType;
@property (nonatomic,copy) NSString *shareID;

@property (nonatomic, copy) NSString *large; // 分享图片
@property (nonatomic, copy) NSString *large_small; // 分享图片小图

@property (nonatomic, strong) UIImage *largeShareImage; // 分享图片大图
@property (nonatomic, strong) UIImage *smallShareImage; // 分享图片小图
@property (nonatomic, assign) BOOL isLandScape; //是否横屏

@property(nonatomic, copy) NSString *filePath; // RN 分享图片传递的图片沙盒地址。
@property(nonatomic, copy) ShareOptBlock optBlock; // 分享面板上的举报拉黑
@property(nonatomic, strong) NSDictionary * optDic; //key:value 存储举报拉黑状态 YES：操作，NO：取消

@property(nonatomic, strong) FriendItem * userInfo;//分享的用户
@property (nonatomic,copy) NSString *roomId;//房间id lcb wedding
@property(nonatomic, strong) NSArray <FriendItem *> *userInfos;//婚礼用户 lcb wedding
@property (nonatomic, copy) NSAttributedString *attributeContent;

@property (nonatomic, copy) NSString *shareFor;// 内容、角色详情页、人、群、直播间、1v1分享、用户主页、用户技能、聊天室、帖子、结婚
- (void)replaceContent:(NSString *)content;
- (NSString *)jsonFromDict;

@end
