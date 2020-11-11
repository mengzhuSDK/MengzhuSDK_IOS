//
//  MZRollingADPresenter.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/9/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZRollingADPresenter : NSObject

/**
 * 获取活动滚动广告
 *
 * @param ticketId 直播活动Id
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)getRollAdvertWithTicketId:(NSString *)ticketId success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
