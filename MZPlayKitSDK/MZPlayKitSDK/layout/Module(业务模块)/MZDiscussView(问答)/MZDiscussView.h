//
//  MZDiscussView.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDiscussInputView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZDiscussView : UIView

@property (nonatomic, strong) UITableView *tableView;//列表
@property (nonatomic, strong) NSMutableArray *dataArray;//全部问答数据源
@property (nonatomic, strong) NSMutableArray *replyArray;//未读的回答数据源

@property (nonatomic, strong) UIButton *topTipButton;//顶部的新消息提示button

@property (nonatomic, strong) UIImageView *emptyImageView;//空View提示图片
@property (nonatomic, strong) UILabel *emptyLabel;//空View提示文字

@property (nonatomic, strong) MZDiscussInputView *discussInputView;

/**
 * @brief 实例化问答界面
 *
 * @param frame frame
 * @param ticketId 活动Id
 */
- (instancetype)initWithFrame:(CGRect)frame ticketId:(NSString *)ticketId;

/**
 * @brief 更新未读回复的个数
 *
 * @param noReadReplMsgCount 未读个数
 *
 */
- (void)updateNoReadReplyMsg:(NSString *)noReadReplMsgCount;

@end

NS_ASSUME_NONNULL_END
