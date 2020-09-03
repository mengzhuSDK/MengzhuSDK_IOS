//
//  MZGiftView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/8/17.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZGiftView : UIView

@property (nonatomic, strong) NSMutableArray *dataArray;//礼物数据源
@property (nonatomic, strong) UICollectionView *collectionView;//collectionView

/// 礼物View实例化
- (instancetype)initWithTicketId:(NSString *)ticketId selectHandler:(void(^)(NSString *giftId, int quantity))handler;

/// 展示礼物界面
- (void)show;
/// 隐藏礼物界面
- (void)hide;

/// 礼物已经支付成功后，调用此方法通知消息服务器，让消息服务器发送礼物购买成功的消息给直播间
/// giftId 礼物ID
/// quantity 礼物个数
- (void)pushGiftMessageWithGiftId:(NSString *)giftId quantity:(int)quantity;

@end

NS_ASSUME_NONNULL_END
