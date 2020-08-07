//
//  MZDLNAPlayingView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MZDLNAControlTypePlay = 0,//播放
    MZDLNAControlTypePause,//暂停
    MZDLNAControlTypeChange,//更换设备
    MZDLNAControlTypeExit,//退出
} MZDLNAControlType;

typedef void(^MZDLNAControlBlock)(MZDLNAControlType type);

NS_ASSUME_NONNULL_BEGIN

@interface MZDLNAPlayingView : UIView

@property (nonatomic,   copy) MZDLNAControlBlock controlBlock;//按钮点击事件的回调

@property (nonatomic, strong) UIView *bgView;//承载这些按钮的View，比例默认为 9:16
@property (nonatomic, strong) UILabel *playingTitleLabel;//投屏中的标题Label
@property (nonatomic, strong) UILabel *playingContentLabel;//投屏中的内从Label
@property (nonatomic, strong) UIButton *changeDeviceButton;//更换投屏的按钮
@property (nonatomic, strong) UIButton *exitButton;//退出投屏的按钮

@end

NS_ASSUME_NONNULL_END
