//
//  LYShare.m
//  laoyuegou
//
//  Created by smalljun on 16/1/21.
//  Copyright © 2016年 HaiNanLexin. All rights reserved.
//

#import "LYShare.h"
#import "ConvertToCommonEmoticonsHelper.h"

@interface LYShare () <MTLJSONSerializing>

@end

@implementation LYShare

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"type": @"click_type",
             @"title": @"title",
             @"content": @"content",
             @"picUrl": @"pic",
             @"ext": @"ext",
             };
}

+ (NSValueTransformer *)contentJSONTransformer
{
    return  [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        
        if ([value isKindOfClass:[NSString class]]) {
            
            // 表情映射。
            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:value];
            return  didReceiveText;
        }
        
        return value;
    }];
}

- (void)setContent:(NSString *)content
{
    if (![_content length] && [content length]) {
        _content =[ConvertToCommonEmoticonsHelper
                   convertToSystemEmoticons:content];
    }
}

- (void)replaceContent:(NSString *)content
{
    _content = nil;
    _attributeContent = nil;
    self.content = content;
}

//用于显示UI的内容
- (NSAttributedString *)attributeContent
{
    if (!_attributeContent) {
        
        NSDictionary *attribute = @{NSFontAttributeName: LY_FONT_24};
        _attributeContent = [LYEmojiHelper emojiStringWithConteng:self.content withAttributeDict:attribute];
    }
    
    return _attributeContent;
}

- (NSString *)jsonFromDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"title"] = self.title;
    dict[@"imageurl"] = [NSString stringByUnescapingFromURLArgument:self.picUrl];
    dict[@"share_content"] = self.content;
    if ([self.shareUrl length]) {
        dict[@"share_url"] = [NSString stringByUnescapingFromURLArgument:self.shareUrl];
    } else {
        dict[@"share_url"] = [NSString stringByUnescapingFromURLArgument:(self.ext?:@"")];
    }
    
    dict[@"platform"] = self.platform;
    dict[@"type"] = self.shareType;
    dict[@"imageurl_sina"] = [NSString stringByUnescapingFromURLArgument:self.sinaPicUrl];
    
    return [dict dictTranslateJsonString];
}

@end
