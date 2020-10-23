//
//  MZUploadViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2020/10/12.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZUploadViewController.h"
#import "MZUploadCell.h"
#import <MZUploadVideoSDK/MZUploadVideoSDK.h>

@interface MZUploadViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <MZUploadVideoModel *> *dataArray;
@end

@implementation MZUploadViewController

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
    self.navigationItem.title = @"上传文件测试";
    
    /// 必须设置，设置用户信息，如若已经设置，这里不需要重复设置
    MZUser *user = [MZBaseUserServer currentUser];    
    if (!user) {//如果没有缓存的用户信息，这里生成一个
        user = [[MZUser alloc] init];
        user.uniqueID = @"user999";
        user.nickName = @"盟主user999";
        user.avatar = @"https://cdn.duitang.com/uploads/item/201410/26/20141026191422_yEKyd.thumb.700_0.jpeg";

        [MZBaseUserServer updateCurrentUser:user];
    }
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    
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
    [button1 setTitle:@"新建上传任务" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor colorWithRed:255/255.9 green:36/255.0 blue:91/255.0 alpha:1]];
    [button1 addTarget:self action:@selector(addUploadTask) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(self.view.frame.size.width - 176*MZ_RATE, 10*MZ_RATE, 160*MZ_RATE, 40*MZ_RATE);
    [button1.layer setCornerRadius:20*MZ_RATE];
    [button1.layer setMasksToBounds:YES];
    [bottomView addSubview:button1];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHeight, self.view.frame.size.width, self.view.frame.size.height-navBarHeight - bottomSpace - 60) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[MZUploadCell class] forCellReuseIdentifier:@"MZUploadCell"];
    [self.view addSubview:self.tableView];
    
    // 获取缓存的任务列表
    [self getCacheTasks];
}

/// 返回
- (void)backButtonClick:(UIButton *)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/// 获取缓存的任务列表
- (void)getCacheTasks {
    // 获取所有数据，注意，这里的self.dataArray不要实例化，直接使用上传中心的数据源
    self.dataArray = [MZUploadVideoManager shareInstanced].uploadModels;
    [self.dataArray enumerateObjectsUsingBlock:^(MZUploadVideoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // app每次重启，缓存路径都会改变，任务缓存的全路径就变了，这里需要重新拼接全路径
        if (![[NSFileManager defaultManager] fileExistsAtPath:obj.videoFullPath]) {
            obj.videoFullPath = [[NSBundle mainBundle] pathForResource:obj.videoObjectKey ofType:@""];
        }
    }];
    [self.tableView reloadData];
}

/// 清空
- (void)clearAll:(UIButton *)sender {
    [[MZUploadVideoManager shareInstanced] clearAllTasksFinish:^{
        [self.tableView reloadData];
    }];
}

/// 添加上传任务
- (void)addUploadTask {
    // 所上传视频支持 MP4,FLV,AVI 格式
    NSArray *videoNames = @[@"upload_test.MP4",@"upload_test3.MP4"];
    
    NSString *video_name = videoNames[arc4random()%2];
    
    //视频文件的唯一的key，因为app重启后路径会变化，所以保存此参数，下次启动app可通过此key拼接完整的路径。
    NSString *videoObjectKey = video_name;
    //拼接完整路径
    NSString *uploadFileFullPath = [[NSBundle mainBundle] pathForResource:videoObjectKey ofType:@""];

    // 用户自定义的视频名字，用于在视频库显示的名字
    NSString *file_name = video_name;

    [[MZUploadVideoManager shareInstanced] creatUploadTaskWithFullPath:uploadFileFullPath videoObjectKey:videoObjectKey file_name:file_name success:^(MZUploadVideoModel * _Nonnull uploadVideoModel) {
        NSLog(@"生成任务成功了 = %@", uploadVideoModel);
        [[MZUploadVideoManager shareInstanced] resumeTask:uploadVideoModel];
        [self.tableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"任务生成失败了 = %@",error.domain);
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZUploadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZUploadCell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        MZUploadVideoModel *loader = self.dataArray[indexPath.row];
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
        MZUploadVideoModel *loader = self.dataArray[indexPath.row];
        [[MZUploadVideoManager shareInstanced] cancelTask:loader finish:^{
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        }];
    }
}

@end
