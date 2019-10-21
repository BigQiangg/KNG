//
//  CommunityRootViewController.m
//  OCProject
//
//  Created by zwq on 2019/9/24.
//  Copyright © 2019 zwq. All rights reserved.
//

#import "CommunityRootViewController.h"
#import <CoreModule/CoreModule.h>

@interface CommunityRootViewController ()

@end

@implementation CommunityRootViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        __weak CommunityRootViewController * ws = self;
        [[RACSignalManager subjectWithKey:@"communitySignal"] subscribeNext:^(id  _Nullable x) {
            if (x && [x isKindOfClass:RACSubjectObject.class]) {
                RACSubjectObject * obj = x;
                if (!obj.event) {
                    return;
                }
                
                if ([obj.event isEqualToString:@"VC_COMMUNITY_TAB_CHANGE"]) {
                    [ws.tabBarController setSelectedIndex:1];
                }
            }
//            NSLog(@"%@",x);
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RACSubjectObject * obj = [[RACSubjectObject alloc] init];
    obj.event = @"VC_COMMUNITY_VIEW_CONTROLLER";
    __weak CommunityRootViewController * weakSelf = self;
    obj.callBack = ^(id obj) {
        if (obj && [obj isKindOfClass:UIViewController.class]) {
            UIViewController * vc = (UIViewController *)obj;
            [weakSelf addChildViewController:vc];
            [weakSelf.view addSubview:vc.view];
        }
    };
    [[RACSignalManager subjectWithKey:@"chatRoomSignal"] sendNext:obj];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//+(void)load{
//    static dispatch_once_t onceToken;
//    __weak CommunityRootViewController * ws = self;
//    dispatch_once(&onceToken, ^{
//        [RACSignalManager.chatRoomSignal subscribeNext:^(id  _Nullable x) {
//            if (x && [x isKindOfClass:RACSubjectObject.class]) {
//                RACSubjectObject * obj = x;
//                if (!obj.event) {
//                    return;
//                }
//
//                if ([obj.event isEqualToString:@"VC_COMMUNITY_TAB_CHANGE"]) {
//                   [ws.tabBarController setSelectedIndex:1];
//                }
//            }
//            NSLog(@"%@",x);
//        }];
//    });
//}

@end
