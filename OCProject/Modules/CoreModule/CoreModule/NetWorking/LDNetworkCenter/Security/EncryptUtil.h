//
//  EncryptUtil.h
//  EasyLoyogou
//
//  Created by LiZ on 15/3/15.
//  Copyright (c) 2015年 LiZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptUtil : NSObject

+ (NSString *)encryptWithText:(NSString *)sText;
+ (NSString *)decryptWithText:(NSString *)sText;
+ (NSMutableString *)urlDecode:(NSString*)str;
+ (NSString *) md5: (NSString *) inPutText;

//sha1
+ (NSString *)sha1:(NSString *)inPutText;

/*
 *  多次测试下来，getFileMD5WithPath比getFileMD5WithPath2执行速度更快一些
 */

//60M,执行350~370ms 之间
+ (NSString *)getFileMD5WithPath:(NSString *)path withSecret:(NSString *)secretKey;

+ (NSString *)getFileMD5WithURL:(NSURL *)url withSecret:(NSString *)secretKey;

//60M,执行450~480ms 之间
+ (NSString *)getFileMD5WithPath2:(NSString *)path withSecret:(NSString *)secretKey;;

@end
