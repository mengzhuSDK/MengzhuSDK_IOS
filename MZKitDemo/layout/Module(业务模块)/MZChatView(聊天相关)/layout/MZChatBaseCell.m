//
//  MZChatBaseCell.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZChatBaseCell.h"

NSString * const MZMsgTypeMeChat    = @"MZMsgTypeMeChat";
NSString * const MZMsgTypeOnline    = @"MZMsgTypeOnline";
NSString * const MZMsgTypeGetReward = @"MZMsgTypeGetReward";
NSString * const MZMsgTypeGetGift   = @"MZMsgTypeGetGift";
NSString * const MZMsgTypeOtherChat = @"MZMsgTypeOtherChat";
NSString * const MZMsgTypeSendRedBag = @"MsgTypeSendRedBag";
NSString * const MZMsgTypeGoodsUrl = @"MsgTypeGoodsUrl";
NSString * const MZMsgTypeHistoryRecordLabel = @"MZMsgTypeHistoryRecordLabel";
NSString * const MZMsgTypeNotice = @"MZMsgTypeNotice";
NSString * const MZMsgTypeLiveTip = @"MZMsgTypeLiveTip";
NSString * const MZMsgTypeBuyMsg = @"MZMsgTypeBuyProductMsg";
NSString * const MZMsgTypeObtainResultMsg = @"MSgTypeObtainResultMsg";
NSString * const MZMsgTypeVisitCardRedBag = @"MZMsgTypeVisitCardRedBag";
NSString * const MZMsgTypeCircleGeneralizeMsg=@"MZMsgTypeCircleGeneralizeMsg";

@implementation MZChatBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
