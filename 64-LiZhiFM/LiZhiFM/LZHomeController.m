//
//  ViewController.m
//  LiZhiFM
//
//  Created by czljcb on 2018/4/16.
//  Copyright © 2018年 czljcb. All rights reserved.
//

#import "LZHomeController.h"
#import "TTZBannerView.h"

@interface LZHomeController ()
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation LZHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUI{
    [self.view addSubview:self.tableView];
}


-(UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        //_tableView.delegate = self;
        
        //_tableView.dataSource = self;
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 200;
        //_tableView.rowHeight = IS_PAD?400:200;
        
        //_tableView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
        
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [_tableView registerNib:[UINib nibWithNibName:@"TTZEnglishCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = kBackgroundColor;
        TTZBanner *headerView = [TTZBanner headerView];
//        headerView.frame = CGRectMake(0, 0, 0, 145);//220
//        _tableView.tableHeaderView = headerView;
        
        //[self.view addSubview:_tableView];
        
    }
    return _tableView;
}



@end
