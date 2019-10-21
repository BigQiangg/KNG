//
//  LYConfiguration.m
//  laoyuegou
//
//  Created by smalljun on 15/7/21.
//  Copyright (c) 2015年 HaiNanLexin. All rights reserved.
//

#import "LYConfiguration.h"

@implementation LYConfiguration

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"pid" : @"pid",
             @"mainSwitch": @"mainSwitch",
             @"showAnonymous":@"showAnonymous",
             @"sound":@"sound",
             @"shaking":@"shaking",
             @"appVersion":@"appVersion",
             };
}

@end
