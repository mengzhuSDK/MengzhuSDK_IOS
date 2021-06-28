//
//  MZSendRedEnvelopesLayout.m
//  MZKitDemo
//
//  Created by 李风 on 2021/1/4.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZSendRedEnvelopesLayout.h"
#import "MZSegmentedView.h"

@interface MZSendRedEnvelopesLayout()<MZSegmentedViewSelectDelegate>
@property (nonatomic, strong) MZSegmentedView *segmentedView;

@property (nonatomic ,strong) UILabel *awokeLabel;

@end

@implementation MZSendRedEnvelopesLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)initSubView {
    
    UIView *envelopesTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44*MZ_RATE)];
    envelopesTypeView.backgroundColor = [UIColor redColor];
    [self addSubview:envelopesTypeView];

    _segmentedView = [[MZSegmentedView alloc]initWithFrame:CGRectMake((MZ_SW - 188*MZ_RATE)/2.0, 0, 188*MZ_RATE , 44*MZ_RATE)];
    _segmentedView.backgroundColor = MakeColorRGB(0xf12405);
    _segmentedView.isSeparatorLine = NO;
    _segmentedView.titleFont = FontSystemSize(12*MZ_RATE);;
    _segmentedView.selectTitleFont = FontSystemSize(18*MZ_RATE);
    _segmentedView.titleColor = MakeColorRGB(0xffffff);
    _segmentedView.selectColor = MakeColorRGB(0xffffff);
    _segmentedView.delegate = self;
    _segmentedView.selectBlowColor = MakeColorRGB(0xffffff);
    _segmentedView.buttonArray = [NSMutableArray arrayWithArray:@[@"随机红包",@"定额红包"]];
    _segmentedView.widthFloat = 100;
    _segmentedView.buttonDown.hidden = YES;
    [envelopesTypeView addSubview:_segmentedView];
    
    
    
    
    CGFloat yValue = self.frame.size.height - 10 - 18;
    if (IPHONE_X) {
        yValue = yValue - 34;
    }
    self.awokeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, yValue, MZ_SW, 18 )];
    [self addSubview:self.awokeLabel];
    self.awokeLabel.text = @"未领取的红包，将于24小时后发起退款";
    self.awokeLabel.textAlignment = NSTextAlignmentCenter;
    self.awokeLabel.font = [UIFont systemFontOfSize:12];
    self.awokeLabel.textColor = MakeColorRGB(0x9B9B9B);
    
}

#pragma mark MZSegmentedViewSelectDelegate
-(void)segmentedViewTitleSelectWithIndex:(NSInteger)index
{
    if(index == 0){//选中第一个标签

    }else{//选中第二个标签

    }
}

@end
