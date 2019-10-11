//
//  MZLiveAudienceHeaderView.h
//  MengZhuPush
//
//  Created by LiWei on 2019/9/24.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZLiveAudienceHeaderView : UIView

@property (nonatomic ,strong)NSArray *imageUrlArr;
@property (nonatomic ,strong)NSString *numStr;
@property (nonatomic ,strong) void(^clickBlock)(void);

@end

NS_ASSUME_NONNULL_END
