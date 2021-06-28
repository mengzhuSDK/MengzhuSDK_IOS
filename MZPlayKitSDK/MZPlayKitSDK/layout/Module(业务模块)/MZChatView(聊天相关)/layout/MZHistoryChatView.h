//
//  MZHistoryChatView.h
//  MZKitDemo
//
//  Created by LiWei on 2019/10/9.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZHistoryChatViewProtocol <NSObject>

-(void)historyChatViewUserHeaderClick:(MZLongPollDataModel *)msgModel;

-(void)redPackageClick:(MZLongPollDataModel *)msgModel;

@end

typedef enum : NSUInteger {
    MZChatCellType_Normal = 0,//使用默认的cell布局
    MZChatCellType_New,//使用新版本cell布局
} MZChatCellType;


@interface MZHistoryChatView : UIView
@property (nonatomic,   weak) id<MZHistoryChatViewProtocol> chatDelegate;
@property (nonatomic, strong) NSMutableArray *dataArray; //显示的数据源
@property (nonatomic, strong) NSString *ticket_id;
@property (nonatomic, strong) MZMoviePlayerModel *activity;//播放器的详情model

@property (nonatomic, assign) BOOL isHideChatHistory;//是否显示历史数据
@property (nonatomic, assign) BOOL isLiveHost;//是否是主播直播端，默认为NO

@property (nonatomic, strong) MZHostModel *hostModel;//主播信息

@property (nonatomic, strong) MZChatApiManager *chatApiManager;//聊天API具柄

- (instancetype)initWithFrame:(CGRect)frame cellType:(MZChatCellType)cellType;
- (void)addChatData:(MZLongPollDataModel *)dataModel;
- (void)reloadData;
- (void)dismissInput;
- (void)showGoods;
- (void)scrollToBottom;

///上线按钮是否覆盖到聊天界面上
- (void)onlineButtonIsCoverAtChatView:(BOOL)isCoverAtChatView;

///添加一条公告信息
- (BOOL)addNotice:(NSString *)notice;

///切换 只看主播 按钮状态后，展示对应的消息
- (void)updateOnlyHostState:(BOOL)isOnlyHost;

@end


