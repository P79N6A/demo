//
//  ViewController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/16.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZHomeController.h"

#import "TTZBannerView.h"

#import "LZliveChannelModel.h"

#import "LZHTTP.h"

#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>



@interface LZHomeController ()<UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <LZliveChannelModel *> *models;
@end

@implementation LZHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUI];
    [self loadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI{
    [self.view addSubview:self.tableView];
}


- (void)loadData{
    [self.view showLoading:@"loading..."];
    [[LZHTTP sharedInstance] getRequest:@"http://pacc.radio.cn/channels/getlivebyparam"
                             parameters:@{@"channelPlaceId":@"3225"}
                                success:^(id respones) {
                                  
                                    NSArray *liveChannels = [respones valueForKey:@"liveChannel"];
                                    if ([liveChannels isKindOfClass:[NSArray class]]) {
                                        self.models = [LZliveChannelModel mj_objectArrayWithKeyValuesArray:liveChannels];
                                        [self.tableView reloadData];
                                    }
                                    [self.view hideLoading:nil];
                                }
                                failure:^(NSError *error) {
                                    [self.view hideLoading:nil];
                                }];
}


#pragma mark  - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.backgroundColor = [UIColor orangeColor];
    return cell;
}

#pragma mark  -  get/set 方法
-(UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        //_tableView.delegate = self;
        
        _tableView.dataSource = self;
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        //_tableView.rowHeight = IS_PAD?400:200;
        
        //_tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerNib:[UINib nibWithNibName:@"TTZEnglishCell" bundle:nil] forCellReuseIdentifier:@"TTZEnglishCell"];
        //_tableView.backgroundColor = [UIColor clearColor];
        
        
//        TTZBannerView *headerView = [TTZBannerView new];
//        headerView.frame = CGRectMake(0, 0, 0, 145);//220
        
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 180)];
        UIView *toolView = [[UIView alloc] init];
        UIButton *netBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [netBtn setImage:[UIImage imageNamed:@"zuire"] forState:UIControlStateNormal];
        [netBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [netBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        [netBtn setTitle:@"网络" forState:UIControlStateNormal];
        [netBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        UIButton *cateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cateBtn setImage:[UIImage imageNamed:@"fenlei"] forState:UIControlStateNormal];
        [cateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,10)];
        [cateBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        [cateBtn setTitle:@"分类" forState:UIControlStateNormal];
        [cateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        UIView *line = [UIView new];
        
        
        [headerView addSubview:toolView];
        toolView.backgroundColor = [UIColor yellowColor];
        
        [toolView addSubview:netBtn];
        netBtn.backgroundColor = [UIColor whiteColor];

        [toolView addSubview:line];
        line.backgroundColor = [UIColor blueColor];
        
        [toolView addSubview:cateBtn];
        cateBtn.backgroundColor = [UIColor whiteColor];

        
        [toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(headerView).offset(0);
            make.height.mas_equalTo(35);
        }];
        
        [netBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(toolView).offset(0);
            make.right.equalTo(line.mas_left).offset(0);
        }];

        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(toolView).offset(2.5);
            make.bottom.equalTo(toolView).offset(-2.5);

            make.right.equalTo(cateBtn.mas_left).offset(0);
            make.width.mas_equalTo(0.5);
            make.centerX.equalTo(toolView.mas_centerX);
        }];

        
        [cateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(toolView).offset(0);
            make.width.equalTo(netBtn.mas_width);
        }];

        
        _tableView.tableHeaderView = headerView;
        
    }
    return _tableView;
}



@end
