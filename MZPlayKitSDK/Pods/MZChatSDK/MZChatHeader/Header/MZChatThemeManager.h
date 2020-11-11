//
//  MZChatThemeManager.h
//  MZChatSDK
//
//  Created by LiWei on 2020/8/4.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ChatThemeType) {
    ChatThemeTypeDefault  //默认主题
};

NS_ASSUME_NONNULL_BEGIN

@interface MZChatThemeManager : NSObject
+(instancetype)sharedManager;
-(void)changeTheme:(ChatThemeType)type;
//获取资源bundle
+(NSString *)getChatResourceBundle;

//主色

@property (nonatomic,strong,readonly) UIColor *globleBackgroudColor;//全局背景色

@property (nonatomic,strong,readonly) UIColor *redColor;
@property (nonatomic,strong,readonly) UIColor *whiteColor;    //#ffffff
//辅助色
@property (nonatomic,strong,readonly) UIColor *textViewBgColor;     //#f1f4fb
/*
 橙色色按钮颜色#ff5b29（以前为黄色，现在是橙色)
 **/
@property (nonatomic,strong,readonly) UIColor *orangeColor;     //0xff5b29
@property (nonatomic,strong,readonly) UIColor *orangeSelectColor;//黄色按钮选中的颜色，“透明度 0.9”
/*
 秒杀的独特颜色 #FF2751
**/
@property (nonatomic,strong,readonly) UIColor *seckillColor;//秒杀的独特颜色 #FF2751

@property (nonatomic,strong,readonly) UIColor *grayTextColor;
@property (nonatomic,strong,readonly) UIColor *selectedCellColor; //选中背景颜色
@property (nonatomic,strong,readonly) UIColor *blackFontColor; //2.0默认黑色字体
@property (nonatomic,strong,readonly) UIColor *grayFontColor;  //2.0默认灰色字体
@property (nonatomic,strong,readonly) UIColor *grayFont9b9b9bColor;  //9b9b9b灰色字体
@property (nonatomic,strong,readonly) UIColor *navTitleColor;
@property (nonatomic,strong,readonly) UIColor *silveryGrayFontColor;  //2.0默认银灰色字体

//线条
@property(nonatomic,strong,readonly) UIColor  *grayLineColor;

//字体
@property (nonatomic,strong,readonly) UIFont *navTitleFont;//标签字 (34pt)
@property (nonatomic,strong,readonly) UIFont *navRightTitleFont;//nav右侧按钮 (28pt)
@property (nonatomic,strong,readonly) UIFont *textFont;//正文 (14pt)
//用来存储活动中定位城市信息
@property (nonatomic,strong) NSMutableArray *uploadCodeArr;
@end

NS_ASSUME_NONNULL_END
