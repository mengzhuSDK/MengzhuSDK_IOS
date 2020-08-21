//
//  MZDocumentListView.h
//  MZPlayKitSDK
//
//  Created by 李风 on 2020/7/16.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MZDocumentInfo;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MZDocumentMethodTypeClose = 1,//关闭文档列表
    MZDocumentMethodTypeSelect,//选择某一个文档
} MZDocumentMethodType;

typedef void(^DocumentMethodHandler)(MZDocumentMethodType methodType, MZDocumentInfo * _Nullable document);

@interface MZDocumentListView : UIView

@property (nonatomic,   copy) DocumentMethodHandler methodHandler;//事件回调

@property (nonatomic, strong) UIView *headerView;//顶部的标题栏
@property (nonatomic, strong) UILabel *menuLabel;//标题
@property (nonatomic, strong) UIButton *closeButton;//关闭按钮
@property (nonatomic, strong) UIView *lineView;//线

@property (nonatomic, strong) UITableView *tableView;//tableView

/**
 * @brief 展示文档列表
 *
 * @param documentId 文档ID
 * @param data 文档列表数据源
 * @param channelId 频道ID
 * @param ticketId 活动ID
 */
- (void)showWithDocumentId:(NSString *)documentId data:(NSMutableArray *)data channelId:(NSString *)channelId ticketId:(NSString *)ticketId;

@end

NS_ASSUME_NONNULL_END
