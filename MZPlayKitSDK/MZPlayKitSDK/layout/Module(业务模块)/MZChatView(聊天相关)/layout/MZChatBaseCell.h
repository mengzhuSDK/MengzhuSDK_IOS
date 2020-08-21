//
//  MZChatBaseCell.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

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

@interface MZChatBaseCell : UITableViewCell

@end

NS_ASSUME_NONNULL_END
