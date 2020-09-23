//
//  UIView+MZPlayPermission.h
//  MZKitDemo
//
//  Created by 李风 on 2020/9/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MZPlayPermission)

/**
 * @brief 检测观看权限
 *
 * @param ticketId 直播活动ID
 * @param phone 用户手机号
 * @param success 权限检测结果的回调
 * @param cancelButtonClick 返回按钮点击事件
 */
- (void)checkPlayPermissionWithTicketId:(NSString *)ticketId phone:(NSString *)phone success:(void(^)(BOOL isPermission))success cancelButtonClick:(void(^)(void))cancelButtonClick;

@end

NS_ASSUME_NONNULL_END
