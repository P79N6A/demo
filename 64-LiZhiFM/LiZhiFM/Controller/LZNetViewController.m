//
//  LZNetViewController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZNetViewController.h"
#import "LZNavigationController.h"

#import "RadioCell.h"
#import "LZPlayView.h"

#import "LZliveChannelModel.h"
//#import "LZData.h"
#import "TTZADMob.h"

#import <MJExtension/MJExtension.h>

@interface LZNetViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LZNetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self loadData];
    [self setUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI{
    [self.view addSubview:self.tableView];
    if (![TTZADMob sharedInstance].isRemoveAd) {
        __weak typeof(self) weakSelf = self;
//        [[TTZADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        [TTZADMob GADBannerViewOnBelowNavWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        self.tableView.contentInset = UIEdgeInsetsMake(adH, 0, 0, 0);
    }

}

//- (void)loadData{
//
//    NSArray *network = [[LZData homeDict] valueForKey:@"Network"];
//    self.models = [LZliveChannelModel mj_objectArrayWithKeyValuesArray:network];
//}

#pragma mark  - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RadioCell"];
    //cell.backgroundColor = [UIColor orangeColor];
    LZliveChannelModel *model = self.models[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    LZliveChannelModel *model = self.models[indexPath.row];
    if (!model.live_stream) {
        model.live_stream = model.streams.firstObject.url;
    }
    LZNavigationController *nav = (LZNavigationController *)self.navigationController;
    LZPlayView *playView = nav.playView;
    playView.model = model;

}
#pragma mark  -  get/set 方法
-(UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
;
        
        _tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        //_tableView.rowHeight = UITableViewAutomaticDimension;
        //_tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = 125;//165;//IS_PAD?400:200;
        
        //_tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"RadioCell" bundle:nil] forCellReuseIdentifier:@"RadioCell"];
        _tableView.backgroundColor = kBackgroundColor;
        
    }
    return _tableView;
}



@end
