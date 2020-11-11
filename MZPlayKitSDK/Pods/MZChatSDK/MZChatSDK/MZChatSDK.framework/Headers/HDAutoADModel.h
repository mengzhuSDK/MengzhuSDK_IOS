//
//  HDAutoADModel.h
//  TestFunction
//
//  Created by 怀达 on 2019/8/26.
//  Copyright © 2019 white. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDCustomTextADModel.h"
NS_ASSUME_NONNULL_BEGIN
@interface MZADDataModel : NSObject
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *value;
@end

@interface HDAutoADModel : NSObject

@property (nonatomic,assign) int type;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,copy) NSString *link;
@property (nonatomic ,copy) NSArray *data;
@property (nonatomic ,strong) HDCustomTextADModel *style;
@property (nonatomic ,copy) NSString *img_url;
@property (nonatomic ,assign) int sub_type;// // 1：纯色，2：图片背景


@end

NS_ASSUME_NONNULL_END
