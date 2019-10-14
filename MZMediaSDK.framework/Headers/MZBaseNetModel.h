//
//  MZBaseNetModel.h
//  MengZhu
//
//  Created by vhall on 16/6/22.
//  Copyright © 2016年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MZMJExtension.h"


@interface MZBaseNetModel : NSObject

@property (strong, nonatomic) NSString* code;
@property (strong, nonatomic) NSString* msg;
@property (strong, nonatomic) id data;

-(id)initWithDictionary:(NSDictionary*)dict;
@end
