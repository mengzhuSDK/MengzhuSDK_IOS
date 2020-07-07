//
//  MZActivityMenu.h
//  MZKitDemo
//
//  Created by 李风 on 2020/5/14.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MZActivityMenuDelegate <NSObject>
// 点击的索引
- (void)activityMenuClickWithIndex:(NSInteger)index;
@end

@interface MZActivityMenu : UIView

@property (nonatomic, weak) id<MZActivityMenuDelegate>delegate;

/**
 * @brief 添加菜单和菜单对应的view
 *
 * @param menu 菜单的名字
 * @param menuView 菜单对应的view
 *
 */
- (void)addMenu:(NSString *)menu menuView:(UIView *)menuView;

/**
 * @brief 恢复隐藏前的view
 */
- (void)recoveryMenuView;

/**
 * @brief 隐藏所有索引的view
 */
- (void)hideAllMenu;

@end

NS_ASSUME_NONNULL_END
