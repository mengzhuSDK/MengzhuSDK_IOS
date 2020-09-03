//
//  MZChatGiftNewCell.h
//  MZKitDemo
//
//  Created by 李风 on 2020/8/23.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZChatGiftNewCell : MZChatBaseCell

@property (nonatomic, strong) MZLongPollDataModel *pollingDate;
@property (nonatomic,   copy) void(^headerViewAction)(MZLongPollDataModel *);

@property (nonatomic, assign) BOOL isMeSengGift;//是否是我自己发送的礼物

/// 获取礼物消息的cell高度
+ (float)getCellHeightIsLand:(BOOL)isLand;

@end

NS_ASSUME_NONNULL_END
