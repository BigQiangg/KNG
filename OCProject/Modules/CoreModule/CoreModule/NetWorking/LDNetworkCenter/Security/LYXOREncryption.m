//
//  LYXOREncryption.m
//  laoyuegou
//
//  Created by smalljun on 17/4/27.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import "LYXOREncryption.h"

@implementation LYXOREncryption

+(NSString *)encryptDecrypt:(NSString *)input withKey:(NSString *)keyStr
{
//    unichar key[] = {'K', 'C', 'Q'}; //Can be any chars, and any size array
    if (![input length] || ![keyStr length]) {
        return input;
    }
    
    NSInteger length = [keyStr length];
    unichar key[length];
    for(int i = 0; i < length; i++) {
        unichar c = [keyStr characterAtIndex:i];
        key[i] = c;
    }

    NSMutableString *output = [[NSMutableString alloc] init];
    
    for(int i = 0; i < input.length; i++) {
        unichar c = [input characterAtIndex:i];
        c ^= key[i % (sizeof(key)/sizeof(unichar))];
        [output appendString:[NSString stringWithFormat:@"%C", c]];
    }
    
    return output;
}

@end
