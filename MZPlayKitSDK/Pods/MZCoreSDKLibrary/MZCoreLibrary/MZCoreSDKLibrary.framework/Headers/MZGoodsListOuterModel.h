//
//  MZGoodsListOuterModel.h
//  MZMediaSDK
//
//  Created by 孙显灏 on 2019/10/9.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZGoodsListOuterModel : NSObject
@property (nonatomic,strong) NSMutableArray* list;
@property (nonatomic,assign) int total;

+(instancetype)initModel:(id)responseObject;
@end

