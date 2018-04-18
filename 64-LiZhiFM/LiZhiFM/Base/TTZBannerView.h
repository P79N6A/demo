
#import <UIKit/UIKit.h>


@interface TTZBannerCell : UICollectionViewCell
@property (weak, nonatomic)  UIImageView *iconView;
@end


@interface TTZBannerView : UIView

@property(nonatomic, strong) NSArray *models;

@property(nonatomic, copy)void (^selectItemAtIndexPath)(id);

@end
