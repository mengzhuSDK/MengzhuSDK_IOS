//
//  MZLiveAlerView.h
//  MengZhu
//
//  Created by LiWei on 2019/8/26.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#import "MZBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MZLiveAlerLeftClick = 1,
    MZLiveAlerRightClick,
} MZLiveAlerBtnClickType;

typedef void(^AlertViewClickBlock)(MZLiveAlerBtnClickType clickType);


@interface MZLiveAlertView : MZBaseView


/**
 <#Description#>

 @param view 添加的view
 @param title 标题
 @param leftBtnStr 左按钮（为空只展示右）
 @param rightBtnStr 右按钮（为空只展示左）
 @param clickBlock 点击按钮回调
 */
-(void)showInWithView:(UIView *)view title:(NSString *)title leftBtn:(NSString *)leftBtnStr rightBtn:(NSString *)rightBtnStr clickBlock:(AlertViewClickBlock )clickBlock;

@end

NS_ASSUME_NONNULL_END
