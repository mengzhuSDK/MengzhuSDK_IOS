//
//  PushViewController.m
//  MZLiveSDK
//
//  Created by 孙显灏 on 2018/10/22.
//  Copyright © 2018年 孙显灏. All rights reserved.
//

#import "PushViewController.h"
#import "TestLiveStream.h"
#import "Constant.h"
@interface PushViewController ()
@property (nonatomic, strong) TestLiveStream *testVideoCapture;
@end

@implementation PushViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self setNavigationbar];
}

- (void)setNavigationbar

{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, NavY, screenRect.size.width, NavH)];
    
    //    navigationBar.tintColor = COLOR(200, 100, 162);;
    
    //创建UINavigationItem
    
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"推流"];
    
    [navigationBar pushNavigationItem: navigationBarTitle animated:YES];
    
    [self.view addSubview: navigationBar];
    
    //创建UIBarButton 可根据需要选择适合自己的样式
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(navigationBackButton:)];
    
    //设置barbutton
    
    navigationBarTitle.leftBarButtonItem = item;
    
    [navigationBar setItems:[NSArray arrayWithObject: navigationBarTitle]];
    
    
    
}
-(void)navigationBackButton:(UIBarButtonItem *)item{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
    

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.testVideoCapture = [[TestLiveStream alloc] initWithViewController:self];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.testVideoCapture onLayout];
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
