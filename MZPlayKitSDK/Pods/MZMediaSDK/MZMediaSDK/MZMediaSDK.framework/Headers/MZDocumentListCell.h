//
//  MZDocumentListCell.h
//  MZPlayKitSDK
//
//  Created by 李风 on 2020/7/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDocumentInfo.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DocumentDownloadButtonClick)(MZDocumentInfo *_Nullable info);

@interface MZDocumentListCell : UITableViewCell

@property (nonatomic, strong) MZDocumentInfo *model;//下载模型
@property (nonatomic, assign) BOOL isSelectStatus;//是否选中

@property (nonatomic, strong) UILabel *titleLabel;//标题
@property (nonatomic, strong) UIButton *downBtn;//下载按钮

@property (nonatomic,   copy) DocumentDownloadButtonClick downloadButtonClick;//下载按钮点击的回调

/// 更新下载进度条的轨迹默认颜色
- (void)updateNormalStrokeColor:(UIColor *)color;

/// 更新下载进度条的轨迹填充颜色
- (void)updateFillStrokeColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
