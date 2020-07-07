//
//  MZChatKitManager.h
//  MZMediaSDK
//
//  Created by 孙显灏 on 2019/9/25.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZLiveModel.h"
#import "MZLongPollDataModel.h"
#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

@protocol MZChatKitDelegate<NSObject>
/*!
 直播时参会人数发生变化
 */
-(void)activityOnlineNumberdidchange:(NSString * )onlineNo;
/*!
 直播时礼物数发生变化
 */
-(void)activityOnlineNumGiftchange:(NSString *)onlineGiftMoney;
/*!
 直播时收到一条新消息
 */
-(void)activityGetNewMsg:(MZLongPollDataModel * )msg;
@end

@interface MZChatKitManager : NSObject

@property (nonatomic,weak)id<MZChatKitDelegate> delegate;


/*!
 直播发送聊天信息
 */
 +(void)sendText:(NSString *)msgText host:(NSString *)hostUrl token:(NSString *)token userID:(NSString*)userID userNickName:(NSString*)userNickName userAvatar:(NSString*)userAvatar isBarrage:(BOOL)isBarrage success:(void(^)(MZLongPollDataModel * msgModel))success failure:(void(^)(NSError * error))failure;

/*!
 直播长连接
 */
- (void)setLongPoll:(NSString *)receive_url;
/*!
 断开直播长连接
 */
- (void)closeLongPoll;

//直播发起不需要连接socketIO
/*!
 直播socketIO
 */
- (void)setSocketIO:(NSString *)srv token:(NSString*)token block:(socketCreatBlock)block;
/*!
 关闭直播socketIO
 */

-(void)sendSocketMessageWithEvent:(NSString *)event content:(NSArray *)content;


- (void)closeSocketIO;
//启动及时消息及socket
-(void)startTimelyChar:(NSString*)ticket_id receive_url:(NSString*)receive_url srv:(NSString *)srv token:(NSString*)token;

@end

