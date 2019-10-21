//
//  NSArray+PlutoHTTPClient.m
//  laoyuegou
//
//  Created by Xiangqi on 2017/4/21.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "NSArray+PlutoHTTPClient.h"
#import "NSString+MD5.h"

@implementation NSArray (PlutoHTTPClient)

- (NSString *)generatePlutoHTTPClientHashSignature
{
    NSString *result = @"";
    NSArray *sortedArray = nil;
    sortedArray = [self sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    for (NSString *str in sortedArray) {
        result = [result stringByAppendingString:str];
        if ([sortedArray lastObject] != str) {
            result = [result stringByAppendingString:@","];
        }
    }
    
    if ([result length]) {
        return [result MD5Digest];
    } else {
        return nil;
    }
}

@end
