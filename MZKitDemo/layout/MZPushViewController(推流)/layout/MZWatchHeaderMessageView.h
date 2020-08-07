//
//  MZWatchHeaderMessageView.h
//  MengZhu
//
//  Created by developer_k on 16/6/29.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDismissVew.h"

typedef NS_ENUM(NSUInteger, HeadViewActionType) {
    HeadViewActionTypeResport,
    HeadViewActionTypeDefriend,
    HeadViewActionTypeGoToUserCenter,
    HeadViewActionTypeFollow,
    HeadViewActionTypeStation,
    HeadViewActionTypeCancle,
    HeadViewActionTypeKick,//踢出
    HeadViewActionTypeBlock,//禁言
    HeadViewActionTypePrivateMessage,
};
//typedef NS_ENUM(NSUInteger, HeadViewLayoutType) {
//    HeadViewLayoutTypePlay,
//    HeadViewLayoutTypeLive
//};
@class MZWatchHeaderMessageView;

@interface MZWatchHeaderMessageView : UIButton<MZDismissVew>

@property (nonatomic ,assign) BOOL isMySelf;
@property (nonatomic ,assign) BOOL isManager;
@property (nonatomic ,strong) MZLiveUserModel *otherUserInfoModel;

//@property (nonatomic ,strong)NSString *liveNumStr;//直播量
//@property (nonatomic ,strong)NSString *attentionNumStr;//关注量
//@property (nonatomic ,strong)NSString *followNumStr;//获赞量

-(void)showWithView:(UIView *)view action:(void(^)(HeadViewActionType actionType))action;

-(void)dismiss;

@end
