//
//  MZLiveManagerHearderView.h
//  MengZhuPush
//
//  Created by LiWei on 2019/9/24.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLiveManagerHearderView : UIView

@property (nonatomic ,strong)NSString *imageUrl;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSString *numStr;
@property (nonatomic ,strong) void(^clickBlock)(void);
@property (nonatomic ,strong) void(^attentionClickBlock)(void);


@end


