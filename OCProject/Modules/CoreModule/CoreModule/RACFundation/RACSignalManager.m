//
//  RACSignalManager.m
//  CoreModule
//
//  Created by zwq on 2019/9/24.
//  Copyright © 2019 zwq. All rights reserved.
//

#import "RACSignalManager.h"

@interface RACSignalManager()

@property(nonatomic, strong) NSMutableDictionary * signals;

@end

@implementation RACSignalManager

static RACSignalManager * _sharedInstance = nil;
+ (RACSignalManager *)shareInstance{
    if (!_sharedInstance) {
        _sharedInstance = [[RACSignalManager alloc] init];
    }
    return _sharedInstance;
}

+(RACSubject *)chatRoomSignal{
    return [RACSignalManager subjectWithKey:@"chatRoomSignal"];
}

+(RACSubject *)communitySignal{
    return [RACSignalManager subjectWithKey:@"communitySignal"];
}

+ (RACSubject *)subjectWithKey:(NSString *) key{
    return [[RACSignalManager shareInstance] subjectWithKey:key];
}

- (RACSubject *)subjectWithKey:(NSString *) key{
    if (!key || ![key isKindOfClass:[NSString class]] || key.length == 0) {
        return nil;
    }
    
    if ([self.signals.allKeys containsObject:key]) {
        return [self.signals objectForKey:key];
    }
    
    RACSubject * sub = [RACSubject subject];
    [self.signals setObject:sub forKey:key];
    return sub;
}

- (NSMutableDictionary *)signals{
    if (!_signals) {
        _signals = [NSMutableDictionary dictionary];
    }
    return _signals;
}

@end
