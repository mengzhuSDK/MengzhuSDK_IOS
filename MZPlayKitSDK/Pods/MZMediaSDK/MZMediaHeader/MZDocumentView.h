//
//  MZDocumentView.h
//  MZKitDemo
//
//  Created by 李风 on 2020/7/15.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZDocumentListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZDocumentView : UIView

@property (nonatomic, strong) UIButton *menuButton;//文档菜单按钮
@property (nonatomic, strong) UILabel *menuLabel;//文档标题

@property (nonatomic, strong) UILabel *pageLabel;//页数索引Label
@property (nonatomic, strong) UIButton *leftButton;//左侧按钮
@property (nonatomic, strong) UIButton *rightButton;//右侧按钮
@property (nonatomic, strong) UIButton *narrowButton;//缩小按钮
@property (nonatomic, strong) UIButton *magnifyButton;//放大按钮

@property (nonatomic, strong) UICollectionView *collectionView;//某个文档的所有图片的collectionView

@property (nonatomic, strong) MZDocumentListView *documentListView;//从下向上弹出的文档列表View

/**
 * @brief 初始化文档
 *
 * @param frame frame
 * @param live_status 直播状态 0:未开播 1:直播 2:回放 3:断流
 * @param channelID 频道ID
 * @param ticketID 活动ID，直播时可以为空
 * @return self
 */
- (instancetype)initWithFrame:(CGRect)frame
                  live_status:(int)live_status
                    channelID:(NSString *)channelID
                     ticketID:(NSString * _Nullable)ticketID;

/**
 * @brief 直播状态下切换 直播的文档页面
 *
 * @param pageURLString 切换的文档URLString地址
 * @param documentName 文档名字
 */
- (void)changeDoucmentPage:(NSString *)pageURLString documentName:(NSString *)documentName;

/**
 * @brief 文档销毁时，调用的方法
 *
 */
- (void)destory;

@end

NS_ASSUME_NONNULL_END
