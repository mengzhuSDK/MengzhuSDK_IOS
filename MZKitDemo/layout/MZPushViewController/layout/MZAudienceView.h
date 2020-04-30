//
//  MZAudienceView.h
//  MengZhu
//
//  Created by vhall on 16/6/24.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZBaseView.h"
#import "MZDismissVew.h"

@interface MZAudienceView : MZBaseView<MZDismissVew>

-(void)showWithView:(UIView *)view withJoinTotal:(int)total ;
//-(void)setSelectAction:(void(^)(NSString * userId))action loadMore:(void(^)(void(^finish)(NSArray * userList)))loadMore;
-(void)setUserList:(NSArray*)userList withChannelId:(NSString *)chanelId ticket_id:(NSString *)ticket_id;

@end
