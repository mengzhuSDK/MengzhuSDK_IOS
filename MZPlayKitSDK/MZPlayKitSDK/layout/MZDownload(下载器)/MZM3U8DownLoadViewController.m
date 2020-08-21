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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"下载";
    self.dataArray = @[].mutableCopy;
        
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[MZDownLoadCell class] forCellReuseIdentifier:@"MZDownLoadCell"];
    [self.view addSubview:self.tableView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 44.0)];
    topView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = topView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"添加" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addDownLoadData:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.view.frame.size.width - 64, 0, 44, 44);
    [topView addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"全部开始" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(allPause:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(self.view.frame.size.width - 64 - 110, 0, 110, 44);
    [topView addSubview:button1];
    
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

- (void)backButtonClick:(UIButton *)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addDownLoadData:(UIButton *)sender {
    
    NSArray *list = @[@"http://vod01-o.zmengzhu.com/record/base/91e4100118dd26cb00209055_200809105723.m3u8",
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
    return 100;
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
