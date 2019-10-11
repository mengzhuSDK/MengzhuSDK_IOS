//
//  MZTipGoodsView.h
//  MZKitDemo
//
//  Created by LiWei on 2019/9/27.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZTipGoodsView : UIView
@property (nonatomic ,strong)NSMutableArray *goodsListModelArr;
//@property (nonatomic,assign) BOOL isEnd;
-(void)beginAnimation;//开启动画
-(void)stopAnimation;//关闭动画


@end

NS_ASSUME_NONNULL_END
