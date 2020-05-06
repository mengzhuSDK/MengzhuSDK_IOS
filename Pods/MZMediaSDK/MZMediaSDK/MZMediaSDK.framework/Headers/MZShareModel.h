//
//  MZShareModel.h
//  MengZhu
//
//  Created by vhall on 16/8/23.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZShareModel : NSObject
@property (nonatomic,strong) NSString * channelID;
@property (nonatomic ,strong)NSString *ticketId;
@property (nonatomic,strong) NSString * channelName;
@property (nonatomic ,strong)NSString *url;
@property (nonatomic,strong) NSString * qrUrl;//二维码
@property (nonatomic,strong) NSString * shortUrl;//短链接
@property (nonatomic,strong) NSString * shareTitle;
@property (nonatomic,strong) NSString * shareDesc;
@property (nonatomic,strong) NSString * shareImage;
+(MZShareModel *)initWithDict:(id)responseObject;
@end
