//
//  VideoListController.m
//  English
//
//  Created by czljcb on 2018/4/15.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "VideoListController.h"
#import "PlayViewController.h"

#import "EnglishItemCell.h"

#import "Common.h"
#import "XYYHTTP.h"
#import "LBLADMob.h"

#import <UIImageView+WebCache.h>


@interface VideoListController ()
<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end

@implementation VideoListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"EnglishItemCell" bundle:nil] forCellWithReuseIdentifier:@"EnglishItemCell"];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    self.layout.itemSize = CGSizeMake((w - 3)* 0.5, (w -3)* 0.5);
    
    self.layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    self.collectionView.backgroundColor = kBackgroundColor;
    
    
    if (![LBLADMob sharedInstance].isRemoveAd) {
        __weak typeof(self) weakSelf = self;
        [LBLADMob GADBannerViewNoTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
        self.collectionView.scrollIndicatorInsets = self.collectionView.contentInset;
        if (KBOOLLINE) {
            ////AD
            [[LBLADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        }
    }


}
- (void)setDics:(NSArray *)dics{
    _dics = dics;
    [self.collectionView reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    EnglishItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EnglishItemCell" forIndexPath:indexPath];
    NSDictionary *dic = self.dics[indexPath.item];
    cell.titleLB.text = [dic valueForKey:@"title"];
    [cell.imageIV sd_setImageWithURL:[NSURL URLWithString:[dic valueForKey:@"img"]] placeholderImage:nil];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dics.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PlayViewController *playVC = [PlayViewController new];
    playVC.selectIndex = indexPath.item;
    playVC.dics = self.dics;
    playVC.mainTitle = self.title;
    [self.navigationController pushViewController:playVC animated:YES];

}

@end
