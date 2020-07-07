//
//  VHChatView.h
//  VhallIphone
//
//  Created by vhall on 15/8/20.
//  Copyright (c) 2015年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MZChatViewDelegate <NSObject>

- (void)didSelectLivePollingDate:(MZLongPollDataModel *)pollingDate;
- (void)showKeyBoard:(NSString*)userName JoinID:(NSString*)joinID;
- (void)viewCutLevel:(BOOL)isCut;
@optional
- (void)didClickRedBag:(MZLongPollDataModel *)pollingDate;
- (void)didClickVisitCardRedBag:(MZLongPollDataModel *)pollingDate;
//- (void)didClickSpace;
@end

@interface MZChatView : UIView
@property (weak, nonatomic) id<MZChatViewDelegate> delegate;
@property (strong, nonatomic)UIFont *talkFont;
@property(nonatomic,assign)float iconHeight;//头像高度
@property(nonatomic,assign)BOOL is_Public;
@property(nonatomic,strong) MZLongPollDataModel *pollingDate;
@property(nonatomic,assign) BOOL isVoice;

//-(void)addTalk:(NSString*)talkstr userId:(NSString*)userID  Icon:(NSString*)icon;
//-(void)addPayNotiName:(NSString*)payName payFree:(NSString*)payFree  icon:(NSString*)icon;//支付提示
@end
