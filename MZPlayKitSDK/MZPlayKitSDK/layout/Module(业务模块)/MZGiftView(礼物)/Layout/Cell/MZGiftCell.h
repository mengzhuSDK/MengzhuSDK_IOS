//
//  MZGiftCell.h
//  MZKitDemo
//
//  Created by 李风 on 2020/8/19.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZGiftModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZGiftCell : UICollectionViewCell

@property (nonatomic, strong) UIView *selectedView;//选中展示的View

- (void)update:(MZGiftModel *)gift;

@end

NS_ASSUME_NONNULL_END
