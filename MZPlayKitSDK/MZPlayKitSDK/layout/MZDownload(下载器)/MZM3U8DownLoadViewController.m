//
//  MZM3U8DownLoadViewController.m
//  批量下载和m3u8批量下载
//
//  Created by 李风 on 2020/3/23.
//  Copyright © 2020 李风. All rights reserved.
//

#import "MZM3U8DownLoadViewController.h"
#import "MZDownLoadCell.h"

@interface MZM3U8DownLoadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@interface MZM3U8DownLoadViewController ()

@end

@implementation MZM3U8DownLoadViewController

- (void)dealloc {
    NSLog(@"%@ 销毁了", NSStringFromClass([self class]));
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"下载";
    self.dataArray = @[].mutableCopy;
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    
    UIView *sortView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarHeight, UIScreen.mainScreen.bounds.size.width, 44.0)];
    sortView.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    [self.view addSubview:sortView];
    
    UIButton *sortButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sortButton setTitle:@"降序" forState:UIControlStateNormal];
    [sortButton setTitleColor:[UIColor colorWithRed:255/255.0 green:36/255.0 blue:91/255.0 alpha:1] forState:UIControlStateNormal];
    [sortButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sortButton addTarget:self action:@selector(sortButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    sortButton.frame = CGRectMake(self.view.frame.size.width - 64, 0, 64, 44);
    [sortView addSubview:sortButton];

    CGFloat bottomSpace = 15;
    if (IPHONE_X) {
        bottomSpace = 34 + 15;
    }
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 60 - bottomSpace, UIScreen.mainScreen.bounds.size.width, 60.0)];
    bottomView.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    [self.view addSubview:bottomView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"清空" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearAll:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(16*MZ_RATE, 10*MZ_RATE, 160*MZ_RATE, 40*MZ_RATE);
    [button.layer setCornerRadius:20*MZ_RATE];
    [button.layer setMasksToBounds:YES];
    [button.layer setBorderColor:[UIColor colorWithRed:255/255.9 green:36/255.0 blue:91/255.0 alpha:1].CGColor];
    [button.layer setBorderWidth:1.0];
    [bottomView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"新建任务" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor colorWithRed:255/255.9 green:36/255.0 blue:91/255.0 alpha:1]];
    [button1 addTarget:self action:@selector(addDownLoadData:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(self.view.frame.size.width - 176*MZ_RATE, 10*MZ_RATE, 160*MZ_RATE, 40*MZ_RATE);
    [button1.layer setCornerRadius:20*MZ_RATE];
    [button1.layer setMasksToBounds:YES];
    [bottomView addSubview:button1];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, sortView.frame.size.height+sortView.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-sortView.frame.size.height-sortView.frame.origin.y - bottomSpace - 60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MZDownLoadCell class] forCellReuseIdentifier:@"MZDownLoadCell"];
    [self.view addSubview:self.tableView];
    
    // 获取缓存的下载列表数据
    __block UILabel *loadingView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    loadingView.text = @"加载中...";
    loadingView.textAlignment = NSTextAlignmentCenter;
    loadingView.textColor = [UIColor whiteColor];
    [self.view addSubview:loadingView];
    loadingView.center = self.view.center;
        
    [loadingView removeFromSuperview];

    [[MZDownLoaderCenter shareInstanced] setTaskMaxCount:2];
    self.dataArray = [[MZDownLoaderCenter shareInstanced] getAllTask];
    [self.tableView reloadData];
    
    for (MZDownLoader *loader in self.dataArray) {
        if ([[MZDownLoaderCenter shareInstanced] getTaskState:loader] == MZDownLoaderState_Downloading) {
            [[MZDownLoaderCenter shareInstanced] start:loader];
        }
    }
}

- (void)sortButtonClick:(UIButton *)sender {
    [sender setTitle:([sender.titleLabel.text isEqualToString:@"降序"] ? @"升序" : @"降序") forState:UIControlStateNormal];
    
    self.dataArray = [[self.dataArray reverseObjectEnumerator] allObjects].mutableCopy;
    [self.tableView reloadData];
}

- (void)backButtonClick:(UIButton *)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clearAll:(UIButton *)sender {
    [[MZDownLoaderCenter shareInstanced] cancelAll];
    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)addDownLoadData:(UIButton *)sender {
    
    NSArray *list = @[@"http://vod01-o.zmengzhu.com/record/base/984a3888d1f1394300218740_200902105033.m3u8",
        @"http://vod01-o.zmengzhu.com/record/base/91e4100118dd26cb00209055_200809105723.m3u8",
                      @"http://vod01.zmengzhu.com/record/base/hls-sd/7a670abd1acabacc00127670_200106101116.m3u8",
        @"http://vod-o.t.zmengzhu.com/record/base/22a9457a1d14332d00085481.m3u8",
        @"http://vod01.zmengzhu.com/record/base/hls-sd/495eaffaca9bca2100127861_200111052003.m3u8",
                      @"http://vod01-o.zmengzhu.com/record/base/bafbd9a06339e83a00149677.m3u8",
                      @"http://vod-o.t.zmengzhu.com/record/base/6eab6cca45f2368b00086104.m3u8",
                      @"http://vod01.zmengzhu.com/record/base/hls-sd/0228089bcf8ab1ca00110584_190910104916.m3u8",
    ];

    static NSInteger index = -1;
    if (index == 5) {
        index = -1;
        NSLog(@"没有新的任务了，不能添加了啊");
        return;
    }
    index += 1;
    
    if ([[MZDownLoaderCenter shareInstanced] taskExits:[NSURL URLWithString:list[index]]]) {
        NSLog(@"任务已经存在了");
        return;
    }
    
    [[MZDownLoaderCenter shareInstanced] addDownloadWithM3u8URL:[NSURL URLWithString:list[index]] completeBlock:^(MZDownLoader *downloader, NSString *errorString) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errorString) {
                NSLog(@"errorString = %@",errorString);
            } else {
                self.dataArray = [[MZDownLoaderCenter shareInstanced] getAllTask];
//                [self.dataArray insertObject:downloader atIndex:0];
                [self reloadTableData];
                
                [[MZDownLoaderCenter shareInstanced] start:downloader];
            }
        });
    }];
}

- (void)allPause:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"全部暂停"]) {
        [sender setTitle:@"全部开始" forState:UIControlStateNormal];
        [[MZDownLoaderCenter shareInstanced] pauseAll];
    } else {
        [sender setTitle:@"全部暂停" forState:UIControlStateNormal];
        [[MZDownLoaderCenter shareInstanced] startAll];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)reloadTableData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [MZDownLoaderCenter shareInstanced].downloadsArray.count;
    return self.dataArray.count;
}

- (MZDownLoadCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZDownLoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZDownLoadCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        MZDownLoader *loader = self.dataArray[indexPath.row];
        [cell update:loader];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 135;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MZDownLoader *loader = self.dataArray[indexPath.row];
        [self.dataArray removeObject:loader];
        [[MZDownLoaderCenter shareInstanced] cancel:loader];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

@end
