//
//  NetworkHelper.m
//  laoyuegou
//
//  Created by SmallJun on 2019/7/11.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import "NetworkHelper.h"
#import "SAMKeychain.h"
#import "NSString+LYDeviceID.h"

//本地生成的uuid
#define UUID_KEYCHAIN_KEY @"laoyuegouuuid1122"
#define LY_KEYCHAIN_UUID @"com.laoyuegou.app.uuid"

@implementation NetworkHelper

#pragma mark - 保存和读取UUID,防止idfa为空的情况作为辅助设备id用

static NSString *uuidString = nil;

+(void)saveUUIDToKeyChain
{
    NSString *uuid = [SAMKeychain passwordForService:UUID_KEYCHAIN_KEY account:LY_KEYCHAIN_UUID];
    if([uuid length]){
        uuidString = uuid;
    } else {
        uuid = [NSString getUUIDString];
        uuidString = uuid;
        [SAMKeychain setPassword:uuid forService:UUID_KEYCHAIN_KEY account:LY_KEYCHAIN_UUID];
    }
}

+(NSString *)readUUIDFromKeyChain
{
    if (![uuidString length]) {
        uuidString = [SAMKeychain passwordForService:UUID_KEYCHAIN_KEY account:LY_KEYCHAIN_UUID];
        if (![uuidString length]) {
            [NetworkHelper saveUUIDToKeyChain];
        }
    }
    if (![uuidString length]) {
        uuidString = @"";
    }
    return uuidString;
}

@end
