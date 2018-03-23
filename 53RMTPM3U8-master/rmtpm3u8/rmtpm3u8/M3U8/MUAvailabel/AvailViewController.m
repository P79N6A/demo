//
//  MUViewController.m
//  rmtpm3u8
//
//  Created by 何川 on 2018/3/20.
//  Copyright © 2018年 何川. All rights reserved.
//

#import "AvailViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "ZFPlayerView.h"

#import "PlayViewController.h"
#import "TVmodel.h"

@interface AvailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *itmeArray;

@end

@implementation AvailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

}

-(void)setupUI{
    self.title = @"选择频道";
    self.view.backgroundColor = kbackground;
    
    [self.view addSubview:self.tableView];
    __weak typeof(self) ws = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws makeData];
    }];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self makeData];

}
-(void)makeData{
  
    _itmeArray = [[[FMDBmanger shareManger] getAllTvModels] mutableCopy];

    [self.tableView reloadData];
    [_tableView.mj_header endRefreshing];
    
    
    
}

-(UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavH, kScreenW, kScreenH - kNavH - kBottomBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.separatorColor = k333;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _tableView.tableFooterView = [UIView new];
       
        
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _itmeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
        cell.textLabel.textColor = k333;

    }
    if (indexPath.row < _itmeArray.count) {
        TVmodel *model = _itmeArray[indexPath.row];
        cell.textLabel.text = model.title;
        
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < _itmeArray.count) {
        TVmodel *model = _itmeArray[indexPath.row];
        PlayViewController *vc = [[PlayViewController alloc] init];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (editingStyle) {
        case UITableViewCellEditingStyleNone:
        {
        }
            break;
        case UITableViewCellEditingStyleDelete:
        {
            TVmodel *model = _itmeArray[indexPath.row];
            [[FMDBmanger shareManger] deleateTvModel:model];
            
            //修改数据源，在刷新 tableView
            [_itmeArray removeObjectAtIndex:indexPath.row];

            //让表视图删除对应的行
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
            break;
        case UITableViewCellEditingStyleInsert:
        {
          
        }
            break;
            
        default:
            break;
    }

}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //插入
//        return UITableViewCellEditingStyleInsert;
    //删除
    return UITableViewCellEditingStyleDelete;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
