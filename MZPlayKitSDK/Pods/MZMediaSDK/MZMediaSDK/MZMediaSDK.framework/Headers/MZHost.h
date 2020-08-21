//
//  MZHost.h
//  MengZhu
//
//  Created by ZhangHeng on 2016/12/15.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

@interface MZHost : MZBaseModel

@property(nonatomic,strong)NSString *alias_id;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *avatar_path;
@property(nonatomic,assign)int level;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,assign)int recommend_uid;
@property(nonatomic,strong)NSString *role_name;
@property(nonatomic,assign)int uid;

@end


//"alias_id" = "";
//avatar = "http://s1.dev.mengzhu.live/upload/img/12/2d/122d2274c86b37ea41b0be4a7a87f640.png";
//"avatar_path" = "/upload/img/12/2d/122d2274c86b37ea41b0be4a7a87f640.png";
//level = 1;
//nickname = iPermanent;
//"recommend_uid" = 1;
//"role_name" = host;
//uid = 2991333;
