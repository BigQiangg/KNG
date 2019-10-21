//
//  LYNewLoginView.h
//  laoyuegou
//
//  Created by SmallJun on 2019/1/4.
//  Copyright © 2019年 HaiNanLexin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LYPhoneSelectCodeBlock)(void);
typedef void(^LYFindThirdAccountBlock)(void);
typedef void(^LYOpenWebViewBlock)(NSString *urlString);
typedef void(^LYSignUpNextBlock)(NSString *nationCode,NSString *phone);

@interface LYNewLoginView : UIView

@property (nonatomic,copy) LYPhoneSelectCodeBlock codeBlock;
@property (nonatomic,copy) LYFindThirdAccountBlock findThirdAccountBlock;
@property (nonatomic,copy) LYOpenWebViewBlock openWebViewBlock;
@property (nonatomic,copy) LYSignUpNextBlock nextBlock;

@property (nonatomic,copy) NSString *nationCode;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy,readonly) NSString *currentPhone;

@property (nonatomic, copy) dispatch_block_t backBlock;

@end
