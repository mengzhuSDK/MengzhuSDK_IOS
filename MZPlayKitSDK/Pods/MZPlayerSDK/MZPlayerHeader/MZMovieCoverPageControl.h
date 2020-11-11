//
//  MZMovieCoverPageControl.h
//  MengZhu
//
//  Created by 李伟 on 2020/2/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZMovieCoverPageControl : UIPageControl
@property (nonatomic,assign)CGFloat pageW;//原点宽度
@property (nonatomic,assign)CGFloat pageH;//原点高度
@property (nonatomic,assign)CGFloat spaceW;//原点间距
@property (nonatomic,strong)UIImage *currentPointImage;//当前点
@property (nonatomic,strong)UIImage *otherPointImage;//原点间距
@end

NS_ASSUME_NONNULL_END
