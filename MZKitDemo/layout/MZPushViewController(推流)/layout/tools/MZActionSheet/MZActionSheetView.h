//
//  MZActionSheetView.h
//  MengZhu
//
//  Created by vhall on 16/11/30.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import "MZBaseView.h"

typedef  void (^MZActionSheetBlock)(NSInteger itemFlag,NSString * btnTitle);
@interface MZActionSheetView : MZBaseView

+(void)initWithMZActionSheetView:(MZActionSheetBlock)actionBlock actionTilte:(NSString *)actionTitle cancelBtnTitle:(NSString *)cancelTitle buttonKeys:(NSString *)key,...;

+(void)dismissActionView;

@end
