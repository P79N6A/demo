
#import <UIKit/UIKit.h>

@interface XYYCacheCell : UITableViewCell

@property (nonatomic, strong) UILabel *cacheLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, assign) BOOL update;

- (void)removeCache;

@end
