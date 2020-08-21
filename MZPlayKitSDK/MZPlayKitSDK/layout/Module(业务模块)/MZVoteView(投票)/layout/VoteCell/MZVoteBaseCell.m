//
//  MZVoteBaseCell.m
//  MZMediaSDK
//
//  Created by 李风 on 2020/7/20.
//  Copyright © 2020 mengzhu.com. All rights reserved.
//

#import "MZVoteBaseCell.h"

@implementation MZVoteBaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.normalImage = [UIImage imageNamed:@"MZ_Vote_Weixuanzhong"];
        self.selectImage = [UIImage imageNamed:@"MZ_Vote_Xuanzhong"];
    }
    return self;
}

- (void)updateInfo:(MZVoteOptionModel *)optionModel voteSelectedIds:(NSMutableSet * _Nullable)voteSelectedIds voteInfo:(MZVoteInfoModel *)voteInfoModel {

}

@end
