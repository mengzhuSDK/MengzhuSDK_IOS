//
//  MZCreateFCodeViewController.m
//  MZKitDemo
//
//  Created by 李风 on 2021/6/3.
//  Copyright © 2021 mengzhu.com. All rights reserved.
//

#import "MZCreateFCodeViewController.h"

typedef void(^IsCreatedBlock)(BOOL isCreated);

@interface MZCreateFCodeViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UITextField *countTextField;

@property (nonatomic, strong) UIView *createView;

@property (nonatomic, copy) IsCreatedBlock createdBlock;
@property (nonatomic, assign) BOOL isCreated;

@end

@implementation MZCreateFCodeViewController

- (void)dealloc
{
    if (self.isCreated == NO) {
        if (self.createdBlock) self.createdBlock(NO);
    }
    NSLog(@"创建F码界面释放");
}

- (instancetype)initWithIsCreated:(void(^)(BOOL isCreated))isCreated {
    self = [super init];
    if (self) {
        self.isCreated = NO;
        self.createdBlock = isCreated;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.title = @"新建F码";
    
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height+[UIApplication sharedApplication].statusBarFrame.size.height;
    
    UILabel *fLabel = [MZCreatUI labelWithText:@"F码名称" font:14 textAlignment:NSTextAlignmentLeft textColor:MakeColor(122, 122, 122, 1) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:fLabel];
    [fLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(11);
        make.top.equalTo(@(navBarHeight));
        make.right.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    
    self.textField = [MZCreatUI textFieldWithBackgroundColor:MakeColor(255, 255, 255, 0.15) delegate:self font:14 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft text:@"" placeHolder:@"请输入F码"];
    UIView *view = [MZCreatUI viewWithBackgroundColor:[UIColor clearColor]];
    view.frame = CGRectMake(0, 0, 30, 44);
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField.leftView = view;
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(fLabel.mas_bottom);
        make.height.equalTo(@(44));
    }];
    
    UILabel *dLabel = [MZCreatUI labelWithText:@"F码描述" font:14 textAlignment:NSTextAlignmentLeft textColor:MakeColor(122, 122, 122, 1) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:dLabel];
    [dLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(11);
        make.top.equalTo(self.textField.mas_bottom);
        make.right.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    
    UIView *tvView = [MZCreatUI viewWithBackgroundColor:MakeColor(255, 255, 255, 0.15)];
    [self.view addSubview:tvView];
    [tvView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(dLabel.mas_bottom);
        make.height.equalTo(@(124));
    }];
    
    self.textView = [MZCreatUI textViewWithDelegate:self text:@"" textColor:[UIColor whiteColor] font:14 backgroundColor:[UIColor clearColor] placeHolder:@"请输入F码描述"];
    [tvView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tvView).offset(24);
        make.top.equalTo(tvView).offset(6);
        make.right.equalTo(tvView).offset(-6);
        make.bottom.equalTo(tvView).offset(-6);
    }];
    
    UILabel *cLabel = [MZCreatUI labelWithText:@"创建F码数量" font:14 textAlignment:NSTextAlignmentLeft textColor:MakeColor(122, 122, 122, 1) backgroundColor:[UIColor clearColor]];
    [self.view addSubview:cLabel];
    [cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(11);
        make.top.equalTo(tvView.mas_bottom);
        make.right.equalTo(self.view);
        make.height.equalTo(@(44));
    }];
    
    self.countTextField = [MZCreatUI textFieldWithBackgroundColor:MakeColor(255, 255, 255, 0.15) delegate:self font:14 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft text:@"" placeHolder:@"请输入F码创建数量"];
    UIView *countView = [MZCreatUI viewWithBackgroundColor:[UIColor clearColor]];
    countView.frame = CGRectMake(0, 0, 30, 44);
    self.countTextField.leftViewMode = UITextFieldViewModeAlways;
    self.countTextField.leftView = countView;
    [self.view addSubview:self.countTextField];
    [self.countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(cLabel.mas_bottom);
        make.height.equalTo(@(44));
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
    if (self.textField.text.length <= 0) {
        [self.view show:@"请输入F码名称"];
        return;
    }
    if (self.textView.text.length <= 0) {
        [self.view show:@"请输入F码描述"];
        return;
    }
    [MZSDKBusinessManager createFCodeWithName:self.textField.text desc:self.textView.text num:[self.countTextField.text intValue] success:^(id response) {
        NSString *fCodeId = [NSString stringWithFormat:@"%@",response[@"fcode_id"]];
        [MZSDKBusinessManager addFCodeWithFCode_id:fCodeId num:[self.countTextField.text intValue] success:^(id response) {
            self.isCreated = YES;
            if (self.createdBlock) self.createdBlock(YES);
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self.view show:error.domain];
        }];
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
