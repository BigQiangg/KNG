//
//  LYLoginPwdView.m
//  laoyuegou
//
//  Created by SmallJun on 2019/1/5.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import "LYLoginPwdView.h"
#import <LDYYText/YYLabel.h>

#import <LDYYText/NSAttributedString+YYText.h>


@interface LYLoginPwdView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIView *pwdBgView;
@property (weak, nonatomic) IBOutlet UITextField *tfPwd;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPwdBtn;

@property (strong, nonatomic) UIButton *rightViewBtn;

@end

@implementation LYLoginPwdView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.loginBtn.enabled = NO;
    self.tfPwd.delegate = self;
    [self setupView];
}

- (void)setupView {
    
    self.backgroundColor = [UIColor clearColor];
    self.pwdBgView.layer.cornerRadius = 28;
    
    self.labTitle.font = [UIFont boldSystemFontOfSize:20];
    
    self.loginBtn.layer.cornerRadius = 28;
    self.loginBtn.clipsToBounds = YES;
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#B8BDC6"] forState:UIControlStateDisabled];
    [self.loginBtn setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1] forState:UIControlStateDisabled];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_Bg"] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:[UIColor colorWithHexString:@"#0C6D5C"] forState:UIControlStateNormal];
    self.loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    
    self.tfPwd.placeholder = @"输入密码";
    self.tfPwd.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入密码" attributes:@{
                                                                                                       NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#B8BDC6"],
                                                                                                       NSFontAttributeName : [UIFont systemFontOfSize:18],
                                                                                                       }];
    
    [self.codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.codeBtn setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateHighlighted];
    [self.codeBtn setTitle:@"验证码登录" forState:UIControlStateNormal];
    self.codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.findPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.findPwdBtn setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateHighlighted];
    [self.findPwdBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    self.findPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView addTarget:self action:@selector(switchPwdSecureTextEntry:) forControlEvents:UIControlEventTouchUpInside];
    rightView.frame = CGRectMake(-30, 0, 30, 30);
    [rightView setImage:[UIImage imageNamed:@"tf_eyes"] forState:UIControlStateSelected];
    [rightView setImage:[UIImage imageNamed:@"tf_eyesclosed"] forState:UIControlStateNormal];
    self.tfPwd.rightViewMode = UITextFieldViewModeAlways;
    self.tfPwd.rightView = rightView;
    self.rightViewBtn = rightView;
    self.tfPwd.secureTextEntry = YES;
    
    self.tfPwd.rightView.hidden = NO;
}

- (void)switchPwdSecureTextEntry:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.tfPwd.secureTextEntry = !sender.selected;
}

- (IBAction)login:(id)sender {
    if (self.pwdBlock) {
        self.pwdBlock(self.tfPwd.text);
    }
}

- (IBAction)codeLogin:(id)sender {
    if (self.voiceCodeBlock) {
        self.voiceCodeBlock();
    }
}

- (IBAction)back:(id)sender {
    [self clearAllText];
    if (self.backBlock) {
        self.backBlock();
    }
}

- (IBAction)findPwd:(id)sender {
    
    if (self.forgetPwdBlock) {
        self.forgetPwdBlock();
    }
}


- (void)clearAllText {
    self.tfPwd.secureTextEntry = YES;
    self.rightViewBtn.selected = NO;
    self.tfPwd.text = @"";
    
    self.loginBtn.enabled = NO;
}

- (void)becomeFirstResponder {
    [self.tfPwd becomeFirstResponder];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    if (textField == self.tfPwd) {
        self.loginBtn.enabled = (strLength >= 6);
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tfPwd) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
