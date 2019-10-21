//
//  ChatRoomListViewController.m
//  ChatRoomModule
//
//  Created by zwq on 2019/9/24.
//  Copyright © 2019 zwq. All rights reserved.
//

#import "ChatRoomListViewController.h"
#import <CoreModule/CoreModule.h>
#import "ChatRoomViewController.h"
@interface ChatRoomListViewController ()

@end

@implementation ChatRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)enterChatRoomViewController{
     ChatRoomViewController * vc = [[ChatRoomViewController alloc] initWithNibName:@"ChatRoomViewController" bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ChatRoomModule.framework" ofType:nil]] ];
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)enterCommunityViewController{
    RACSubjectObject * obj = [[RACSubjectObject alloc] init];
    obj.event = @"VC_COMMUNITY_VIEW_CONTROLLER";
    __weak ChatRoomListViewController * weakSelf = self;
    obj.callBack = ^(id obj) {
        if (obj && [obj isKindOfClass:UIViewController.class]) {
            UIViewController * vc = (UIViewController *)obj;
            [weakSelf presentViewController:vc animated:YES completion:nil];
        }
    };
    [[RACSignalManager subjectWithKey:@"chatRoomSignal"] sendNext:obj];
}

- (IBAction)enterCommunityTabViewController{
    RACSubjectObject * obj = [[RACSubjectObject alloc] init];
    obj.event = @"VC_COMMUNITY_TAB_CHANGE";
    [[RACSignalManager subjectWithKey:@"communitySignal"] sendNext:obj];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[RACSignalManager subjectWithKey:@"chatRoomSignal"] subscribeNext:^(id  _Nullable x) {
            if (x && [x isKindOfClass:RACSubjectObject.class]) {
                RACSubjectObject * obj = x;
                if (!obj.event) {
                    return;
                }
                
                if ([obj.event isEqualToString:@"VC_CHATROOM_LIST_VIEW_CONTROLLER"]) {
                    //取其他Module中的VC
                    ChatRoomListViewController * vc = [[ChatRoomListViewController alloc] initWithNibName:@"ChatRoomListViewController" bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ChatRoomModule.framework" ofType:nil]] ];
                    if (obj.callBack) {
                        obj.callBack(vc);
                    }
                }
            }
//            NSLog(@"%@",x);
        }];
    });
}

@end
