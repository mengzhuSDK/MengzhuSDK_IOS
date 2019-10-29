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

@property (nonatomic ,strong)UIButton *headerBtn;
@property (nonatomic ,strong)UILabel *titleL;
@property (nonatomic ,strong)UILabel *numL;
@property (nonatomic ,strong)UIButton *subBtn;
@property (nonatomic ,strong) UIButton *attentionBtn;
@end


