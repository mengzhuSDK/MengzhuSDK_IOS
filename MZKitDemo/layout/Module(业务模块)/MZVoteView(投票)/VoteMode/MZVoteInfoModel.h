//
//  MZVoteInfoModel.h
//  MengZhu
//
//  Created by 李伟 on 2018/2/1.
//  Copyright © 2018年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @brief 投票的每一个选项的模型
 */

@interface MZVoteOptionModel : NSObject

@property (nonatomic,   copy) NSString *id;//该选项的id
@property (nonatomic,   copy) NSString *vote_id;//该选项所属的投票id
@property (nonatomic,   copy) NSString *title;//该选项的标题
@property (nonatomic,   copy) NSString *image;//该选项的图片
@property (nonatomic, assign) int vote_num;//该选项的已投票数
@property (nonatomic, assign) int percentage;//该选项的已投百分比
@property (nonatomic, assign) BOOL is_vote;//该选项自己是否已投

@end


/**
* @brief 该投票的所有详细信息
*/

@interface MZVoteInfoModel : NSObject

@property (nonatomic,   copy) NSString *id;// 该场投票ID
@property (nonatomic,   copy) NSString *channel_id;//频道id
@property (nonatomic,   copy) NSString *uid;//用户id
@property (nonatomic,   copy) NSString *question;//问题
@property (nonatomic, assign) int       type;//投票类型 0:文字投票 1:图文投票
@property (nonatomic, assign) int       select_type;//投票选择类型 0:单选 1:多选
@property (nonatomic, assign) int       max_select;// 最多选择项限制
@property (nonatomic, assign) int       status;// 投票状态 0:下线 1:上线
@property (nonatomic, assign) BOOL      is_deleted;//是否删除 0:否 1:是
@property (nonatomic, assign) BOOL      is_vote;//是否已投过票 0:否 1:是
@property (nonatomic, assign) BOOL      is_expired;//是否过期 0:否 1:是
@property (nonatomic,   copy) NSString *created_at;//创建时间
@property (nonatomic,   copy) NSString *end_time;//结束时间

@end
