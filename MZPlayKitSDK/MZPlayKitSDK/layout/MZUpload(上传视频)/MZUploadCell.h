//
//  MZUploadCell.h
//  MZKitDemo
//
//  Created by 李风 on 2020/10/13.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MZUploadVideoSDK/MZUploadVideoSDK.h>

NS_ASSUME_NONNULL_BEGIN

@interface MZUploadCell : UITableViewCell
- (void)update:(MZUploadVideoModel *)loader;
@end

NS_ASSUME_NONNULL_END
