//
//  LYMobilePhoneLoginView.h
//  laoyuegou
//
//  Created by hedgehog on 2019/4/19.
//  Copyright © 2019 HaiNanLexin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^LYPhoneSelectCodeBlock)(void);
typedef void(^LYFindThirdAccountBlock)(void);
typedef void(^LYOpenWebViewBlock)(NSString *urlString);
typedef void(^LYMobileNextBlock)(void);



@interface LYMobilePhoneLoginView : UIView


@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoneLogin;



@property (nonatomic,copy) LYPhoneSelectCodeBlock codeBlock;
@property (nonatomic,copy) LYFindThirdAccountBlock findThirdAccountBlock;
@property (nonatomic,copy) LYOpenWebViewBlock openWebViewBlock;
@property (nonatomic,copy) LYMobileNextBlock nextBlock;
@end

NS_ASSUME_NONNULL_END
