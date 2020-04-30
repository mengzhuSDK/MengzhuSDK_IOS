//
//  MZLiveUserModel.h
//  MengZhuPush
//
//  Created by LiWei on 2019/10/9.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZLiveUserModel : NSObject

@property (nonatomic ,strong)NSString *uid;
@property (nonatomic ,strong)NSString *nickname;
@property (nonatomic ,strong)NSString *avatar;
@property (nonatomic ,assign)BOOL is_banned;
@property (nonatomic ,strong)NSString *lives;//直播数
@property (nonatomic ,strong)NSString *attentions;// 关注数
@property (nonatomic ,strong)NSString *likes;// 点赞数
@end

NS_ASSUME_NONNULL_END
