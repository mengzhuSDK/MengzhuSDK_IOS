//
//  MZDiscussModel.h
//  MZMediaSDK
//
//  Created by 李风 on 2020/8/18.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZDiscussReplyModel : NSObject

@property (nonatomic,   copy) NSString *id;//回复ID
@property (nonatomic,   copy) NSString *nickname;//回复者昵称
@property (nonatomic,   copy) NSString *content;//回复内容
@property (nonatomic,   copy) NSString *avatar;//回复者头像
@property (nonatomic,   copy) NSString *created_at;//
@property (nonatomic,   copy) NSString *datetime;//回复时间

@end

@interface MZDiscussModel : NSObject

@property (nonatomic,   copy) NSString *id;//问题ID
@property (nonatomic,   copy) NSString *uid;//提问用户uid
@property (nonatomic,   copy) NSString *datetime;//提问时间
@property (nonatomic,   copy) NSString *content;//提问内容
@property (nonatomic, assign) NSInteger is_anonymous;//是否匿名，1匿名 2非匿名
@property (nonatomic,   copy) NSString *nickname;//提问者昵称
@property (nonatomic,   copy) NSString *avatar;//提问者头像
@property (nonatomic, strong) NSMutableArray <MZDiscussReplyModel *> *replys;//回复列表

@end

NS_ASSUME_NONNULL_END
