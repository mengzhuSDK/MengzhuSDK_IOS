//
//  MZSendRedEnvelopesViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2021/1/4.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZSendRedEnvelopesViewController.h"
#import "MZSendRedEnvelopesLayout.h"

@interface MZSendRedEnvelopesViewController ()
@property (nonatomic, strong) MZSendRedEnvelopesLayout *layout;
@end

@implementation MZSendRedEnvelopesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发红包";
    self.view.backgroundColor = [UIColor redColor];
    
    self.layout = [[MZSendRedEnvelopesLayout alloc] initWithFrame:CGRectMake(0, kTopHeight, self.view.frame.size.width, self.view.frame.size.height - kTopHeight)];
    self.layout.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.layout];
    [self.layout initSubView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
