//
//  MZPredictManageCreatRecommendView.h
//  MengZhu
//
//  Created by xu on 2019/4/17.
//  Copyright © 2019 www.mengzhu.com. All rights reserved.
//

#import "MZCreatPredictTipsModel.h"

typedef enum{
   AlertViewLeftBtnClick,
    AlertViewRightBtnClick,
    AlertViewCloseBtnBlock//暂时没用
} AlertViewClickType;

typedef void(^PredictAlertViewClickBlock)(AlertViewClickType type,UIView *view);

@protocol MZPredictTipsSelectDelegate <NSObject>

- (void)tipsButtonClickAction:(NSInteger)type view:(UIView *)view;

@end

@interface MZPredictManageCreatRecommendView : UIView

@property (nonatomic, weak) id <MZPredictTipsSelectDelegate> delegate;
@property (nonatomic,copy) PredictAlertViewClickBlock clickBlock;

@property (nonatomic, strong) MZCreatPredictTipsModel *model;
//内容的排列
@property (nonatomic, assign) NSTextAlignment contentAlignment;

/// 为了用的更方便，所以额外加了这个初始化的方法，不在使用上面的model
/// @param title 标题
/// @param content 内容
/// @param leftStr 左按钮文字
/// @param rightStr 右按钮文字
/// @param isOutsideClose 点击区域外关闭不关闭
/// @param isNoCloseBtn 是否没有右侧的关闭按钮
-(instancetype)initAlertViewWithTitle:(NSString *)title content:(NSString *)content leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr isOutsideClose:(BOOL)isOutsideClose clickBlock:(PredictAlertViewClickBlock) clickBlock;

//不返回对象的方法
-(void)initAlertViewNOReturnWithTitle:(NSString *)title content:(NSString *)content leftStr:(NSString *)leftStr rightStr:(NSString *)rightStr isOutsideClose:(BOOL)isOutsideClose clickBlock:(PredictAlertViewClickBlock) clickBlock;

//移除推荐页
- (void)removeRecommendView;

@end
