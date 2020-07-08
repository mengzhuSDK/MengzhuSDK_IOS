//
//  MZDLNAView.m
//  MZKitDemo
//
//  Created by 李风 on 2020/5/12.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZDLNAView.h"
#import "MZSimpleHud.h"

@interface MZDLNAView ()<UITableViewDelegate,UITableViewDataSource,MZDLNADelegate>

@property (nonatomic, strong) UITableView *DLNASearchTab;
@property (nonatomic, strong) MZDLNA *dlnaManager;

@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) UILabel *emptyStatueL;
@property (nonatomic, assign) BOOL isClick;

@end

@implementation MZDLNAView

- (void)dealloc {
    [self stopDLNA];
    
    self.dlnaManager.delegate = nil;
    self.dlnaManager = nil;
    NSLog(@"投屏的View释放了");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    self.userInteractionEnabled = YES;
    
    UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MZ_SW, MZScreenHeight)];
    tapView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self addSubview:tapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callBackSearchView)];
    [tapView addGestureRecognizer:tap];

    self.fuctionView = [[UIView alloc] initWithFrame:CGRectMake(0, MZScreenHeight, MZ_SW, 278*MZ_RATE)];
    self.fuctionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.fuctionView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MZ_SW, 44*MZ_RATE)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.fuctionView addSubview:topView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.size.height - 1, topView.frame.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [topView addSubview:lineView];
    
    UILabel *exchangeL = [[UILabel alloc]initWithFrame:CGRectMake(16*MZ_RATE, 0, 90*MZ_RATE, 44*MZ_RATE)];
    exchangeL.font = FontSystemSize(14*MZ_RATE);
    exchangeL.textColor = [UIColor blackColor];
    exchangeL.text = @"选择投屏设备";
    [topView addSubview:exchangeL];
    
    self.refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(exchangeL.right, 0, 64*MZ_RATE, 44*MZ_RATE)];
    [self.refreshBtn addTarget:self action:@selector(beginToSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.refreshBtn setImage:[UIImage imageNamed:@"device_exchange"] forState:UIControlStateNormal];
    [topView addSubview:self.refreshBtn];
    [self startAnimated];
    
    UIButton *helpBtn = [[UIButton alloc]initWithFrame:CGRectMake(MZ_SW - 86*MZ_RATE, 0, 70*MZ_RATE, 44*MZ_RATE)];
    helpBtn.titleLabel.font = FontSystemSize(14*MZ_RATE);
    [helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [helpBtn setTitle:@"投屏帮助" forState:UIControlStateNormal];
    [helpBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:91/255.0 blue:41/255.0 alpha:1] forState:UIControlStateNormal];
//    [topView addSubview:helpBtn];
    
    self.DLNASearchTab = [[UITableView alloc]initWithFrame:CGRectMake(0, topView.bottom, MZ_SW, 188*MZ_RATE) style:UITableViewStylePlain];
    self.DLNASearchTab.dataSource = self;
    self.DLNASearchTab.delegate = self;
    self.DLNASearchTab.rowHeight = 44*MZ_RATE;
    self.DLNASearchTab.backgroundColor = [UIColor whiteColor];
    [self.fuctionView addSubview:self.DLNASearchTab];
    self.DLNASearchTab.tableFooterView = [UIView new];
    
    self.dlnaManager = [MZDLNA sharedMZDLNAManager];
    self.dlnaManager.delegate = self;
    
    self.emptyView = [[UIView alloc]initWithFrame:self.DLNASearchTab.bounds];
    self.emptyStatueL = [[UILabel alloc]initWithFrame:CGRectMake(0, 84*MZ_RATE, self.emptyView.width, 20*MZ_RATE)];
    self.emptyStatueL.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.emptyStatueL.font = FontSystemSize(14*MZ_RATE);
    self.emptyStatueL.text = @"正在搜索中...";
    self.emptyStatueL.backgroundColor = [UIColor whiteColor];
    self.emptyStatueL.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:self.emptyStatueL];
    [self.DLNASearchTab addSubview:self.emptyView];
    self.emptyView.hidden = NO;
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.DLNASearchTab.bottom, MZ_SW, 46*MZ_RATE)];
    [cancelBtn addTarget:self action:@selector(callBackSearchView) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FontSystemSize(16*MZ_RATE);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.fuctionView addSubview:cancelBtn];
    
    if (@available(iOS 11.0, *)) {
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            UIView *spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, self.fuctionView.frame.size.height, self.frame.size.width, 34.0)];
            spaceView.backgroundColor = [UIColor whiteColor];
            [self.fuctionView addSubview:spaceView];
        }
    }
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cancelBtn.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:244/255.0 alpha:1];
    [cancelBtn addSubview:lineView1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self beginToSearch];
    });
}

- (void)setDeviceArr:(NSArray *)deviceArr {
    _deviceArr = deviceArr;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endAnimated];
        self.isClick = NO;
        if(self.deviceArr.count == 0){
            self.emptyView.hidden = NO;
            self.emptyStatueL.text = @"请确保您的手机跟投屏设备在同一个Wi-Fi下";
            static int searchCount = 0;
            if (searchCount % 3 == 0) {
                [self beginToSearch];
            }
            searchCount++;
        }else{
            self.emptyView.hidden = YES;
        }
        [self.DLNASearchTab reloadData];
    });
}

- (void)beginToSearch {
    if(self.isClick){
        return;
    }
    self.isClick = YES;
    [self.dlnaManager startSearch];
    if(self.deviceArr.count == 0){
        self.emptyView.hidden = NO;
    }else{
        self.emptyView.hidden = YES;
    }
    self.emptyStatueL.text = @"正在搜索中...";
    [self startAnimated];
}

- (void)startAnimated {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.refreshBtn.layer addAnimation:animation forKey:nil];

}

- (void)endAnimated {
    [self.refreshBtn.layer removeAllAnimations];
}

- (void)helpBtnClick {
    if (self.helpClickBlock) {
        self.helpClickBlock();
    }
}

- (void)callBackSearchView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.33 animations:^{
            self.fuctionView.frame = CGRectMake(0, MZScreenHeight+34.0, MZ_SW, 278*MZ_RATE);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });
}

- (void)stopDLNA {
    [self.dlnaManager endDLNA];
    self.dlnaManager.device = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.deviceArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZ_DLNA_View_Cell"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MZ_DLNA_View_Cell"];
        cell.textLabel.textColor = [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    MZCLUPnPDevice *device = self.deviceArr[indexPath.row];
    NSLog(@"+++%@",device.friendlyName);
    cell.textLabel.text = device.friendlyName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.deviceArr.count) {
        MZCLUPnPDevice *model = self.deviceArr[indexPath.row];
        
        [MZSimpleHud show];
        [self callBackSearchView];
        
        self.dlnaManager.device = model;
        if (self.DLNAString.length) {
            self.dlnaManager.playUrl = self.DLNAString;
            [self.dlnaManager startDLNA];
        }
    }
}

#pragma mark MZDLNADelegate代理方法
/// DLNA局域网搜索设备结果
- (void)searchDLNAResult:(NSArray *)devicesArray {
    self.deviceArr = devicesArray;
}

/// 投屏成功开始播放
- (void)dlnaStartPlay {
    [MZSimpleHud hide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dlnaStartPlay)]) {
        [self.delegate dlnaStartPlay];
    }
}

@end
