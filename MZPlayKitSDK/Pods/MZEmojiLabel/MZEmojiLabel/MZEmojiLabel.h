//
//  MZEmojiLabel.h
//  MZEmojiLabel
//
//  Created by 李风 on 2020/8/19.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <TTTAttributedLabel/TTTAttributedLabel.h>

NS_ASSUME_NONNULL_BEGIN

/** 注意：
使用本类解析表情的时候，需要将 MZEmojiLabel.bundle添加到工程里。

1. 选择 target - Build Phases - Copy Bundle Resources
2. 选择加号，添加选中 MZEmojiLabel.bundle

*/

typedef NS_OPTIONS(NSUInteger, MZEmojiLabelLinkType) {
    MZEmojiLabelLinkTypeURL = 0,
    MZEmojiLabelLinkTypeEmail,
    MZEmojiLabelLinkTypePhoneNumber,
    MZEmojiLabelLinkTypeAt,
    MZEmojiLabelLinkTypePoundSign,
};


@class MZEmojiLabel;
@protocol MZEmojiLabelDelegate <TTTAttributedLabelDelegate>

@optional
- (void)mzEmojiLabel:(MZEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MZEmojiLabelLinkType)type;

@end

@interface MZEmojiLabel : TTTAttributedLabel

@property (nonatomic, assign) BOOL disableEmoji; //禁用表情
@property (nonatomic, assign) BOOL disableThreeCommon; //禁用电话，邮箱，连接三者

@property (nonatomic, assign) BOOL isNeedAtAndPoundSign; //是否需要话题和@功能，默认为不需要

@property (nonatomic, copy) NSString *customEmojiRegex; //自定义表情正则
@property (nonatomic, copy) NSString *customEmojiPlistName; //xxxxx.plist 格式
@property (nonatomic, copy) NSString *customEmojiBundleName; //自定义表情图片所存储的bundleName xxxx.bundle格式

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-synthesis"
@property (nonatomic, weak) id<MZEmojiLabelDelegate> delegate; //点击连接的代理方法
#pragma clang diagnostic pop

@property (nonatomic, copy, readonly) id emojiText; //外部能获取text的原始副本

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth;

/**
 * @breif 读取MZEmojiLabel的bundle
 */
+ (NSBundle *)getEmojiBundle;

@end

NS_ASSUME_NONNULL_END
