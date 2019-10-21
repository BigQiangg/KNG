//
//  NSObject+LYExt.m
//  laoyuegou
//
//  Created by smalljun on 15/10/20.
//  Copyright © 2015年 HaiNanLexin. All rights reserved.
//

#import "NSObject+LYExt.h"
#import <objc/runtime.h>

static void * const LYExtensionKey = @"com.XYExtensionKey";

@implementation NSObject (LYExt)

- (void)setExtensionInfo:(id)info
{
    objc_setAssociatedObject(self, LYExtensionKey, info, OBJC_ASSOCIATION_RETAIN);
}

- (id)extensionInfo
{
    id extensionInfo = objc_getAssociatedObject(self, LYExtensionKey);
    return extensionInfo;
}

@end

@implementation NSObject (ChessObjectId)
- (NSString *)idStringValue
{
    if ([self respondsToSelector:@selector(stringValue)]) {
        return [self performSelector:@selector(stringValue)];
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    
    return nil;
}

- (NSString *)idStringValueForDefaultEmtptyString
{
    NSString *result = [self idStringValue];
    if (!result) {
        result = @"";
    }
    return result;
}

- (id)ly_objectForKey:(NSString *)aKey {
     
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [(NSDictionary *)self objectForKey:aKey];
    }
    return nil;
}

@end



@implementation NSObject (NameOfClass)

+ (NSString *)nameOfClass {
    return NSStringFromClass([self class]);
}

@end



