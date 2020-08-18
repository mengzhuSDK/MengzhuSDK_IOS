

#import <UIKit/UIKit.h>
#import "MZRefreshConst.h"

@class MZRefreshHeader, MZRefreshFooter;

@interface UIScrollView (MZRefresh)
/** 下拉刷新控件 */
@property (strong, nonatomic) MZRefreshHeader *MZ_header;
//@property (strong, nonatomic) MZRefreshHeader *header MZRefreshDeprecated("使用MZ_header");
/** 上拉刷新控件 */
@property (strong, nonatomic) MZRefreshFooter *MZ_footer;
//@property (strong, nonatomic) MZRefreshFooter *footer MZRefreshDeprecated("使用MZ_footer");

#pragma mark - other
- (NSInteger)MZ_totalDataCount;
//@property (copy, nonatomic) void (^MZ_reloadDataBlock)(NSInteger totalDataCount);
@end
