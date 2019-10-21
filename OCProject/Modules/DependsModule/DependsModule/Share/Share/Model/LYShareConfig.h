//
//  LYShareConfig.h
//  laoyuegou
//
//  Created by smalljun on 16/4/6.
//  Copyright © 2016年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYShareDefine.h"
//#import "LYShare.h"


@interface LYShareConfig : NSObject

@property (nonatomic,copy) NSString *shareStyle;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *jsParam;

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *url;

@property (nonatomic, copy) NSString *large;
@property (nonatomic, copy) NSString *large_small;

@property (nonatomic, copy) UIImage *largeImage;
@property (nonatomic, copy) UIImage *large_smallImage;

+ (LYShareConfig *)shareConfigWithDict:(NSDictionary *)dict withParams:(NSArray *)params withSuffix:(NSString *)suffix withStylePrefix:(NSString *)prefix;

+ (LYShareConfig *)shareConfigWithGroup:(LYGPlatformType)type url:(NSString *)url;

+ (LYShareConfig *)shareConfigWithGroup:(LYGPlatformType)type shareModel:(LYShare *)shareModel;

+ (LYShareConfig *)shareConfigWithContentDict:(NSDictionary *)dict;

+ (LYShareConfig *)shareConfigWithCDKey:(LYGPlatformType)type content:(NSString *)content;

@end
