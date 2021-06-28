//
//  MZBlockManagerView.h
//  MZKitDemo
//
//  Created by 李风 on 2021/6/17.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZBlockManagerView : UIView

- (instancetype)initWithFrame:(CGRect)frame ticket_id:(NSString *)ticket_id channel_id:(NSString *)channel_id chatIdOfMe:(NSString *)chatIdOfMe onlineUserTableView:(UITableView *)onlineUserTableView;
- (void)updateData;

@end

NS_ASSUME_NONNULL_END
