//
//  LYSharePlatformCell.m
//  laoyuegou
//
//  Created by zwq on 2019/4/20.
//  Copyright © 2019 HaiNanLexin. All rights reserved.
//

#import "LYSharePlatformCell.h"
#import <CoreModule/CoreModule.h>

@implementation LYSharePlatformCell{
    BOOL _installed;
}

- (void)setTitle:(NSString *) title  image:(NSString *) image{
    self.infoLabel.text = title;
    self.infoImageView.image = IMAGENAMED(image);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
