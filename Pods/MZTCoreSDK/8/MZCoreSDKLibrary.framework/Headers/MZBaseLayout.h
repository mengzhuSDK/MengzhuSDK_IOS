//
//  MZBaseLayout.h
//  MengZhu
//
//  Created by 孙显灏 on 2019/7/29.
//  Copyright © 2019 孙显灏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZBaseLayoutProtocol.h"
#import "NSObject+MZPopoverProgressHub.h"

@protocol MZLayoutClickDelegate <NSObject>
@optional
-(void)onClickListener:(long)tag view:(UIView * _Nullable) view model:(MZBaseModel *_Nullable)model;
-(void)onClickListener:(long)tag view:(UIView * _Nullable) view map:(NSDictionary * _Nullable)map;
@end

@protocol MZLayoutContactDelegater <NSObject>

-(id _Nullable )onMessage:(NSInteger)type obj:(id _Nullable )obj,...;


@end

@interface MZBaseLayout : UIView<MZBaseLayoutProtocol>

@property(nonatomic,weak) UIViewController * _Nullable viewControll;
@property(nonatomic,weak) id<MZLayoutClickDelegate > _Nullable clickDelegate;
@property(nonatomic,weak) id<MZLayoutContactDelegater> _Nullable  contactDelegate;

-(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message btnTitle:(NSString *)btnTitle;

@end
