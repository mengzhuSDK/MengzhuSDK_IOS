//
//  MZRollingADModel.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/9/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MZRollingADType_Text = 0,//文字广告
    MZRollingADType_Image = 1,//图片广告
    MZRollingADType_Data = 3,//数据广告 - 暂时定义，未做处理
} MZRollingADType;//广告类型

/**
 * @brief 文字类型广告配置
 */
@interface MZTextADStyle : NSObject
@property (nonatomic, assign) int fontSize;//字体大小
@property (nonatomic,   copy) NSString *fontColor;//字体颜色
@property (nonatomic,   copy) NSString *backgroundColor;//背景颜色
@end

/**
 * @brief 数据类型广告配置
 */
@interface MZDataADModel : NSObject
@property (nonatomic,   copy) NSString *name;//数据名字
@property (nonatomic,   copy) NSString *value;//数据的值
@end

/**
 * @brief 滚动广告配置
 */
@interface MZRollingADModel : NSObject
@property (nonatomic, assign) MZRollingADType type;//广告类型，参考 MZRollingADType
@property (nonatomic,   copy) NSString *link;//广告链接

@property (nonatomic,   copy) NSString *content;//文字广告的文字内容，或者图片广告的图片地址
@property (nonatomic, strong) MZTextADStyle *style;//文字广告配置

#pragma mark - 下面是数据广告的配置
@property (nonatomic,   copy) NSArray <MZDataADModel *> *data;//数据广告里的每条数据的配置
@property (nonatomic, assign) int sub_type;//数据广告的背景色配置 - 1：纯色，使用style里的背景色配置，2：图片背景
@property (nonatomic,   copy) NSString *img_url;//sub_type为2时候的图片背景地址
@end

NS_ASSUME_NONNULL_END
