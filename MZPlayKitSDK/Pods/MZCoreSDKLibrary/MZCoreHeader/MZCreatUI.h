//
//  MZCreatUI.h
//  MZCoreSDKLibrary
//
//  Created by 李风 on 2020/9/28.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZCreatUI : NSObject

/** 创建 button */
+ (UIButton *)buttonWithTitle:(NSString *)title
                   titleColor:(UIColor *)titleColor
                         font:(float)font
                       target:(id)target
                          sel:(SEL)sel;
/** imageButton */
+ (UIButton *)imageButtonWithTitle:(NSString *)title
                             image:(UIImage*)image
                        titleColor:(UIColor *)titleColor
                              font:(float)font
                            target:(id)target
                               sel:(SEL)sel;

/** 创建 label 默认配置(居左，白色字体，透明背景色，CGRectZero) */
+ (UILabel *)labelWithText:(NSString *)text
                      font:(float)font;

/** 创建 label 默认配置(白色字体，透明背景色，CGRectZero)  */
+ (UILabel *)labelWithText:(NSString *)text
                      font:(float)font
             textAlignment:(NSTextAlignment)textAlignment;

/** 创建 label 默认配置(透明背景色，CGRectZero)  */
+ (UILabel *)labelWithText:(NSString *)text
                      font:(float)font
             textAlignment:(NSTextAlignment)textAlignment
                 textColor:(UIColor *)textColor;

/** 创建 label */
+ (UILabel *)labelWithText:(NSString *)text
                      font:(float)font
             textAlignment:(NSTextAlignment)textAlignment
                 textColor:(UIColor *)textColor
           backgroundColor:(UIColor *)backgroundColor;

/** 创建view */
+ (UIView *)viewWithBackgroundColor:(UIColor *)backgroundColor;

/** 创建 imageView 默认配置（UIViewContentModeScaleAspectFit，clearColor, CGRectZero） */
+ (UIImageView *)imageViewWithImageName:(NSString *)imageName;

/** 创建 imageView */
+ (UIImageView *)imageViewWithImageName:(NSString *)imageName
                                  model:(UIViewContentMode)model
                        backgroundColor:(UIColor *)backgroundColor
                                 enable:(BOOL)enable;


/** 创建 scrollView */
+ (UIScrollView *)scrollViewWithBackgroundColor:(UIColor *)backgroundColor
                                       delegate:(id _Nullable)delegate;

/** 创建 searchBar */
+ (UISearchBar *)searchBarWithDelegate:(id _Nonnull)delegate
                          barTintColor:(UIColor *_Nullable)barTintColor
                             tintColor:(UIColor *_Nullable)tintColor;

/** 创建 textField */
+ (UITextField *)textFieldWithPlaceHolder:(NSString *)placeHolder
                                     font:(float)font
                                 delegate:(id)delegate;

+ (UITextField *)textFieldWithBackgroundColor:(UIColor *)backgroundColor
                                     delegate:(id _Nonnull)delegate
                                         font:(float)font
                                    textColor:(UIColor *)textColor
                                textAlignment:(NSTextAlignment)textAlignment
                                         text:(NSString *)text
                                  placeHolder:(NSString *)placeHolder;

/** 创建 textView */
+ (UITextView *)textViewWithPlaceHolder:(NSString *)placeHolder
                                   font:(float)font
                               delegate:(id)delegate;

+ (UITextView *)textViewWithDelegate:(id _Nonnull)delegate
                                text:(NSString *)text
                           textColor:(UIColor *_Nullable)textColor
                                font:(float)font
                     backgroundColor:(UIColor *_Nullable)backgroundColor
                         placeHolder:(NSString *)placeHolder;

/** 创建 tableView */
+ (UITableView *)tableViewWithDelegate:(id _Nonnull)delegate
                     registerCellClass:(Class)registerCellClass;

/** 创建 collectionView */
+ (UICollectionView *)collectionViewithLayout:(UICollectionViewLayout *)layout
                                     delegate:(id _Nonnull)delegate
                            registerCellClass:(Class)registerCellClass;

/// 创建segmentedControl
+ (UISegmentedControl *)segmentedControlWithItems:(NSArray *)items
                                             font:(CGFloat)font
                           selectedSegmentedIndex:(NSInteger)selectedSegmentedIndex
                                        tintColor:(UIColor *)tintColor
                                           target:(id _Nonnull)target
                                              sel:(SEL)sel;
@end

NS_ASSUME_NONNULL_END
