//
//  MZBarrageBgView.h
//  MengZhu
//
//  Created by 李伟 on 2019/5/13.
//  Copyright © 2019 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    BarrageViewStartType,
    BarrageViewPauseType,
    BarrageViewStopType,
    BarrageViewOtherType,//未知
} BarrageViewActionType;
NS_ASSUME_NONNULL_BEGIN

@interface MZBarrageBgView : UIView


//- (void)walkImageTextSpriteDescriptorAWithData:(MZLongPollDataModel *)model;
/*
 该字典包含 @"text"弹幕内容，@"avatar"弹幕头像，@"userName"弹幕的用户昵称,@"userId"发弹幕的用户ID
 */
- (void)start;
- (void)pause;
- (void)stop;  
- (void)walkImageTextSpriteDescriptorAWithData:(NSDictionary *)longPollDic;
//- (void)walkImageTextSpriteDescriptorAWithCustomData:(MZLongPollDataModel *)model;
@end

NS_ASSUME_NONNULL_END
