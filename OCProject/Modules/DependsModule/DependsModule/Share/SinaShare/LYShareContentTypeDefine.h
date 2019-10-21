//
//  LYShareContentType.h
//  SinaWeiBoDemo
//
//  Created by Dombo on 2017/12/28.
//  Copyright © 2017年 Dombo. All rights reserved.
//

#ifndef LYShareContentType_h
#define LYShareContentType_h

/**
 *  内容类型
 */
typedef NS_ENUM(NSUInteger, LYShareContentType){
    
    /**
     *  自动适配类型，视传入的参数来决定
     */
    LYShareContentTypeAuto         = 0,
    
    /**
     *  文本
     */
    LYShareContentTypeText         = 1,
    
    /**
     *  图片
     */
    LYShareContentTypeImage        = 2,
    
    /**
     *  网页
     */
    LYShareContentTypeWebPage      = 3,
    
    /**
     *  应用
     */
    LYShareContentTypeApp          = 4,
    
    /**
     *  音频
     */
    LYShareContentTypeAudio        = 5,
    
    /**
     *  视频
     */
    LYShareContentTypeVideo        = 6,
    
    /**
     *  文件类型(暂时仅微信可用)
     */
    LYShareContentTypeFile         = 7
    
};

#endif /* LYShareContentType_h */
