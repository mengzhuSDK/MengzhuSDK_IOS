//
//  MZSessionPresetView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/8/22.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 分辨率选项View
 */

typedef void(^SelectSessionPreset)(BOOL isCancel, MZCaptureSessionPreset sessionPreset);

typedef enum : NSUInteger {
    MZSessionPresetShowDirection_Left = 0,
    MZSessionPresetShowDirection_Up,
} MZSessionPresetShowDirection;

@interface MZSessionPresetView : UIView

@property (nonatomic,   copy) SelectSessionPreset result;//选中或者取消的回调

/**
 * @brief 展示分辨率选项
 *
 * @param direction 展示的方向
 * @param from 以这个view为节点
 * @param normalSessionPreset 默认的分辨率
 *
 */
- (void)showWithDirection:(MZSessionPresetShowDirection)direction
                     from:(UIView *)from
      normalSessionPreset:(MZCaptureSessionPreset)normalSessionPreset;

/**
 * @brief 隐藏分辨率选项
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
