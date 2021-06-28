//
//  MZBonusNewCell.h
//  MZKitDemo
//
//  Created by 李风 on 2021/6/21.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZChatBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZBonusNewCell : MZChatBaseCell

@property (nonatomic, strong) MZLongPollDataModel *pollingDate;
@property (nonatomic,   copy) void(^headerViewAction)(MZLongPollDataModel *);

@property (nonatomic, strong) UIButton *redPackageButton;

+ (float)getCellHeightIsLand:(BOOL)isLand;

@end

NS_ASSUME_NONNULL_END
