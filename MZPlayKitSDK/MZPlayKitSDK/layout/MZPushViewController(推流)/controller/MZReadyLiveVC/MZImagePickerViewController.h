//
//  MZImagePickerViewController.h
//  MengZhu
//
//  Created by vhall on 16/11/29.
//  Copyright © 2016年 www.mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZImagePickerViewController : UIImagePickerController

@property(nonatomic,copy) void(^imageBlock)(UIImage * imageBlock);

@property (nonatomic,assign) CGFloat ratio;//宽高比

@end
