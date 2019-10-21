//
//  CommunityViewController.m
//  CommunityModule
//
//  Created by zwq on 2019/9/24.
//  Copyright © 2019 zwq. All rights reserved.
//

#import "CommunityViewController.h"
#import <CoreModule/CoreModule.h>

@interface CommunityViewController ()

@property(nonatomic,weak) IBOutlet UIButton * backBtn;

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.parentViewController) {
        self.backBtn.hidden = YES;
    }else{
        self.backBtn.hidden = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClicked:(UIButton *) btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[RACSignalManager subjectWithKey:@"chatRoomSignal"] subscribeNext:^(id  _Nullable x) {
            if (x && [x isKindOfClass:RACSubjectObject.class]) {
                RACSubjectObject * obj = x;
                if (!obj.event) {
                    return;
                }
                
                if ([obj.event isEqualToString:@"VC_COMMUNITY_VIEW_CONTROLLER"]) {
                    //取其他Module中的VC
                    CommunityViewController * vc = [[CommunityViewController alloc] initWithNibName:@"CommunityViewController" bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CommunityModule.framework" ofType:nil]] ];
//                    CommunityViewController * vc = [[CommunityViewController alloc] initWithNibName:@"CommunityViewController" bundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"CommunityModule.framework" ofType:nil]] ];
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
