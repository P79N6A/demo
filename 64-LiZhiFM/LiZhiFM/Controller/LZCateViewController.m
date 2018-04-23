//
//  LZCateViewController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/21.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZCateViewController.h"
#import "LZNetViewController.h"

#import "RadioCell.h"

#import "LZliveChannelModel.h"
#import "LZData.h"

#import "LZHTTP.h"
#import "LZCommon.h"
#import "TTZADMob.h"

#import <MJExtension/MJExtension.h>




//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(...)
//#endif

@interface LZCateViewController ()
<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <LZliveChannelModel *> *models;
//@property (nonatomic, assign) NSInteger num;

@end

@implementation LZCateViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
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
        //[[TTZADMob sharedInstance] GADInterstitialWithVC:weakSelf];
        [TTZADMob GADBannerViewOnBelowNavWithVC:weakSelf];
        int adH = IS_PAD?90:50;
        self.tableView.contentInset = UIEdgeInsetsMake(adH, 0, 0, 0);
    }

}

- (void)loadData{
    
    NSArray *network = [[LZData homeDict] valueForKey:@"cate"];
    self.models = [LZliveChannelModel mj_objectArrayWithKeyValuesArray:network];
}

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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LZliveChannelModel *model = self.models[indexPath.row];
    [self loadData:model];
}

- (void)loadData:(LZliveChannelModel *)model{
    [self.view showLoading:@"loading..."];
    [[LZHTTP sharedInstance] getRequest:@"http://pacc.radio.cn/channels/getlivebyparam"
                             parameters:@{@"channelPlaceId":model.Id}
                                success:^(id respones) {
                                    [self.view hideLoading:nil];
                                    NSArray *liveChannels = [respones valueForKey:@"liveChannel"];
                                    if ([liveChannels isKindOfClass:[NSArray class]]) {
                                        
                                       
                                       
//                                        @property (nonatomic, copy) NSString *name;
//                                        @property (nonatomic, copy) NSString *img;
//                                        @property (nonatomic, copy) NSString *liveSectionName;
//                                        @property (nonatomic, strong) NSArray <LZStreamModel *>*streams;
//                                        @property (nonatomic, copy) NSString *live_stream;

                                        NSArray <LZliveChannelModel *>*models = [LZliveChannelModel mj_objectArrayWithKeyValuesArray:liveChannels];
                                        LZNetViewController *vc = [LZNetViewController new];
                                        vc.title = model.name;
                                        vc.models = models;
                                        
//                                        NSLog(@"@\"%@\": @[",model.name)
//                                        [models enumerateObjectsUsingBlock:^(LZliveChannelModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                                            NSLog(@"@{@\"name\":@\"%@\",@\"img\":@\"%@\",@\"liveSectionName\":@\"%@\",@\"live_stream\":@\"%@\"},",obj.name,obj.img ,obj.liveSectionName,obj.streams.firstObject.url);
//                                        }];
//                                        NSLog(@"],")
//
//                                        self.num ++;
//                                        if (self.num >= self.models.count) {
//                                            return ;
//                                        }
//                                        LZliveChannelModel *m = self.models[self.num];
//                                        [self loadData:m];
//
//                                        return ;
                                        [self.navigationController pushViewController:vc animated:YES];
                                    }
                                }
                                failure:^(NSError *error) {
                                    [self.view hideLoading:nil];
                                }];
}


#pragma mark  -  get/set 方法
-(UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarAndNavigationBarHeight, kScreenW, kScreenH-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        
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
