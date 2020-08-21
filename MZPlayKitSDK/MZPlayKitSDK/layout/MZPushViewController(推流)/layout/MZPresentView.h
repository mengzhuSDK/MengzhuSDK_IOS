//
//  MZPresentView.h
//  MengZhu
//
//  Created by vhall on 16/6/24.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZBaseView.h"

@interface MZPresentView : MZBaseView<MZDismissVew>

-(void)showWithView:(UIView *)view withJoinTotal:(NSString *)total;
//-(void)setSelectAction:(void(^)(NSString * userId))action loadMore:(void(^)(void(^finish)(NSArray * userList)))loadMore;
-(void)setGiftList:(NSArray*)userList;
@end
