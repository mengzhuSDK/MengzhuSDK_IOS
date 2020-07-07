//
//  MZEmptyView.h
//  MengZhu
//
//  Created by vhall on 16/10/20.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZBaseView.h"

typedef enum {
    MZEmptyViewNoDataType,
    MZEmptyViewNetErrorType
}MZEmptyViewBlockType;

typedef void (^MZNetErrorClickBlock)(MZEmptyViewBlockType type);

@interface MZEmptyView : MZBaseView

@property (nonatomic,copy) MZNetErrorClickBlock errorBlock;

/*!
    无数据提示文字,可不设置
 */
@property (nonatomic,copy) NSString * noDataStr;

/*!
 无数据提示二级文字,可不设置
 */
@property (nonatomic,copy) NSString * noDataSubStr;

/*!
    无数据按钮提示文字,不设置时，默认不显示该按钮
 */
@property (nonatomic,copy) NSString * noDataBtnTitle;

/*!
    设置无数据按钮提示文字颜色
*/
@property (nonatomic,copy) UIColor * noDataBtnTitleColor;
/*!
    设置无数据按钮背景颜色
*/
@property (nonatomic,copy) UIColor * noDataBtnBgColor;
/*!
 无数据指定图片,可不设置
 */
@property (nonatomic,copy) UIImage * noDataImage;

/*!
    无网络提示文字,可不设置
 */
@property (nonatomic,copy) NSString * noErrorStr;

/*!
    网络错误按钮提示文字,可不设置
 */
@property (nonatomic,copy) NSString * errBtnTitle;

/*!
    实例化方法
 */
- (instancetype)initNetErrorViewWithFrame:(CGRect)frame clickBlock:(MZNetErrorClickBlock)clickBlock;

/*!
    网络请求错误
 */
- (void)showNetError;

/*!
    网络无数据
 */
- (void)showNoData;




@end
