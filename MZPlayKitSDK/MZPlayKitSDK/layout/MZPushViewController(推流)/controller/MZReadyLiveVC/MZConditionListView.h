//
//  MZConditionListView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/10/19.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MZReadyConditionListType_Categroy = 0,//分类列表
    MZReadyConditionListType_FCode,//F码列表
    MZReadyConditionListType_White,//白名单列表
} MZReadyConditionListType;

/**
 * @brief 选择选项的label
 */
@class MZConditionLabel;
@protocol MZConditionLabelSelectProtocol <NSObject>
@optional
- (void)selectOrUnSelect:(MZConditionLabel *)label;
@end

@interface MZConditionLabel : UILabel
@property (nonatomic, assign) BOOL isSelect;//是否选中
@property (nonatomic,   weak) id<MZConditionLabelSelectProtocol>delegate;
@end


@interface MZConditionListView : UIView

/**
 * 展示配置的选择列表
 * @param conditionListType 展示列表的类型
 * @param result 选择结果的回调
 */
+ (void)showList:(MZReadyConditionListType)conditionListType
          result:(void(^)(BOOL isCancel, MZReadyConditionListType type, int selectId, NSString *selectString))result;

@end

NS_ASSUME_NONNULL_END
