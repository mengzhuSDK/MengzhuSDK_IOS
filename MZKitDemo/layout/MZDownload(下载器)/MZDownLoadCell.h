//
//  MZDownLoadCell.h
//  批量下载和m3u8批量下载
//
//  Created by 李风 on 2020/3/23.
//  Copyright © 2020 李风. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MZM3U8DownLoaderSDK/MZM3U8DownLoaderSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZDownLoadCell : UITableViewCell<MZDownLoaderDelegate>
- (void)update:(MZDownLoader *)loader;
@end

NS_ASSUME_NONNULL_END
