//
//  LYLoginPwdView.h
//  laoyuegou
//
//  Created by SmallJun on 2019/1/5.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LYLoginPwdBlock)(NSString *pwd);

@interface LYLoginPwdView : UIView

@property (nonatomic, copy) dispatch_block_t backBlock;
@property (nonatomic, copy) dispatch_block_t voiceCodeBlock;
@property (nonatomic, copy) LYLoginPwdBlock pwdBlock;
@property (nonatomic, copy) dispatch_block_t forgetPwdBlock;

- (void)becomeFirstResponder;

@end

NS_ASSUME_NONNULL_END
