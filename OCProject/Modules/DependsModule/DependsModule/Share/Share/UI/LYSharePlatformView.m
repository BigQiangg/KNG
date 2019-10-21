//
//  LYSharePlatformView.m
//  laoyuegou
//
//  Created by zcc on 2018/4/13.
//  Copyright © 2018年 HaiNanLexin. All rights reserved.
//

#import "LYSharePlatformView.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "LYSharePlatformCell.h"


@implementation LYSharePlatformView
{
    ShareBlock _block;
    ShareOptBlock _optBlock;
    NSArray * platformArray;
    NSDictionary * shareInfo;
    NSArray * optionArray;
    NSDictionary * optionInfo;//参数
    NSDictionary * _optionDic;//状态-分享传递
}

static LYSharePlatformView * _sharedInstance = nil;
+(id)shareInstance{
    if (_sharedInstance == nil) {
        _sharedInstance = [LYSharePlatformView loadInstanceFromNib];
        [_sharedInstance setData];
    }
    return _sharedInstance;
}

- (void)setData{
    
    [self.platfCollectionView registerNib:[UINib nibWithNibName:@"LYSharePlatformCell" bundle:nil] forCellWithReuseIdentifier:@"LYSharePlatformCell"];
    [self.optionCollectionView registerNib:[UINib nibWithNibName:@"LYSharePlatformCell" bundle:nil] forCellWithReuseIdentifier:@"LYSharePlatformCell"];
    
    UICollectionViewFlowLayout * platfLayout = [[UICollectionViewFlowLayout alloc]init];
    platfLayout.minimumLineSpacing = 36;
    //最小item间距（默认为10）
    platfLayout.minimumInteritemSpacing = 10;
    //设置senction的内边距
    platfLayout.sectionInset = UIEdgeInsetsMake(0, 24, 0, 24);
    //设置UICollectionView的滑动方向
    platfLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //sectionHeader的大小,如果是竖向滚动，只需设置Y值。如果是横向，只需设置X值。
    self.platfCollectionView.collectionViewLayout = platfLayout;
    
    
    UICollectionViewFlowLayout * optionLayout = [[UICollectionViewFlowLayout alloc]init];
    optionLayout.minimumLineSpacing = 36;
    //最小item间距（默认为10）
    optionLayout.minimumInteritemSpacing = 10;
    //设置senction的内边距
    optionLayout.sectionInset = UIEdgeInsetsMake(0, 24, 0, 24);
    //设置UICollectionView的滑动方向
    optionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //sectionHeader的大小,如果是竖向滚动，只需设置Y值。如果是横向，只需设置X值。
    self.optionCollectionView.collectionViewLayout = optionLayout;
    
    shareInfo = @{
                  @(LYGSharePlatformLYG):@[@"捞月狗好友",@"icon_share_platform_lyg",@""],
                  @(LYGSharePlatformWeiXinCircle):@[@"朋友圈",@"icon_share_platform_weixincircle",@"icon_share_platform_weixincircle_uninstall"],
                  @(LYGSharePlatformWeiXinFriend):@[@"微信好友",@"icon_share_platform_weixinfriend",@"icon_share_platform_weixinfriend_uninstall"],
                  @(LYGSharePlatformSina):@[@"新浪微博",@"icon_share_platform_sina",@"icon_share_platform_sina_uninstall"],
                  @(LYGSharePlatformQQ):@[@"QQ",@"icon_share_platform_qq",@"icon_share_platform_qq_uninstall"],
                  @(LYGSharePlatformQQZone):@[@"QQ空间",@"icon_share_platform_qqzone",@"icon_share_platform_qqzone_uninstall"],
                  @(LYGSharePlatformCopyLink):@[@"复制链接",@"icon_share_platform_copylink",@""],
                  @(LYGSharePlatformSavePic):@[@"保存图片",@"icon_share_platform_save",@""],
                  };
    
    optionInfo = @{
                   @(LYGShareOption_JuBao):@[@"举报",@"",@"icon_share_option_jubao",@""],
                   @(LYGShareOption_LaHei):@[@"加入黑名单",@"解除黑名单",@"icon_share_option_lahei",@"icon_share_option_lahei"],
                   };
    
    optionArray = @[@(LYGShareOption_JuBao),@(LYGShareOption_LaHei)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self listeningRotating];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

/**
 *  监听设备旋转通知
 */
- (void)listeningRotating
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onDeviceOrientationChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil
     ];
}

/**
 *  屏幕方向发生变化会调用这里
 */
- (void)onDeviceOrientationChange:(NSNotification *)notify
{
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    UIInterfaceOrientation interfaceOrientation = (UIInterfaceOrientation)orientation;
    switch (interfaceOrientation) {
        case UIInterfaceOrientationPortrait:{
            [self loadPlatform:platformArray finish:_block optionBlock:_optBlock optionDic:_optionDic isLandScape:NO];
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            [self loadPlatform:platformArray finish:_block optionBlock:_optBlock optionDic:_optionDic isLandScape:YES];
            break;
        }
        default:
            break;
    }
}

