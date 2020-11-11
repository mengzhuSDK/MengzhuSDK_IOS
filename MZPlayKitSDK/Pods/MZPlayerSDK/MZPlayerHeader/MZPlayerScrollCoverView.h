//
//  MZPlayerScrollCoverView.h
//  MengZhu
//
//  Created by 李伟 on 2020/2/25.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZMovieCoverPageControl.h"

NS_ASSUME_NONNULL_BEGIN

//typedef void(^ItemDidScrollBlock)(NSInteger index);

@interface MZPlayerScrollCoverView : UIView

@property (nonatomic,strong)NSArray *imageArr;
//@property (nonatomic,copy)ItemDidScrollBlock itemDidScrollBlock;
@property (nonatomic,strong)MZMovieCoverPageControl *coverPageControl;

@end

NS_ASSUME_NONNULL_END
