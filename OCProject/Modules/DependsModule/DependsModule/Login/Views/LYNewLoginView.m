//
//  LYNewLoginView.m
//  laoyuegou
//
//  Created by SmallJun on 2019/1/4.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import "LYNewLoginView.h"
#import <LDYYText/YYLabel.h>

#import <LDYYText/NSAttributedString+YYText.h>


@interface LYNewLoginView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnCode;
@property (weak, nonatomic) IBOutlet UITextField *tfPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet YYLabel *agreementView;
@property (weak, nonatomic) IBOutlet UIView *tfBgView;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;


@end

@implementation LYNewLoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setNationCode:@"+86"];
    self.tfPhone.delegate = self;
    [self setupView];
}

- (void)setupView {
    
    self.backgroundColor = [UIColor clearColor];
    self.tfBgView.layer.cornerRadius = 28;
    
    self.btnNext.layer.cornerRadius = 28;
    self.btnNext.clipsToBounds = YES;
    [self.btnNext setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateDisabled];
    [self.btnNext setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1] forState:UIControlStateDisabled];
    [self.btnNext setBackgroundImage:[UIImage imageNamed:@"login_btn_Bg"] forState:UIControlStateNormal];
    [self.btnNext setTitleColor:[UIColor colorWithHexString:@"#0C6D5C"] forState:UIControlStateNormal];
    self.btnNext.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.btnNext setTitle:@"下一步" forState:UIControlStateNormal];
    
    self.agreementView.backgroundColor = [UIColor clearColor];
    [self.btnCode setTitleColor:[LYAppAppearanceConst appTitleBlackTextColor] forState:UIControlStateNormal];
    self.btnCode.titleLabel.font = [UIFont systemFontOfSize:16];
    self.tfPhone.placeholder = @"输入手机号";
    self.tfPhone.textColor = [LYAppAppearanceConst appTitleBlackTextColor];
    self.tfPhone.font = [UIFont systemFontOfSize:18];
    
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
    
    UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightView addTarget:self action:@selector(clearPhone:) forControlEvents:UIControlEventTouchUpInside];
    rightView.frame = CGRectMake(-32, 0, 32, 32);
    [rightView setImage:[UIImage imageNamed:@"tf_delete_big"] forState:UIControlStateNormal];
    self.tfPhone.rightViewMode = UITextFieldViewModeAlways;
    self.tfPhone.rightView = rightView;
    
    self.tfPhone.rightView.hidden = YES;
    
    [self updateAgreementView];
}

- (void)setNationCode:(NSString *)nationCode {
    _nationCode = nationCode;
    [self.btnCode setTitle:nationCode forState:UIControlStateNormal];
    [self judgeNation];
}

- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    self.tfPhone.text = phone;
    self.tfPhone.rightView.hidden = !([phone length] > 0);
    [self checkNextBtnEnable:[self.tfPhone.text length]];
}

- (void)clearPhone:(id)sender {
    self.tfPhone.text = @"";
    self.tfPhone.rightView.hidden = YES;
    [self judgeNation];
}

- (void)judgeNation
{
    if ([self.btnCode.currentTitle isEqualToString:@"+86"]) {
        [self.tfPhone limitTextViewTextLength:11 textViewChanged:NULL];
        
    }else{
        [self.tfPhone limitTextViewTextLength:20 textViewChanged:NULL];
    }
    [self checkNextBtnEnable:[self.tfPhone.text length]];
}

- (void)updateAgreementView {
    NSString *linkStr = @"《捞月狗用户协议》";
    NSString *priStr = @"《隐私协议》";
    NSString *language = nil;
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:@""];
    language = @" & ";
    
    NSString *content = [NSString stringWithFormat:@"%@%@%@",linkStr,language,priStr];
    [attributeText appendAttributedString:[[NSAttributedString alloc ] initWithString:content]];
    
    [attributeText addAttributes:@{NSFontAttributeName : LY_FONT_24,NSForegroundColorAttributeName : [LYAppAppearanceConst appLightTextColor]} range:NSMakeRange(0, attributeText.length)];
    
    NSRange linkRang = [[attributeText string] rangeOfString:linkStr];
    NSRange priRang = [[attributeText string] rangeOfString:priStr];
    
    WeakSelf(ws);
    [attributeText yy_setTextHighlightRange:linkRang
                                      color:[LYAppAppearanceConst appWhiteColor]
                            backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                  tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                      if (ws.openWebViewBlock) {
                                          ws.openWebViewBlock(LY_H5_AGREEMENT);
                                      }
                                  }];
    
    [attributeText yy_setTextHighlightRange:priRang
                                      color:[LYAppAppearanceConst appWhiteColor]
                            backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                  tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                      if (ws.openWebViewBlock) {
                                          ws.openWebViewBlock(LY_H5_PRIACY_HELPER);
                                      }
                                  }];
    
    self.agreementView.attributedText = attributeText;
    self.agreementView.textAlignment = NSTextAlignmentCenter;
    self.agreementView.textVerticalAlignment = YYTextVerticalAlignmentCenter;
}

- (NSString *)currentPhone {
    return self.tfPhone.text;
}


#pragma mark -- actions

- (IBAction)selectNationCode:(id)sender {
    if (self.codeBlock) {
        self.codeBlock();
    }
}
- (IBAction)returnBtnClickAction:(id)sender {
    if (self.backBlock) {
        self.backBlock();
    }
}

- (IBAction)accounNext:(id)sender {
    if (self.nextBlock) {
        self.nextBlock(self.nationCode,self.tfPhone.text);
    }
}

- (void)findThirdAccount:(id)sender {
    if (self.findThirdAccountBlock) {
        self.findThirdAccountBlock();
    }
}

- (void)checkNextBtnEnable:(NSInteger)textLength {
    NSString *nation = self.nationCode;
    
    if ([nation isEqualToString:@"+86"]) {
        self.btnNext.enabled = (textLength >= 11);
    } else{
        self.btnNext.enabled = (textLength > 6);
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger strLength = textField.text.length - range.length + string.length;
    
    if (textField == self.tfPhone) {
        textField.rightView.hidden = !(strLength > 0);
    }
    
    [self checkNextBtnEnable:strLength];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.tfPhone) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