+ (BOOL) isLandScape{
    BOOL isLandScape = NO;
    UIInterfaceOrientation sataus = [UIApplication sharedApplication].statusBarOrientation;
    switch (sataus) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            isLandScape = YES;
            break;
        default:
            break;
    }

    return isLandScape;
}

+ (LYSharePlatformView *)setPlatform:(NSArray *) platfrom finish:(ShareBlock) finish optionBlock:(ShareOptBlock) optBlock optionDic:(NSDictionary *) optDic{
    LYSharePlatformView * view = [LYSharePlatformView shareInstance];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [view loadPlatform:platfrom finish:finish optionBlock:optBlock optionDic:optDic isLandScape:[self isLandScape]];
    return view;
}

+ (LYSharePlatformView *)setPlatform:(NSArray *) platfrom finish:(ShareBlock) finish{
    return [LYSharePlatformView setPlatform:platfrom finish:finish optionBlock:nil optionDic:nil];
}

- (void)loadPlatform:(NSArray *) platfrom finish:(ShareBlock) finish optionBlock:(ShareOptBlock) optBlock optionDic:(NSDictionary *) optDic isLandScape:(BOOL) isLandScape{
    if (!platfrom || platfrom.count == 0) {
        [self dismiss];
        return;
    }
    _optionDic = optDic;
    _block = finish;
    _optBlock = optBlock;
    platformArray = platfrom;
    if(_optBlock){
        self.viewHeight.constant = 312;
        self.optionView.hidden = NO;
        self.optionView.userInteractionEnabled = YES;
    }else{
        self.viewHeight.constant = 205;
        self.optionView.hidden = YES;
        self.optionView.userInteractionEnabled = NO;
    }
    
    [self layoutIfNeeded];
    [self.platfCollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.platfCollectionView reloadData];
    [self.optionCollectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.optionCollectionView reloadData];
}

- (BOOL)checkInstall:(LYGSharePlatform) platform{
    switch (platform) {
        case LYGSharePlatformLYG:
            return YES;
            break;
        case LYGSharePlatformWeiXinCircle:
        case LYGSharePlatformWeiXinFriend:{
                if ([WXApi isWXAppInstalled]) {
                    return YES;
                }else{
                    return NO;
                }
            }
            break;
        case LYGSharePlatformSina:
            return YES;
            break;
        case LYGSharePlatformQQ:
        case LYGSharePlatformQQZone:{
            if ([QQApiInterface isQQInstalled]) {
                return YES;
            }else{
                return NO;
            }
        }
            break;
        case LYGSharePlatformCopyLink:
        case LYGSharePlatformSavePic:
            return YES;
            break;
        default:
            break;
    }
    return NO;
}

- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.viewBottomToSuperBottom.constant = -1 * LY_IPHONE_BOTTOM_HEIGHT;
    [UIView animateWithDuration:0.35 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        [self layoutIfNeeded];
    }];
}

- (void)dismiss{
    self.viewBottomToSuperBottom.constant = _viewHeight.constant;
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
//        self.platfCollectionView.contentOffset = CGPointMake(0, 0);
//        self.optionCollectionView.contentOffset = CGPointMake(0, 0);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view == self) {
        [self dismiss];
    }
}

- (IBAction)dismissBtnClicked:(id)sender{
    [self dismiss];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(collectionView == self.platfCollectionView){
        return platformArray.count;
    }else{
        return optionArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYSharePlatformCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[LYSharePlatformCell nameOfClass] forIndexPath:indexPath];
    if(collectionView == self.platfCollectionView){
        NSNumber * plat = platformArray[indexPath.item];
        NSArray * infoArray = shareInfo[plat];
        BOOL installed = [self checkInstall:plat.integerValue];
        NSString * image = (installed?infoArray[1]:infoArray[2]);
        [cell setTitle:infoArray[0] image:image];
    }else{
        NSNumber * plat = optionArray[indexPath.item];
        NSArray * infoArray = optionInfo[plat];
        NSString * image = infoArray[2];
        NSInteger ti = 0;
        if(_optionDic){
            NSNumber * t = _optionDic[plat];
            ti = t.boolValue?1:0;
        }
        
        [cell setTitle:infoArray[ti] image:image];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.platfCollectionView) {
        NSNumber * plat = platformArray[indexPath.item];
        if([self checkInstall:plat.integerValue]){
            if (_block) {
                _block(plat.integerValue);
            }
            [self dismiss];
        }
    }else{
        if (_optBlock) {
            NSNumber * plat = optionArray[indexPath.item];
            BOOL type = NO;
            if(_optionDic){
                NSNumber * typeN = _optionDic[plat];
                type = typeN.boolValue;
            }
            
            _optBlock(plat.integerValue,type);
        }
        [self dismiss];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(44, 70);
}
 

@end
 
