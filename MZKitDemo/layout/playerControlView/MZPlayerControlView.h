//
//  MZPlayerControlView.h
//  MZKitDemo
//
//  Created by Cage  on 2019/10/9.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZBaseView.h"

@protocol MZPlayerControlViewProtocol <NSObject>

//
-(void)avatarDidClick:(id)playInfo;
-(void)reportButtonDidClick:(id)playInfo;
-(void)shareButtonDidClick:(id)playInfo;
-(void)likeButtonDidClick:(id)playInfo;
-(void)onlineListButtonDidClick:(id)playInfo;
-(void)shoppingBagDidClick:(id)playInfo;
//
-(void)attentionButtonDidClick:(id)playInfo;
-(void)closeButtonDidClick:(id)playInfo;
-(void)chatUserDidClick:(id)playInfo;
//商品的点击事件
-(void)goodsItemDidClick:(MZGoodsListModel *)GoodsListModel;
//聊天头像点击事件
-(void)chatUserHeaderDidClick:(MZLongPollDataModel *)GoodsListModel;
@end
@interface MZPlayerControlView : MZBaseView

@property (nonatomic ,weak) id<MZPlayerControlViewProtocol> playerDelegate;
@property (nonatomic ,strong)NSString *ticket_id;

@property (nonatomic ,strong)NSString *UserUID;
@property (nonatomic ,strong)NSString *UserName;
@property (nonatomic ,strong)NSString *UserAvatar;

-(void)playVideoWithLiveIDString:(NSString *)ticket_id;
-(void)playerShutDown;
@end


