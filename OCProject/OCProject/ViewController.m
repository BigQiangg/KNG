//
//  ViewController.m
//  OCProject
//
//  Created by zwq on 2019/9/24.
//  Copyright © 2019 zwq. All rights reserved.
//

#import "ViewController.h"
#import <CoreModule/CoreModule.h>
//#import <CoreModule/ReactiveObjC.h>
#import <CoreModule/CoreModule.h>
//#import <ChatRoomModule/ChatRoomModule.h>

//@interface RACSubjectObj : NSObject
//
//@property(nonatomic,copy) NSString * event;
//@property(nonatomic,copy) void(^callBack)(id obj);
//
//@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    RACSubjectObject * obj = [[RACSubjectObject alloc] init];
    obj.event = @"VC_CHATROOM_LIST_VIEW_CONTROLLER";
    __weak ViewController * weakSelf = self;
    obj.callBack = ^(id obj) {
        if (obj && [obj isKindOfClass:UIViewController.class]) {
            UIViewController * vc = (UIViewController *)obj;
            [weakSelf addChildViewController:vc];
            [self.view addSubview:vc.view];
        }
    };
    [[RACSignalManager subjectWithKey:@"chatRoomSignal"] sendNext:obj];
    
//    //取其他Module中的VC
//    ChatRoomListViewController * vc = [[ChatRoomListViewController alloc] initWithNibName:@"ChatRoomListViewController" bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ChatRoomModule.framework" ofType:nil]] ];
//////    ChatRoomListViewController * vc = [[ChatRoomListViewController alloc] init];
//    [self addChildViewController:vc];
//    [self.view addSubview:vc.view];
}


@end



//@implementation RACSubjectObj
//
//@end
