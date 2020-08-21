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
@property (nonatomic, strong) NSMutableArray *dataArray;//数据源

@property (nonatomic, strong) UIButton *topTipButton;//顶部的新消息提示button

@property (nonatomic, strong) UIImageView *emptyImageView;//空View提示图片
@property (nonatomic, strong) UILabel *emptyLabel;//空View提示文字

@property (nonatomic, strong) MZDiscussInputView *discussInputView;

@end

NS_ASSUME_NONNULL_END
