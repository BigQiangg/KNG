//
//  LYLoginCodeView.h
//  laoyuegou
//
//  Created by SmallJun on 2019/1/5.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^LYLoginCodeBlock)(NSString *code);

@interface LYLoginCodeView : UIView

@property (nonatomic, copy) dispatch_block_t backBlock;
@property (nonatomic, copy) dispatch_block_t voiceCodeBlock;
@property (nonatomic, copy) LYLoginCodeBlock codeBlock;

- (void)becomeFirstResponder;

- (void)clearAllText:(BOOL)needShake;

@end

NS_ASSUME_NONNULL_END
