//
//  MZPopView.m
//  MZKitDemo
//
//  Created by Cage  on 2019/9/28.
//  Copyright © 2019 mengzhu.com. All rights reserved.
//

#import "MZPopView.h"

@implementation MZPopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self setBaseProperty];
    }
    return self;
}
- (void)setBaseProperty{
    self.backgroundColor = MakeColorRGBA(0x000000, 0.4);
    
    
}
- (void)setViewType:(MZPopViewType)viewType{
    _viewType = viewType;
    if (viewType == MZPopViewReport) {
        [self customAddSubviewsReport];
    }else if (viewType == MZPopViewKickOut){
        [self customAddSubviewsKickOut];
    }
}
- (void)customAddSubviewsReport{
//    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 285*MZ_RATE, 289*MZ_RATE)];
//    [self addSubview:containerView];
//    containerView.backgroundColor = [UIColor whiteColor];
//    [containerView roundChangeWithRadius:12*MZ_RATE ];
//    containerView.center = self.center;
//    
//    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(27, 67, 62, 28)];
//    [containerView addSubview:one];
//    [one setTitle:@"涉黄" forState:UIControlStateNormal];
//    [one roundChangeWithRadius:18*MZ_RATE];
//    one.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [one setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [one setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [one setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [one addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *two = [[UIButton alloc] initWithFrame:CGRectMake(99, 67, 62, 28)];
//    [containerView addSubview:two];
//    [two setTitle:@"虚假" forState:UIControlStateNormal];
//    [two roundChangeWithRadius:18*MZ_RATE];
//    two.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [two setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [two setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [two setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [two addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *three = [[UIButton alloc] initWithFrame:CGRectMake(171, 67, 62, 28)];
//    [containerView addSubview:three];
//    [three setTitle:@"血腥" forState:UIControlStateNormal];
//    [three roundChangeWithRadius:18*MZ_RATE];
//    three.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [three setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [three setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [three setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [three addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *four = [[UIButton alloc] initWithFrame:CGRectMake(27, 110, 87, 28)];
//    [containerView addSubview:four];
//    [four setTitle:@"分裂国家" forState:UIControlStateNormal];
//    [four roundChangeWithRadius:18*MZ_RATE];
//    four.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [four setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [four setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [four setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [four addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *five = [[UIButton alloc] initWithFrame:CGRectMake(0, 107*MZ_RATE, 315/2.0*MZ_RATE, 44*MZ_RATE)];
//    [containerView addSubview:five];
//    [five setTitle:@"取消" forState:UIControlStateNormal];
//    [five roundChangeWithRadius:18*MZ_RATE];
//    five.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [five setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [five setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [five setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [five addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 107*MZ_RATE, 315/2.0*MZ_RATE, 44*MZ_RATE)];
//    [containerView addSubview:one];
//    [one setTitle:@"取消" forState:UIControlStateNormal];
//    [one roundChangeWithRadius:18*MZ_RATE];
//    one.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [one setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [one setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [one setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [one addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 107*MZ_RATE, 315/2.0*MZ_RATE, 44*MZ_RATE)];
//    [containerView addSubview:one];
//    [one setTitle:@"取消" forState:UIControlStateNormal];
//    [one roundChangeWithRadius:18*MZ_RATE];
//    one.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [one setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [one setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [one setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [one addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 107*MZ_RATE, 315/2.0*MZ_RATE, 44*MZ_RATE)];
//    [containerView addSubview:one];
//    [one setTitle:@"取消" forState:UIControlStateNormal];
//    [one roundChangeWithRadius:18*MZ_RATE];
//    one.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [one setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [one setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [one setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [one addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 107*MZ_RATE, 315/2.0*MZ_RATE, 44*MZ_RATE)];
//    [containerView addSubview:one];
//    [one setTitle:@"取消" forState:UIControlStateNormal];
//    [one roundChangeWithRadius:18*MZ_RATE];
//    one.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [one setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [one setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [one setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [one addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 107*MZ_RATE, 315/2.0*MZ_RATE, 44*MZ_RATE)];
//    [containerView addSubview:one];
//    [one setTitle:@"取消" forState:UIControlStateNormal];
//    [one roundChangeWithRadius:18*MZ_RATE];
//    one.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [one setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [one setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [one setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [one addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *one = [[UIButton alloc] initWithFrame:CGRectMake(0, 107*MZ_RATE, 315/2.0*MZ_RATE, 44*MZ_RATE)];
//    [containerView addSubview:one];
//    [one setTitle:@"取消" forState:UIControlStateNormal];
//    [one roundChangeWithRadius:18*MZ_RATE];
//    one.titleLabel.font = [UIFont systemFontOfSize:14*MZ_RATE];
//    [one setTitleColor:MakeColorRGB(0x333333) forState:UIControlStateNormal];
//    [one setTitleColor:MakeColorRGB(0xFFFFFF) forState:UIControlStateSelected];
//    [one setBackgroundColor:MakeColorRGB(0xFFFFFF)];
//    [one addTarget:self action:@selector(reportButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
-(void)reportButtonClicked:(UIButton *)btn{
//    #FF2145
}
- (void)customAddSubviewsKickOut{
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 315*MZ_RATE, 151*MZ_RATE)];
    [self addSubview:containerView];
    containerView.backgroundColor = [UIColor whiteColor];
    [containerView roundChangeWithRadius:8*MZ_RATE ];
    containerView.center = self.center;
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20*MZ_RATE, containerView.width, 25*MZ_RATE)];
    [containerView addSubview:tipLabel];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor blackColor];
    tipLabel.font = [UIFont fontWithName:@"PingFangSC" size: 18*MZ_RATE];
    tipLabel.text = @"温馨提示";
    
    UILabel *tipInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0,56*MZ_RATE, containerView.width, 20*MZ_RATE)];
    [containerView addSubview:tipInfoLabel];
    tipInfoLabel.textAlignment = NSTextAlignmentCenter;
    tipInfoLabel.textColor = MakeColorRGB(0x666666);
    tipInfoLabel.font = [UIFont systemFontOfSize: 14*MZ_RATE];
    tipInfoLabel.text = @"您已被主播踢出了他的房间";
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake( 0,107*MZ_RATE, containerView.width, 0.5)];
    [containerView addSubview:line1];
    line1.backgroundColor = MakeColorRGB(0xDDDDDD);
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(157*MZ_RATE, 107*MZ_RATE, 0.5, 44*MZ_RATE)];
    [containerView addSubview:line2];
    line2.backgroundColor = MakeColorRGB(0xDDDDDD);
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 107*MZ_RATE, 315/2.0*MZ_RATE, 44*MZ_RATE)];
    [containerView addSubview:cancelButton];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:MakeColorRGB(0x999999) forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16*MZ_RATE];
    [cancelButton addTarget:self action:@selector(actionOne) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *otherButton = [[UIButton alloc] initWithFrame:CGRectMake(315/2.0*MZ_RATE, 107*MZ_RATE,315/2.0*MZ_RATE , 44*MZ_RATE)];
    [containerView addSubview:otherButton];
    [otherButton setTitle:@"获取资格" forState:UIControlStateNormal];
    [otherButton setTitleColor:MakeColorRGB(0x00DC58) forState:UIControlStateNormal];
    otherButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC" size: 16*MZ_RATE];
    
    [otherButton addTarget:self action:@selector(actionTwo) forControlEvents:UIControlEventTouchUpInside];
}
-(void)actionOne{
    [self removeFromSuperview];
}
-(void)actionTwo{
    if (self.clickBlock) {
        self.clickBlock(@"获取资格");
    }
}
@end
