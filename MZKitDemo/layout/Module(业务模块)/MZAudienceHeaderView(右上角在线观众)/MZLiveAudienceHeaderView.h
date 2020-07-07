//
//  MZLiveAudienceHeaderView.h
//  MengZhuPush
//
//  Created by LiWei on 2019/9/24.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface MZLiveAudienceHeaderView : UIView

@property (nonatomic ,strong)NSArray *userArr;

@property (nonatomic ,strong) void(^clickBlock)(void) ;

@end

NS_ASSUME_NONNULL_END
