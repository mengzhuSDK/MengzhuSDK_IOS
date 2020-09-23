//
//  MZWebinar_info.h
//  MengZhu
//
//  Created by vhall on 2016/12/10.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

@interface MZWebinar_info : MZBaseModel

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *cover_url;
@property(nonatomic,strong)NSString *duration;
@property(nonatomic,assign)int channel_id;

@end
