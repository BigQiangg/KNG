//
//  LYShareUtil.h
//  laoyuegou
//
//  Created by zwq on 2018/10/8.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYShareConfig.h"

@interface LYShareUtil : NSObject

+ (void)registerShareSdks;

+ (void) shareToPlatform:(LYGSharePlatform) platform withObj:(LYShareConfig *) obj;

+ (BOOL) hasInstallPlatform:(LYGSharePlatform) platform;

@end
