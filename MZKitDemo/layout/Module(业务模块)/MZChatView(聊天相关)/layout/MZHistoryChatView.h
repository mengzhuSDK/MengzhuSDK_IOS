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

@end

typedef enum : NSUInteger {
    MZChatCellType_Normal = 0,//使用默认的cell布局
    MZChatCellType_New,//使用新版本cell布局
} MZChatCellType;


@interface MZHistoryChatView : UIView
@property (nonatomic ,weak) id<MZHistoryChatViewProtocol> chatDelegate;
@property(nonatomic,strong)NSMutableArray *dataArray; //观看回放 加载数据 ， 观看直播 轮训数据
@property (nonatomic ,strong)NSString *ticket_id;
@property(nonatomic,strong)MZMoviePlayerModel *activity;//播放器的详情model

-(instancetype)initWithFrame:(CGRect)frame cellType:(MZChatCellType)cellType;
-(void)addChatData:(MZLongPollDataModel *)dataModel;
-(void)reloadData;
-(void)dismissInput;
-(void)showGoods;
-(void)scrollToBottom;

@end


