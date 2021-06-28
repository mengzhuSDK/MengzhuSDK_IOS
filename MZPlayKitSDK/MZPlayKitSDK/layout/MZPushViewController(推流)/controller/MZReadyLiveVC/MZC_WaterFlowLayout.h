//
//  MZC_WaterFlowLayout.h
//  MZCustomizeAPP
//
//  Created by 李风 on 2020/11/18.
//  Copyright © 2020 盟主. All rights reserved.
//

/**
 自定义的瀑布流的 UICollectionViewLayout
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    MZC_WaterFlowVerticalEqualWidth = 0, /** 竖向瀑布流 item等宽不等高 */
    MZC_WaterFlowHorizontalEqualHeight = 1, /** 水平瀑布流 item等高不等宽 不支持头脚视图*/
    MZC_WaterFlowVerticalEqualHeight = 2,  /** 竖向瀑布流 item等高不等宽 */
    MZC_WaterFlowHorizontalGrid = 3,  /** 特为国务院客户端原创栏目滑块样式定制-水平栅格布局  仅供学习交流*/
    MZC_LineWaterFlow = 4 /** 线性布局 待完成，敬请期待 */
} MZC_WaterFlowLayoutStyle; //样式

@class MZC_WaterFlowLayout;

@protocol MZC_WaterFlowLayoutDelegate <NSObject>

/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为MZC_WaterFlowVerticalEqualWidth 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 MZC_WaterFlowHorizontalEqualHeight 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 MZC_WaterFlowHorizontalGrid   传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 MZC_WaterFlowVerticalEqualHeight 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 */
- (CGSize)waterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 头视图Size */
-(CGSize )waterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )waterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section;

@optional //以下都有默认值
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout;
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout;

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout;
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout;
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(MZC_WaterFlowLayout *)waterFlowLayout;

@end

@interface MZC_WaterFlowLayout : UICollectionViewLayout

/** delegate*/
@property (nonatomic, weak) id<MZC_WaterFlowLayoutDelegate> delegate;
/** 瀑布流样式*/
@property (nonatomic, assign) MZC_WaterFlowLayoutStyle  flowLayoutStyle;

@end

NS_ASSUME_NONNULL_END
