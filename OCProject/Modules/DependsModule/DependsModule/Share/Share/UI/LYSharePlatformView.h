//
//  LYGSharePlatformView.h
//  laoyuegou
//
//  Created by zcc on 2018/4/13.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYShareUtil.h"

@interface LYSharePlatformView : UIView

@property(nonatomic,strong) IBOutlet UIView * contentView;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint * viewHeight;
@property(nonatomic,strong) IBOutlet NSLayoutConstraint * viewBottomToSuperBottom;
@property(nonatomic,strong) IBOutlet UICollectionView * platfCollectionView;
@property(nonatomic,strong) IBOutlet UICollectionView * optionCollectionView;
@property(nonatomic,strong) IBOutlet UIView * optionView;

+ (LYSharePlatformView *)setPlatform:(NSArray *) platfrom finish:(ShareBlock) finish;

+ (LYSharePlatformView *)setPlatform:(NSArray *) platfrom finish:(ShareBlock) finish optionBlock:(ShareOptBlock) optBlock optionDic:(NSDictionary *) optDic;

- (void)show;

@end
 
