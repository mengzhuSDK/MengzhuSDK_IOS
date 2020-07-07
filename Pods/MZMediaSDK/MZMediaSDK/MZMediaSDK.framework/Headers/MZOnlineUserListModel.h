//
//  MZOnlineUserListModel.h
//  MZMediaSDK
//
//  Created by 孙显灏 on 2019/10/9.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MZOnlineUserListModel : NSObject
@property (nonatomic,assign)int is_gag;
@property (nonatomic,strong)NSString * role_name;
@property (nonatomic,strong)NSString * nickname;
@property (nonatomic,strong)NSString * uid;
@property (nonatomic,strong)NSString * avatar;
@property (nonatomic ,copy) NSString *unique_id;//用户唯一id
@end

