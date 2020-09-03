//
//  MZBeautyFaceOptionView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/8/22.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 美颜选项View
 */

typedef void(^SelectBeautyFaceLevel)(BOOL isCancel, MZBeautyFaceLevel beautyLevel);

typedef enum : NSUInteger {
    MZBeautyFaceShowDirection_Left = 0,
    MZBeautyFaceShowDirection_Up,
} MZBeautyFaceShowDirection;

@interface MZBeautyFaceOptionView : UIView

@property (nonatomic, copy) SelectBeautyFaceLevel result;//选中获取取消的回调

/**
 * @brief 展示美颜选项
 *
 * @param direction 展示的方向
 * @param from 以这个view为节点
 * @param normalBeautyLevel 默认美颜等级
 *
 */
- (void)showWithDirection:(MZBeautyFaceShowDirection)direction
                     from:(UIView *)from
        normalBeautyLevel:(MZBeautyFaceLevel)normalBeautyLevel;

/**
 * @brief 隐藏美颜选项
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
