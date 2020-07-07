//
//  MZDLNAView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MZDLNADeviceSelectBlock)(MZCLUPnPDevice *model);
typedef void(^HelpClickBlock)(void);

@protocol MZDLNAViewDelegate <NSObject>
/// 开始投屏
- (void)dlnaStartPlay;
@end


@interface MZDLNAView : UIView

@property (nonatomic,   copy) HelpClickBlock helpClickBlock;

@property (nonatomic, strong) UIView *fuctionView;//展示的设备界面
@property (nonatomic, strong) NSArray *deviceArr;//可投屏设备数据源
@property (nonatomic,   copy) NSString *DLNAString;//投屏的视频地址

@property (nonatomic,   weak) id <MZDLNAViewDelegate>delegate;

/// 停止投屏（开始投屏后，停止投屏调用）
- (void)stopDLNA;

@end

NS_ASSUME_NONNULL_END
