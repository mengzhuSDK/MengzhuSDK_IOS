//
//  UIView+MZPlayPermission.m
//  MZKitDemo
//
//  Created by 李风 on 2020/9/10.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "UIView+MZPlayPermission.h"

/**
* @brief 添加点击block回调的button
*/
typedef void (^ButtonTapBlock)(UIButton *sender);

@interface MZCheckButton : UIButton
@property (nonatomic, copy) ButtonTapBlock tapBlock;
- (void)addTapBlock:(ButtonTapBlock)block;
@end

@implementation MZCheckButton
- (void)addTapBlock:(ButtonTapBlock)tapBlock {
    _tapBlock = tapBlock;
    [self addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonAction:(UIButton *)button {
    if (_tapBlock) {
        _tapBlock(button);
    }
}
@end

/**
 * @brief 权限检测接口请求类
 */
@interface MZCheckPermissionPresenter : NSObject

@end

@implementation MZCheckPermissionPresenter
/**
 * 观看视频权限检测
 *
 * @param ticketId 直播活动Id
 * @param phone 用户手机号，选填参数，仅验证白名单使用
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)checkPlayPermissionWithTicketId:(NSString *)ticketId phone:(NSString *)phone success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure {
    [MZSDKBusinessManager checkPlayPermissionWithTicketId:ticketId phone:phone success:success failure:failure];
}

/**
 * 观看视频 使用F码
 *
 * @param ticketId 直播活动Id
 * @param fCode F码
 * @param success 成功回调
 * @param failure 失败原因回调
 */
+(void)useFCodeWithTicketId:(NSString *)ticketId fCode:(NSString *)fCode success:(void(^)(id responseObject))success failure:(void (^)(NSError *))failure {
    [MZSDKBusinessManager useFCodeWithTicketId:ticketId fCode:fCode success:success failure:failure];
}
@end

typedef enum : NSUInteger {
    MZPlayPermissionModel_Free = 1,//免费
    MZPlayPermissionModel_Vip = 2,//vip
    MZPlayPermissionModel_Money = 3,//付费
    MZPlayPermissionModel_Password = 4,//密码
    MZPlayPermissionModel_WhiteList = 5,//白名单观看
    MZPlayPermissionModel_FCode = 6,//F码观看
} MZPlayPermissionModel;//观看权限模式

@implementation UIView (MZPlayPermission)

/**
 * @brief 检测观看权限
 *
 * @param ticketId 直播活动ID
 * @param phone 用户手机号
 * @param success 权限检测结果的回调
 * @param cancelButtonClick 返回按钮点击事件
 */
- (void)checkPlayPermissionWithTicketId:(NSString *)ticketId phone:(NSString *)phone success:(void(^)(BOOL isPermission))success cancelButtonClick:(void(^)(void))cancelButtonClick {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    indicatorView.frame = CGRectMake(0, 0, 15, 15);
    indicatorView.center = self.center;
    [self addSubview:indicatorView];
    [indicatorView startAnimating];
    
    [MZCheckPermissionPresenter checkPlayPermissionWithTicketId:ticketId phone:phone success:^(id responseObject) {
//        "view_mode": 6, // 视频观看模式 1:免费 2:vip 3:付费 4:密码  5:白名单观看 6:F码观看
//        "allow_play": 1 // 是否有权限观看 0:否 1:是
        NSLog(@"权限检测返回的数据 =%@",responseObject);
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        
        MZPlayPermissionModel view_model = [responseObject[@"view_mode"] integerValue];
        BOOL allow_play = [responseObject[@"allow_play"] boolValue];
        
        if (allow_play) {
            success(YES);
            return;
        }
        
        // 这里只处理了F码和白名单，其他情况请自行处理
        switch (view_model) {
            case MZPlayPermissionModel_WhiteList: {//白名单
                [self showNoPermissionOfWhiteListWithCancelButtonClick:cancelButtonClick];
                success(NO);
                break;
            }
            case MZPlayPermissionModel_FCode: {//F码
                [self checkPermissionOfFCodeSuccess:success ticketId:ticketId cancelButtonClick:cancelButtonClick];
                break;
            }
            default: {
                success(YES);
                break;
            }
        }
    } failure:^(NSError *error) {
        [self show:error.localizedDescription];
        [indicatorView stopAnimating];
        [indicatorView removeFromSuperview];
        success(YES);
    }];
}

/// F码观看权限检测
- (void)checkPermissionOfFCodeSuccess:(void(^)(BOOL isPermission))success ticketId:(NSString *)ticketId cancelButtonClick:(void(^)(void))cancelButtonClick {

    MZCheckButton *fCodeView = [[MZCheckButton alloc] initWithFrame:self.bounds];
    fCodeView.backgroundColor = [UIColor colorWithRed:122/255.0 green:122/255.0 blue:122/255.0 alpha:0.8];
    [self addSubview:fCodeView];
    
    UILabel *noPermissionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 180, self.frame.size.width - 100, 90.0)];
    noPermissionLabel.numberOfLines = 0;
    noPermissionLabel.font = [UIFont systemFontOfSize:16*MZ_RATE];
    noPermissionLabel.backgroundColor = [UIColor clearColor];
    noPermissionLabel.textColor = [UIColor whiteColor];
    noPermissionLabel.textAlignment = NSTextAlignmentCenter;
    noPermissionLabel.text = @"该视频设置了F码\n\n请输入正确F码观看";
    [fCodeView addSubview:noPermissionLabel];
    
    NSDictionary *attrDict = @{NSFontAttributeName:[UIFont systemFontOfSize:14*MZ_RATE],NSForegroundColorAttributeName:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5]};
    
    NSMutableAttributedString *placeAttr = [[NSMutableAttributedString alloc] initWithString:@"请输入F码" attributes:attrDict];
    
    UITextField *fCodeTF = [[UITextField alloc] initWithFrame:CGRectMake(54*MZ_RATE, noPermissionLabel.frame.size.height+noPermissionLabel.frame.origin.y+30*MZ_RATE, self.frame.size.width - 108*MZ_RATE, 36*MZ_RATE)];
    fCodeTF.backgroundColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1];
    fCodeTF.textColor = [UIColor whiteColor];
    fCodeTF.font = [UIFont systemFontOfSize:14*MZ_RATE];
    fCodeTF.layer.cornerRadius = 4;
    fCodeTF.layer.masksToBounds = YES;
    [fCodeTF setAttributedPlaceholder:placeAttr];
    [fCodeView addSubview:fCodeTF];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, fCodeTF.frame.size.height)];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, fCodeTF.frame.size.height)];
    fCodeTF.leftViewMode = UITextFieldViewModeAlways;
    fCodeTF.rightViewMode = UITextFieldViewModeAlways;
    fCodeTF.leftView = leftView;
    fCodeTF.rightView = rightView;
    
    MZCheckButton *checkButton = [MZCheckButton buttonWithType:UIButtonTypeCustom];
    checkButton.frame = CGRectMake(54*MZ_RATE, fCodeTF.frame.size.height + fCodeTF.frame.origin.y + 20*MZ_RATE, self.frame.size.width - 108*MZ_RATE, 36*MZ_RATE);
    [checkButton setTitle:@"确定" forState:UIControlStateNormal];
    checkButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:0.8];
    [checkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkButton.titleLabel setFont:[UIFont systemFontOfSize:14*MZ_RATE]];
    [fCodeView addSubview:checkButton];
    
    MZCheckButton *cancelButton = [MZCheckButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake((self.frame.size.width - 60*MZ_RATE)/2.0, checkButton.frame.size.height + checkButton.frame.origin.y + 40*MZ_RATE, 60*MZ_RATE, 21);
    [cancelButton setTitle:@"原路返回" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [cancelButton setTitleColor:[UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
    [fCodeView addSubview:cancelButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2, cancelButton.frame.size.height - 1, cancelButton.frame.size.width-4, 1)];
    line.backgroundColor = [UIColor colorWithRed:255/255.0 green:31/255.0 blue:96/255.0 alpha:1];
    [cancelButton addSubview:line];
    
    __weak typeof(fCodeView) weakFCodeView = fCodeView;
    __weak typeof(fCodeTF) weakTF = fCodeTF;

    [checkButton addTapBlock:^(UIButton *sender) {
        [weakTF resignFirstResponder];
        if (weakTF.text.length) {
            NSLog(@"去请求数据");
            [MZCheckPermissionPresenter useFCodeWithTicketId:ticketId fCode:weakTF.text success:^(id responseObject) {
                success(YES);
                [weakFCodeView removeFromSuperview];
            } failure:^(NSError *error) {
                [weakFCodeView show:error.domain];
                success(NO);
            }];
        }
    }];
    
    [cancelButton addTapBlock:^(UIButton *sender) {
        [weakFCodeView removeFromSuperview];
        cancelButtonClick();
    }];
    
    [fCodeView addTapBlock:^(UIButton *sender) {
        [weakTF resignFirstResponder];
    }];
}

/// 白名单观看权限检测
- (void)showNoPermissionOfWhiteListWithCancelButtonClick:(void(^)(void))cancelButtonClick {

    UIView *fCodeView = [[UIView alloc] initWithFrame:self.bounds];
    fCodeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self addSubview:fCodeView];
    
    UILabel *noPermissionLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 180, self.frame.size.width - 100, 90.0)];
    noPermissionLabel.numberOfLines = 0;
    noPermissionLabel.font = [UIFont systemFontOfSize:16*MZ_RATE];
    noPermissionLabel.backgroundColor = [UIColor clearColor];
    noPermissionLabel.textColor = [UIColor whiteColor];
    noPermissionLabel.textAlignment = NSTextAlignmentCenter;
    noPermissionLabel.text = @"该视频设置了观看权限\n\n您没有权限观看，请联系管理员获取";
    [fCodeView addSubview:noPermissionLabel];
    
    MZCheckButton *cancelButton = [MZCheckButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake((self.frame.size.width - 94*MZ_RATE)/2.0, noPermissionLabel.frame.size.height + noPermissionLabel.frame.origin.y + 20*MZ_RATE, 94*MZ_RATE, 30*MZ_RATE);
    [cancelButton setTitle:@"原路返回" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16*MZ_RATE]];
    [cancelButton setTitleColor:[UIColor colorWithRed:160/255.0 green:172/255.0 blue:191/255.0 alpha:1] forState:UIControlStateNormal];
    [cancelButton.layer setCornerRadius:15];
    [cancelButton.layer setMasksToBounds:YES];
    [cancelButton.layer setBorderColor:[UIColor colorWithRed:160/255.0 green:172/255.0 blue:191/255.0 alpha:1].CGColor];
    [cancelButton.layer setBorderWidth:1.0];
    [fCodeView addSubview:cancelButton];
    
    __weak typeof(fCodeView) weakFCodeView = fCodeView;
    
    [cancelButton addTapBlock:^(UIButton *sender) {
        cancelButtonClick();
        [weakFCodeView removeFromSuperview];
    }];
}

@end
