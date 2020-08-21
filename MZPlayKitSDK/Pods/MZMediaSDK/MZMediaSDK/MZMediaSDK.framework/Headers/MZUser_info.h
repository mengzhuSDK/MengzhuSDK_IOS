//
//  MZUser_info.h
//  MengZhu
//
//  Created by vhall on 2016/10/21.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

@interface MZUser_info : MZBaseModel

@property(nonatomic,assign)int          alias_id;
@property(nonatomic,assign)int          area;
@property(nonatomic,assign)int          city;
@property(nonatomic,assign)int          province;
@property(nonatomic,strong)NSString     *avatar;
@property(nonatomic,strong)NSString     *avatar_path;
@property(nonatomic,strong)NSString     *birthday;
@property(nonatomic,assign)int          created_at;
@property(nonatomic,strong)NSString     *email;
@property(nonatomic,assign)int          from;
@property(nonatomic,strong)NSString     *idcard;
@property(nonatomic,assign)int          level;
@property(nonatomic,assign)int          nation;
@property(nonatomic,strong)NSString     *nickname;
@property(nonatomic,assign)int          original_area;
@property(nonatomic,assign)int          original_city;
@property(nonatomic,assign)int          original_province;
@property(nonatomic,assign)int          phone;
@property(nonatomic,assign)int          recommend_uid;
@property(nonatomic,assign)long long    register_ip;
@property(nonatomic,assign)int          sex;
@property(nonatomic,assign)int          status;
@property(nonatomic,assign)int          tel;
@property(nonatomic,assign)int          uid;
@property(nonatomic,assign)int          updated_at;
@property(nonatomic,assign)int          product_level;

@property(nonatomic,strong)NSString     *username;
@property(nonatomic,strong)NSString     *wechat_id;
@property(nonatomic,assign)int          is_personal_auth;//是否用户实名认证 : 0否 1是
@property(nonatomic,assign)int          is_company_auth;//是否企业认证: 0否 1是

@end


