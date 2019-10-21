//
//  LYXOREncryption.h
//  laoyuegou
//
//  Created by smalljun on 17/4/27.
//  Copyright © 2017年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *
 *  参考XOREncryption类，https://ghostbin.com/paste/b7zwm
 *
 */
@interface LYXOREncryption : NSObject

+(NSString *)encryptDecrypt:(NSString *)input withKey:(NSString *)keyStr;

@end
