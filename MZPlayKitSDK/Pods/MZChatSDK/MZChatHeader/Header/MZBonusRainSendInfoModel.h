//
//  MZBonusRainSendInfoModel.h
//  AFNetworking
//
//  Created by 李伟 on 2020/11/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZBonusRainSendInfoModel : NSObject

@property(nonatomic ,strong)NSString *grant_time;//发放时间
@property(nonatomic ,strong)NSString *duration;//持续时长
@property(nonatomic ,strong)NSString *bid;//红包ID


@end

NS_ASSUME_NONNULL_END
