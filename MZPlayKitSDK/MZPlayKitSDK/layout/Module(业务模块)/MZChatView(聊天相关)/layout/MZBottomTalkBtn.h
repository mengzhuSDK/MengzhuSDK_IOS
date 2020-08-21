//
//  MZBottomTalkBtn.h
//  MengZhuPush
//
//  Created by LiWei on 2019/9/25.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

typedef void(^LiveBottomClickBlock)();

@interface MZBottomTalkBtn : UIView
@property (nonatomic,assign) BOOL isBanned;//是否是禁言状态
@property (nonatomic,copy) LiveBottomClickBlock bottomClickBlock;
@end

NS_ASSUME_NONNULL_END
