//
//  MZCreatPredictTipsModel.h
//  MZCoreSDKLibrary
//
//  Created by LiWei on 2020/8/3.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZCreatPredictTipsModel : NSObject

@property (nonatomic ,copy)   NSString *title;
@property (nonatomic ,copy)   NSString *content;
@property (nonatomic ,copy)   NSString *leftStr;
@property (nonatomic ,copy)   NSString *rightStr;
@property (nonatomic ,assign) BOOL isNoClost;

@end

NS_ASSUME_NONNULL_END
