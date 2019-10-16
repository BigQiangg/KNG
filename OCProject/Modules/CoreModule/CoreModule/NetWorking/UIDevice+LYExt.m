//
//  UIDevice+LYExt.m
//  laoyuegou
//
//  Created by smalljun on 15/5/13.
//  Copyright (c) 2015年 HaiNanLexin. All rights reserved.
//

#import "UIDevice+LYExt.h"
#import "Reachability.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/sysctl.h>

static NSString *appVer = nil;
static NSString *appBuildVer = nil;
static NSString *lygAppVer = nil;

@implementation UIDevice (LYExt)



+ (NSString *)appName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    //app名称
    NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    if (!appName) {
        appName = [infoDictionary objectForKey:@"CFBundleName"];
    }
    return appName;
}


+ (NSString *)appShortVersion
{
    if (![appVer length]) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //app版本
        appVer = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    }
    return appVer;
}

+ (NSString *)LYGAPPVersion
{
    if (![lygAppVer length]) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //app版本
        lygAppVer = [infoDictionary objectForKey:@"LYGAppVersion"];
    }
    return lygAppVer;
}


+ (NSString *)appBuildVersion
{
    if (![appBuildVer length]) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        //app build版本
        appBuildVer = [infoDictionary objectForKey:@"CFBundleVersion"];
    }
    
    return appBuildVer;
}

+ (CGSize)nativeScreenSize
{
    CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
    return screenSize;
}

+ (NSString *)getNetworkType
{
    NSString *netconnType = @"";
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:// 没有网络
        {
            netconnType = @"无网络";
        }
            break;
        case ReachableViaWiFi:// Wifi
        {
            netconnType = @"Wifi";
        }
            break;
        case ReachableViaWWAN:// 手机自带网络
        {
            // 获取手机网络类型
            CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            if (currentRadioAccessTechnology) {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    netconnType = @"4G";
                } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyWCDMA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSDPA] ||
                           [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyHSUPA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
                           [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
                           [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD])
                {
                    netconnType = @"3G";
                } else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] ||
                           [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyCDMA1x])
                {
                    netconnType = @"2G";
                }
            }
            break;
        }
            break;
            
        default:
            break;
    }
    
    return netconnType;
}

+ (NSString *)carrierName {
    
    NSString *carrierName = @"";
    CTCarrier *carrier = [[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider];
    if (carrier != nil) {
        NSString *networkCode = [carrier mobileNetworkCode];
        if (networkCode != nil) {
            
            //中国移动
            if ([networkCode isEqualToString:@"00"] || [networkCode isEqualToString:@"02"] || [networkCode isEqualToString:@"07"] || [networkCode isEqualToString:@"08"]) {
                carrierName= @"中国移动";
            }
            //中国联通
            if ([networkCode isEqualToString:@"01"] || [networkCode isEqualToString:@"06"] || [networkCode isEqualToString:@"09"]) {
                carrierName= @"中国联通";
            }
            //中国电信
            if ([networkCode isEqualToString:@"03"] || [networkCode isEqualToString:@"05"] || [networkCode isEqualToString:@"11"]) {
                carrierName= @"中国电信";
            }
            if (carrierName == nil) {
                carrierName = carrier.carrierName;
            }
        }
    }
    if (carrierName == nil) {
        carrierName = @"";
    }
    return carrierName;
}

+ (NSString *)carrier {
    
    NSString *carrierStr = @"";
    CTCarrier *carrier = [[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider];
    if (carrier != nil) {
        NSString *mobileNetworkCode = [carrier mobileNetworkCode]?:@"";
        NSString *mobileCountryCode = [carrier mobileCountryCode]?:@"";
        carrierStr = [NSString stringWithFormat:@"%@%@",mobileCountryCode,mobileNetworkCode];
    }
    
    if (carrierStr == nil) {
        carrierStr = @"";
    }
    
    return carrierStr;
}

+ (NSString *)deviceModel {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char answer[size];
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = @(answer);
    return results;
}

//获取磁盘可用空间大小
+ (uint64_t)getFreeDiskspace {
    uint64_t totalSpace = 0;
    uint64_t totalFreeSpace = 0;
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    
    if (dictionary) {
        NSNumber *fileSystemSizeInBytes = [dictionary objectForKey: NSFileSystemSize];
        NSNumber *freeFileSystemSizeInBytes = [dictionary objectForKey:NSFileSystemFreeSize];
        totalSpace = [fileSystemSizeInBytes unsignedLongLongValue];
        totalSpace = ((totalSpace/1024ll)/1024ll);
        totalFreeSpace = [freeFileSystemSizeInBytes unsignedLongLongValue];
        totalFreeSpace = ((totalFreeSpace/1024ll)/1024ll);
        NSLog(@"Memory Capacity of %llu MiB with %llu MiB Free memory available.", totalSpace, totalFreeSpace);
    } else {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    
    return totalFreeSpace;
}

@end
