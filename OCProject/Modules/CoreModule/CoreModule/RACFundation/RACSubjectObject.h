//
//  RACSubjectObject.h
//  CoreModule
//
//  Created by zwq on 2019/9/24.
//  Copyright © 2019 zwq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACSubjectObject : NSObject
@property(nonatomic,copy) NSString * event;
@property(nonatomic,copy) void(^callBack)(id obj);
@end

NS_ASSUME_NONNULL_END
