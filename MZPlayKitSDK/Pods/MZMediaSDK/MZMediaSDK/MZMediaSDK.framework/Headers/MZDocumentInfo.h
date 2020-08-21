//
//  MZDocumentInfo.h
//  MZKitDemo
//
//  Created by 李风 on 2020/7/15.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZDocumentInfo : NSObject<NSCoding>
@property (nonatomic,   copy) NSString *id;//文档列表里记录的文档ID
@property (nonatomic,   copy) NSString *file_name;//文件名字
@property (nonatomic,   copy) NSString *access_url;// 文档访问前缀 访问格式 access_url/1.png
@property (nonatomic,   copy) NSString *scale;// 图片缩放参数
@property (nonatomic, assign) NSInteger current_page;// 当前直播页数;
@property (nonatomic, assign) NSInteger page_count;// 文档总页数
@property (nonatomic,   copy) NSString *channelID;//频道ID
@property (nonatomic, strong) NSNumber *totalUnitCount;//文件大小（已下载才有值）
@property (nonatomic,   copy) NSString *document_id;//文档详情接口里记录的文档的ID
@property (nonatomic, assign) float amount;//下载价格

@property (nonatomic, assign) int status;//下载状态（0-不能下载，1-免费下载，2-允许付费下载，3-已经付费下载）

@property (nonatomic, assign) BOOL isHaveDownLoad;//是否已下载

@property (nonatomic, assign) float progress;//下载进度

@end

NS_ASSUME_NONNULL_END
