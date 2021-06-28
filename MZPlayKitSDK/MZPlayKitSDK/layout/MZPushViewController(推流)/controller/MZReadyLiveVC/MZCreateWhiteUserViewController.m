//
//  MZCreateWhiteUserViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/3.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZCreateWhiteUserViewController.h"

typedef void(^Result)(void);

@interface MZCreateWhiteUserViewController ()
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *createView;

@property (nonatomic, copy) NSString *whiteId;

@property (nonatomic, copy) Result result;
@end

@implementation MZCreateWhiteUserViewController

- (void)dealloc
{
    NSLog(@"创建白名单用户界面释放");
}

- (instancetype)initWithWhiteId:(NSString *)whiteId result:(void(^)(void))result {
    self = [super init];
    if (self) {
        self.whiteId = whiteId;
        self.result = result;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"创建用户";

    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    
    UILabel *fLabel = [MZCreatUI labelWithText:@"手机号(多个手机号以\"，\"分开)" font:14 textAlignment:NSTextAlignmentLeft textColor:MakeColor(122, 122, 122, 1) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:fLabel];
    [fLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(11);
        make.top.equalTo(@(navBarHeight));
        make.right.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    UIView *tvView = [MZCreatUI viewWithBackgroundColor:MakeColor(255, 255, 255, 0.15)];
    [self.view addSubview:tvView];
    [tvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(fLabel.mas_bottom);
        make.height.equalTo(@(124));
    }];
    
    self.textView = [MZCreatUI textViewWithDelegate:self text:@"" textColor:[UIColor whiteColor] font:14 backgroundColor:[UIColor clearColor] placeHolder:@"请输入内容"];
    [tvView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tvView).offset(24);
        make.top.equalTo(tvView).offset(6);
        make.right.equalTo(tvView).offset(-6);
        make.bottom.equalTo(tvView).offset(-6);
    }];
    
    [self.view addSubview:self.createView];
    [self.createView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        
        CGFloat bottom = 0;
        if (@available(iOS 11.0, *)) {
            if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
                bottom = 34.0;
            }
        }
        make.height.equalTo(@(60+bottom));
    }];
}

- (void)toCreate {
    NSString *phones = self.textView.text;
    phones = [phones stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (phones.length <= 0) {
        [self.view show:@"请输入手机号"];
        return;
    }
    
    NSArray *phone_array = [phones componentsSeparatedByString:@","];
    BOOL isComplianceRules = YES;
    NSString *error_phone = @"";
    
    NSMutableArray *post_phones = @[].mutableCopy;
    
    for (NSString *phone in phone_array) {
        if (phone.length <= 0) {
            continue;;
        }
        if ([phone isPhone] == NO) {
            error_phone = phone;
            isComplianceRules = NO;
            break;
        }
        [post_phones addObject:phone];
    }
    if (isComplianceRules == NO) {
        [self.view show:[NSString stringWithFormat:@"手机号输入有误，请检查：%@",error_phone]];
        return;
    }
    if (post_phones.count <= 0) {
        [self.view show:@"请输入有效手机号"];
        return;
    }
    NSString *post_phones_string = [post_phones componentsJoinedByString:@","];
    
    [MZSDKBusinessManager batchfAddUserWhiteWithWhiteId:self.whiteId phones:post_phones_string success:^(id response) {
        [self.navigationController popViewControllerAnimated:YES];
        if (self.result) self.result();
    } failure:^(NSError *error) {
        [self.view show:error.domain];
    }];
}

- (UIView *)createView {
    if (!_createView) {
        _createView = [[UIView alloc] init];
        _createView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.15];
        
        UIButton *newButton = [MZCreatUI buttonWithTitle:@"创建" titleColor:[UIColor whiteColor] font:14 target:self sel:@selector(toCreate)];
        newButton.backgroundColor = MakeColor(255, 31, 96, 0.8);
        [newButton.layer setCornerRadius:20];
        [_createView addSubview:newButton];
        newButton.frame = CGRectMake(46, 10, MZScreenWidth - 92, 40);
    }
    return _createView;
}

@end
