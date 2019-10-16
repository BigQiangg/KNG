//
//  NSObject+LYExt.h
//  laoyuegou
//
//  Created by smalljun on 15/10/20.
//  Copyright © 2015年 HaiNanLexin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (LYExt)

- (void)setExtensionInfo:(id)info;
- (id)extensionInfo;

@end


@interface NSObject (ChessObjectId)

- (NSString *)idStringValue;
- (NSString *)idStringValueForDefaultEmtptyString;

- (id)ly_objectForKey:(NSString *)aKey;
@end


@interface NSObject (NameOfClass)

+ (NSString *)nameOfClass;

@end
