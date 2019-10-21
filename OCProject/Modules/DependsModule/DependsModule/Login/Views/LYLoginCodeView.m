//
//  LYLoginCodeView.m
//  laoyuegou
//
//  Created by SmallJun on 2019/1/5.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import "LYLoginCodeView.h"
#import <LDYYText/YYLabel.h>
#import <LDYYText/NSAttributedString+YYText.h>

#define kLYGCodeMaxCount 4

@interface LYLoginCodeView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnPwdOne;
@property (weak, nonatomic) IBOutlet UIButton *btnPwdTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnPwdThree;
@property (weak, nonatomic) IBOutlet UIButton *btnPwdFour;
@property (weak, nonatomic) IBOutlet YYLabel *voiceCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *tfCode;
@property (weak, nonatomic) IBOutlet UIView *bgView;



@end

@implementation LYLoginCodeView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tfCode addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.tfCode.delegate = self;
    [self setupView];
}

- (void)setupView {
    
    self.backgroundColor = [UIColor clearColor];
    
    self.labTitle.font = [UIFont boldSystemFontOfSize:20];
    self.labTitle.textColor = [UIColor colorWithHexString:@"#F9F9F9"];
    self.labTitle.text = @"验证码登录";
    
    self.btnPwdOne.layer.cornerRadius = 4;
    self.btnPwdTwo.layer.cornerRadius = 4;
    self.btnPwdThree.layer.cornerRadius = 4;
    self.btnPwdFour.layer.cornerRadius = 4;
    
    self.btnPwdOne.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    [self.btnPwdOne setTitleColor:[LYAppAppearanceConst appTitleBlackTextColor] forState:UIControlStateNormal];
    self.btnPwdTwo.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    [self.btnPwdTwo setTitleColor:[LYAppAppearanceConst appTitleBlackTextColor] forState:UIControlStateNormal];
    self.btnPwdThree.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    [self.btnPwdThree setTitleColor:[LYAppAppearanceConst appTitleBlackTextColor] forState:UIControlStateNormal];
    self.btnPwdFour.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    [self.btnPwdFour setTitleColor:[LYAppAppearanceConst appTitleBlackTextColor] forState:UIControlStateNormal];
    
    [self updateVoiceCodeBtn];
}

- (void)updateVoiceCodeBtn {
    NSString *linkStr = @"收不到验证码？";
    NSString *priStr = @"获取语音验证码";
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] initWithString:@""];
  
    NSString *content = [NSString stringWithFormat:@"%@%@",linkStr,priStr];
    [attributeText appendAttributedString:[[NSAttributedString alloc ] initWithString:content]];
    
    [attributeText addAttributes:@{NSFontAttributeName : LY_FONT_24,NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#D9DDE0"]} range:NSMakeRange(0, attributeText.length)];

    NSRange priRang = [[attributeText string] rangeOfString:priStr];
    [attributeText addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:12],NSForegroundColorAttributeName : [LYAppAppearanceConst appWhiteColor]} range:priRang];
    
    WeakSelf(ws);
    [attributeText yy_setTextHighlightRange:priRang
                                      color:[LYAppAppearanceConst appWhiteColor]
                            backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                                  tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                      if (ws.voiceCodeBlock) {
                                          ws.voiceCodeBlock();
                                      }
                                  }];
    
    self.voiceCodeBtn.attributedText = attributeText;
    self.voiceCodeBtn.textAlignment = NSTextAlignmentCenter;
    self.voiceCodeBtn.textVerticalAlignment = YYTextVerticalAlignmentCenter;
}


#pragma mark - actions

- (IBAction)back:(id)sender {
    [self clearAllText:NO];
    if (self.backBlock) {
        self.backBlock();
    }
}
- (IBAction)upKeyboard:(id)sender {
    [self becomeFirstResponder];
}

- (void)becomeFirstResponder {
    [self.tfCode becomeFirstResponder];
}

- (void)clearAllText:(BOOL)needShake {
    
    self.tfCode.text = @"";
    [self updateCode];
    if (needShake) {
        [self shakeAnimationForView:self.bgView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self becomeFirstResponder];
        });
    }
}

- (void)shakeAnimationForView:(UIView *)view {
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint x = CGPointMake(position.x + 2, position.y);
    CGPoint y = CGPointMake(position.x - 2, position.y);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    [animation setAutoreverses:YES];
    [animation setDuration:.08];
    [animation setRepeatCount:3];
    [viewLayer addAnimation:animation forKey:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    } else if(textField.text.length >= kLYGCodeMaxCount) {
        //输入的字符个数大于4，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于4，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.tfCode) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSLog(@"%@", textField.text);
    [self updateCode];
    if (textField.text.length == kLYGCodeMaxCount) {
        NSLog(@"输入完毕");
        if (self.codeBlock) {
            [self.tfCode resignFirstResponder];
            self.codeBlock(self.tfCode.text);
        }
    }
}

- (void)updateCode {
    
    NSInteger textLength = [self.tfCode.text length];
    for (int i = 0; i < kLYGCodeMaxCount; i++) {
        
        if (i == 0) {
            if (i < textLength) {
                [self.btnPwdOne setTitle:[NSString stringWithFormat:@"%@",[self.tfCode.text substringWithRange:NSMakeRange(i, 1)]] forState:UIControlStateNormal];
            } else {
                [self.btnPwdOne setTitle:@"" forState:UIControlStateNormal];
            }
        } else if (i == 1) {
            if (i < textLength) {
                [self.btnPwdTwo setTitle:[NSString stringWithFormat:@"%@",[self.tfCode.text substringWithRange:NSMakeRange(i, 1)]]  forState:UIControlStateNormal];
            } else {
                [self.btnPwdTwo setTitle:@"" forState:UIControlStateNormal];
            }
        } else  if (i == 2) {
            if (i < textLength) {
                [self.btnPwdThree setTitle:[NSString stringWithFormat:@"%@",[self.tfCode.text substringWithRange:NSMakeRange(i, 1)]]  forState:UIControlStateNormal];
            } else {
                [self.btnPwdThree setTitle:@"" forState:UIControlStateNormal];
            }
        } else if (i == 3) {
            if (i < textLength) {
                [self.btnPwdFour setTitle:[NSString stringWithFormat:@"%@",[self.tfCode.text substringWithRange:NSMakeRange(i, 1)]] forState:UIControlStateNormal];
            } else {
                [self.btnPwdFour setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
}


@end
