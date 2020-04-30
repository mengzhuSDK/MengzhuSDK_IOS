//
//  MZReadyLiveCellBtn.h
//  MengZhu
//
//  Created by 李伟 on 2019/4/16.
//  Copyright © 2019 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZReadyLiveCellBtn : UIButton
@property (nonatomic ,strong)UILabel *keyLabel;
@property (nonatomic ,strong)UILabel *valueLabel;
@property (nonatomic,assign) BOOL isShowSelectView;
@property (nonatomic,assign) BOOL isSelectStatue;
@property (nonatomic ,strong) UIView *lineView;
@end
