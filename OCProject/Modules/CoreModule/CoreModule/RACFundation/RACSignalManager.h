//
//  RACSignalManager.h
//  CoreModule
//
//  Created by zwq on 2019/9/24.
//  Copyright © 2019 zwq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreModule/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface RACSignalManager : NSObject

//+(RACSubject *)chatRoomSignal;

+(RACSubject *)communitySignal;

+ (RACSubject *)subjectWithKey:(NSString *) key;

@end

NS_ASSUME_NONNULL_END
