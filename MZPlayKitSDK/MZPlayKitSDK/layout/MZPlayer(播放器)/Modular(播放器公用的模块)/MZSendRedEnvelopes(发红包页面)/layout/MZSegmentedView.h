//
//  MZSegmentedView.h
//  MengZhu
//
//  Created by 李伟 on 2018/5/17.
//  Copyright © 2018年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MZSegmentedViewSelectDelegate<NSObject>
- (void)segmentedViewTitleSelectWithIndex:(NSInteger)index;
@end
@interface MZSegmentedView : UIView
@property (nonatomic, strong) NSMutableArray*buttonArray; // 对应的标题文字
@property (nonatomic, assign) BOOL isHaveBRoundBorder;
@property (nonatomic, strong) UIColor * titleColor ; //标题颜色
@property (nonatomic, strong) UIColor * selectColor; //选中颜色
@property (nonatomic, strong) UIColor *selectBlowColor;//选中的底部标示线颜色
@property (nonatomic, strong) UIFont * titleFont;
@property (nonatomic, strong) UIFont * selectTitleFont;
@property (nonatomic, assign) CGFloat widthFloat;
@property (nonatomic, strong) UIImageView  *bottomArrowView;
@property (nonatomic, assign) BOOL isSeparatorLine;//是否显示分割线
@property (nonatomic, assign) BOOL isChangeLine;//改变滑动的线
@property (nonatomic, strong) UIView *buttonDown;//底部下划线

@property (nonatomic, weak) id<MZSegmentedViewSelectDelegate> delegate;

- (void)selectTheSegument:(NSInteger)segument;

- (void)setUnreadCountWithNum:(NSInteger)num index:(NSInteger)index;

@end
