//
//  RACSignalManager.m
//  CoreModule
//
//  Created by zwq on 2019/9/24.
//  Copyright © 2019 zwq. All rights reserved.
//

#import "RACSignalManager.h"

@implementation RACSignalManager

static RACSubject * _chatRoomSignal = nil;
+(RACSubject *)chatRoomSignal{
    if (!_chatRoomSignal) {
        _chatRoomSignal = [RACSubject subject];
    }
    return _chatRoomSignal;
}

@end
