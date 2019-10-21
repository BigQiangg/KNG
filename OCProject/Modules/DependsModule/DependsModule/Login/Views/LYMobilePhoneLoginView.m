//
//  LYMobilePhoneLoginView.m
//  laoyuegou
//
//  Created by hedgehog on 2019/4/19.
//  Copyright © 2019 HaiNanLexin. All rights reserved.
//

#import "LYMobilePhoneLoginView.h"




@implementation LYMobilePhoneLoginView


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
    

    
    
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    
    
    UIButton *btnFindThirdAccount = [UIButton buttonWithType:0];
    btnFindThirdAccount.frame = CGRectMake((mScreenWidth - 142)/2, mScreenHeight - 82, 142, 24);
    btnFindThirdAccount.layer.cornerRadius = 12;
    btnFindThirdAccount.backgroundColor = [UIColor colorWithHex:0x411DA4 alpha:0.3];
    [btnFindThirdAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnFindThirdAccount setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.85] forState:UIControlStateHighlighted];
    [btnFindThirdAccount setTitle:@"找回第三方登录账号" forState:UIControlStateNormal];
    btnFindThirdAccount.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:btnFindThirdAccount];
    [btnFindThirdAccount addTarget:self action:@selector(findThirdAccount:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.btnNext.layer.cornerRadius = 28;
    self.btnNext.clipsToBounds = YES;
    [self.btnNext setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateDisabled];
    [self.btnNext setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1] forState:UIControlStateDisabled];
    [self.btnNext setBackgroundImage:[UIImage imageNamed:@"login_btn_Bg"] forState:UIControlStateNormal];
    [self.btnNext setTitleColor:[UIColor colorWithHexString:@"#0C6D5C"] forState:UIControlStateNormal];
    
    self.btnPhoneLogin.layer.cornerRadius = 28;
    self.btnPhoneLogin.clipsToBounds = YES;
//    [self.btnPhoneLogin setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateDisabled];
    [self.btnPhoneLogin setBackgroundColor:[[UIColor colorWithHexString:@"#F9F9F9"] colorWithAlphaComponent:0.1] forState:UIControlStateNormal];
//    [self.btnPhoneLogin setBackgroundImage:[UIImage imageNamed:@"login_btn_Bg"] forState:UIControlStateNormal];
    [self.btnPhoneLogin setTitleColor:[UIColor colorWithHexString:@"#D8D1FF"] forState:UIControlStateNormal];
    
}

- (IBAction)topBtnClickAction:(id)sender {
    if (_codeBlock) {
        _codeBlock();
    }
 
}

- (IBAction)nextBtnClickAction:(id)sender {
    if (_nextBlock) {
        _nextBlock();
    }
}

- (void)findThirdAccount:(id)sender {
    if (self.findThirdAccountBlock) {
        self.findThirdAccountBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
