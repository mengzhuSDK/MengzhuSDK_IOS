//
//  MZChatTableViewCell.h
//  MengZhu
//
//  Created by developer_k on 16/7/15.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^GetImgHeightBlock)(BOOL);

extern NSString * const MZMsgTypeMeChat;
extern NSString * const MZMsgTypeOnline;
extern NSString * const MZMsgTypeGetReward;
extern NSString * const MZMsgTypeGetGift;
extern NSString * const MZMsgTypeOtherChat;
extern NSString * const MZMsgTypeSendRedBag;
extern NSString * const MZMsgTypeHistoryRecordLabel;
extern NSString * const MZMsgTypeNotice;
extern NSString * const MZMsgTypeLiveTip;
extern NSString * const MZMsgTypeBuyMsg;
extern NSString * const MZMsgTypeObtainResultMsg;
extern NSString * const MZMsgTypeVisitCardRedBag;
extern NSString * const MZMsgTypeCircleGeneralizeMsg;
extern NSString * const MZMsgTypeGoodsUrl;



@interface MZChatTableViewCell : UITableViewCell
@property (nonatomic ,copy) NSString *role_name;
+ (float)getCellHeight:(MZLongPollDataModel *)pollingDate cellWidth:(CGFloat)cellWidth;
@property(nonatomic,strong) MZLongPollDataModel *pollingDate;
@property (nonatomic,copy)void(^headerViewAction)(MZLongPollDataModel *);
@property (nonatomic,copy)void(^headerViewLongPress)(MZLongPollDataModel *);
@property (nonatomic,copy)void(^bgViewAction)(MZLongPollDataModel *);
@property (nonatomic,copy)void(^circleGeneralizeClick)(MZLongPollDataModel *);
@property (nonatomic,copy)void(^goodsImageAction)(MZLongPollDataModel *);
@property (nonatomic ,copy) void (^redBgViewAction)(MZLongPollDataModel *);
@property (nonatomic,copy) GetImgHeightBlock imgHeightBlock;//获取图片高度后刷新

@end
