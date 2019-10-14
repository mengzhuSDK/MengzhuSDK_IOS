//
//  MZBaseModel.h
//  MengZhu
//
//  Created by vhall on 16/8/1.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZBaseModel : NSObject<NSCoding>


/**
 *  @author Henry
 *
 *  可以直接声明propertyName和返回数据里的json完全一致，这样不用自己重新写任何解析代码，生成方式支持多重复杂递归包含关系
 *
 *  @param dict 需要解析的字典
 *
 *  @return 转化好的模型
 */
-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
