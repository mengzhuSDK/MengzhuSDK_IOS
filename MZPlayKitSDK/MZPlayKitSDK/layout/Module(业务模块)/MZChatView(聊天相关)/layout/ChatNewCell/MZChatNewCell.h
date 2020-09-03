//
//  MZChatNewCell.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZChatNewCell : MZChatBaseCell
@property (nonatomic,   copy) NSString *role_name;
@property (nonatomic, strong) MZLongPollDataModel *pollingDate;
@property (nonatomic,   copy) void(^headerViewAction)(MZLongPollDataModel *);
@property (nonatomic,   copy) void(^headerViewLongPress)(MZLongPollDataModel *);
@property (nonatomic,   copy) void(^bgViewAction)(MZLongPollDataModel *);
@property (nonatomic,   copy) void(^circleGeneralizeClick)(MZLongPollDataModel *);
@property (nonatomic,   copy) void(^goodsImageAction)(MZLongPollDataModel *);
@property (nonatomic,   copy) void (^redBgViewAction)(MZLongPollDataModel *);
@property (nonatomic,   copy) GetImgHeightBlock imgHeightBlock;//获取图片高度后刷新

/// 获取普通消息的cell高度
+ (float)getCellHeight:(MZLongPollDataModel *)pollingDate cellWidth:(CGFloat)cellWidth isLand:(BOOL)isLand;

/// 获取公告的cell高度
+ (float)getNoticeCellHeight:(MZLongPollDataModel *)pollingDate isLand:(BOOL)isLand;
@end

NS_ASSUME_NONNULL_END
