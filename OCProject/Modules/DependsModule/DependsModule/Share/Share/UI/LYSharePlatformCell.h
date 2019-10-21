//
//  LYSharePlatformCell.h
//  laoyuegou
//
//  Created by zwq on 2019/4/20.
//  Copyright © 2019 HaiNanLexin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYSharePlatformCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel * infoLabel;
@property (nonatomic, weak) IBOutlet UIImageView * infoImageView;

- (void)setTitle:(NSString *) title  image:(NSString *) image;

@end

NS_ASSUME_NONNULL_END
