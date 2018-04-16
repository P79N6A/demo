//
//  ViewController.m
//  English
//
//  Created by Jay on 2018/4/12.
//  Copyright © 2018年 Jay. All rights reserved.
//

#import "TTZHomeViewController.h"
#import "PlayViewController.h"
#import "VideoListController.h"

#import "TTZBanner.h"
#import "TTZEnglishCell.h"

#import "Common.h"
#import "XYYData.h"
#import "LBLADMob.h"



@interface TTZHomeViewController ()
<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray <NSString *> *imgs;
@property (nonatomic, strong) NSArray <NSString *> *titles;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation TTZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //
    //
    self.view.backgroundColor = [UIColor orangeColor];
    self.imgs = @[
                  @"https://upload-images.jianshu.io/upload_images/1274527-5c46b366f4a4ef61.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                  @"https://upload-images.jianshu.io/upload_images/1274527-a0bc7693cf0fc08c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                  @"https://upload-images.jianshu.io/upload_images/1274527-57a5a5b89619f9d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                  @"https://upload-images.jianshu.io/upload_images/1274527-a8f0e255cb18b25c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                  @"https://upload-images.jianshu.io/upload_images/1274527-d50d8b583b6d57cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                  @"https://upload-images.jianshu.io/upload_images/1274527-b8c52d7e60b741b0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                  @"https://upload-images.jianshu.io/upload_images/1274527-1e3b4145cfaf0a67.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                  @"https://upload-images.jianshu.io/upload_images/1274527-0149e85b2abfb31e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",
                  @"https://upload-images.jianshu.io/upload_images/1274527-08fb59041f331885.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"];
    
    self.titles = @[
                    @"日常口语大全",
                    @"生活英语大全",
                    @"快速入门英语",
                    @"实用英语口语",
                    @"英语技巧大全",
                    @"老外日常英语",
                    @"留学毕学英语",
                    @"英语七天基础",
                    @"看美剧学英语",
                    ];
    
    [self tableView];
    self.navigationItem.title = @"课程";

    if (![LBLADMob sharedInstance].isRemoveAd) {
        __weak typeof(self) weakSelf = self;
        [LBLADMob GADBannerViewTabbarHeightWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, adH, 0);
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    }

}




-(UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        //_tableView.rowHeight = IS_PAD?400:200;
        
        //_tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [_tableView registerNib:[UINib nibWithNibName:@"TTZEnglishCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
//        UIView *bgView = [[UIView alloc] initWithFrame:self.view.bounds];
//        
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        
//        gradientLayer.locations = @[@0.0, @1.0];
//        
//        gradientLayer.startPoint = CGPointMake(0.5, 0);
//        
//        gradientLayer.endPoint = CGPointMake(0.5, 1);
//        
//        [bgView.layer addSublayer:gradientLayer];
//        
//        gradientLayer.colors = @[ (__bridge id)kColorWithHexString(0x209cff).CGColor,(__bridge id)kColorWithHexString(0x68e0cf).CGColor];
//        
//        gradientLayer.frame = CGRectMake(-1, -1,bgView.bounds.size.width+2, bgView.bounds.size.height+2);
        
        //_tableView.backgroundView = bgView;
        _tableView.backgroundColor = kBackgroundColor;
        TTZBanner *headerView = [TTZBanner headerView];
        headerView.frame = CGRectMake(0, 0, 0, 145);//220
        _tableView.tableHeaderView = headerView;
        
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TTZEnglishCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.titleLB.text = self.titles[indexPath.row];
    cell.dics = [XYYData englishData:indexPath.row];
    
    cell.didSelect = ^(NSInteger selectIndex, NSArray *dics) {
        
        PlayViewController *playVC = [PlayViewController new];
        playVC.selectIndex = selectIndex;
        playVC.dics = dics;
        playVC.mainTitle = self.titles[indexPath.row];
        [self.navigationController pushViewController:playVC animated:YES];
    };
    cell.seeAllBlock = ^(NSArray *dics) {
        VideoListController *playVC = [VideoListController new];
        playVC.dics = dics;
        playVC.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:playVC animated:YES];
    };
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.titles.count;
}



@end
