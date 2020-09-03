//
//  MZActionSheetView.h
//  MengZhu
//
//  Created by vhall on 16/11/30.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void (^MZActionSheetBlock)(NSInteger itemFlag,NSString * btnTitle);
@interface MZActionSheetView : UIView

+(void)initWithMZActionSheetView:(MZActionSheetBlock)actionBlock actionTilte:(NSString *)actionTitle cancelBtnTitle:(NSString *)cancelTitle buttonKeys:(NSString *)key,...;

+(void)dismissActionView;

@end
