//
//  MZPresentListModel.h
//  MengZhu
//
//  Created by vhall on 16/6/25.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <MZCoreSDKLibrary/MZCoreSDKLibrary.h>

@interface MZPresentListModel : MZBaseNetModel
@property (nonatomic,strong) NSString * id;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * price;
@property (nonatomic,strong) NSString * num;
@property (nonatomic,strong) NSString * icon;
@property (nonatomic,strong) NSString * type;

@end
